//
//  HDRFriends.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRFriends.h"

@interface HDRFriends ()

@property NSMutableArray *friendsList;
@property BOOL refreshNeeded;

@end

@implementation HDRFriends

+ (HDRFriends *) instance
{
    static HDRFriends *that = nil;
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            that = [[self alloc] init];
            that.refreshNeeded = YES;
            that.friendsList = [NSMutableArray arrayWithArray:[that readArrayWithCustomObjFromUserDefaults:@"HDRFriendsList"]];
        });
    }
    return that;
}

- (NSMutableArray *)getFriends
{
    static NSMutableArray *list = nil;
    @synchronized(self)
    {
        if (list == nil)
        {
            list = [[NSMutableArray alloc] init];
        }
        
        if(self.refreshNeeded)
        {
            [list removeAllObjects];
            for (int i = 0; i < self.friendsList.count; i++)
            {
                HDRUser *user = self.friendsList[i];
                if (!user.isBlocked)
                {
                    [list addObject:user];
                }
            }
            self.refreshNeeded = NO;
        }
    }
    return list;
}

- (void)moveToTop:(HDRUser *)user
{
    @synchronized(self)
    {
        [self.friendsList removeObject:user];
        [self.friendsList insertObject:user atIndex:0];
        [self save];
        self.refreshNeeded = YES;
    }
}


- (BOOL)isFriend:(NSString *)userName
{
    @synchronized(self)
    {
        for (int i = 0; i < self.friendsList.count; i++)
        {
            HDRUser *user = self.friendsList[i];
            if ([[user.name lowercaseString] isEqualToString:[userName lowercaseString]])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (HDRUser *)getFriend:(NSString *)userName
{
    @synchronized(self)
    {
        for (int i = 0; i < self.friendsList.count; i++)
        {
            HDRUser *user = self.friendsList[i];
            if ([[user.name lowercaseString] isEqualToString:[userName lowercaseString]])
            {
                return user;
            }
        }
    }
    
    return nil;
}

- (void) setLastSyncTimeNow:(NSString *)userName
{
    @synchronized(self)
    {
        HDRUser *user = [self getFriend:userName];
        if (user)
        {
            user.lastSeenId = [HDRDateUtil utcNowTicks];
            [self save];
        }
    }

}


- (HDRUser *)findFriend:(NSString *)userName
{
    @synchronized(self)
    {
        for (int i = 0; i < self.friendsList.count; i++)
        {
            HDRUser *user = self.friendsList[i];
            if ([[user.name lowercaseString] isEqualToString:[userName lowercaseString]])
            {
                return user;
            }
        }
    }
    
    return nil;
}


- (void)addFriend:(HDRUser *)user
{
    @synchronized(self)
    {
        [self.friendsList insertObject:user atIndex:0];
        [self save];
        self.refreshNeeded = YES;
    }
}

- (void)deleteFriend:(HDRUser *)user
{
    @synchronized(self)
    {
        
        [self.friendsList removeObject:user];
        [self save];
        self.refreshNeeded = YES;
    }
}

- (void)blockFriend:(HDRUser *)user
{
    @synchronized(self)
    {
        user.isBlocked = YES;
        [self save];
        self.refreshNeeded = YES;
    }
}

- (void)save
{
    [self writeArrayWithCustomObjToUserDefaults:@"HDRFriendsList" withArray:self.friendsList];
}


-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    [defaults setObject:data forKey:keyName];
    [defaults synchronize];
}

-(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:keyName];
    NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    return myArray;
}

@end
