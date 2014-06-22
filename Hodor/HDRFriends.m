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
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            that.friendsList = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"HDRFriendsList"]];
        });
    }
    return that;
}

- (NSMutableArray *)getFriends
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.friendsList.count; i++)
    {
        HDRUser *user = self.friendsList[i];
        if (!user.isBlocked)
        {
            [list addObject:user];
        }
    }
    
    return list;
}

- (void)addFriend:(HDRUser *)user
{
    [self.friendsList addObject:user];
    [self save];
}

- (void)deleteFriend:(HDRUser *)user
{
    [self.friendsList removeObject:user];
    [self save];
}

- (void)blockFriend:(HDRUser *)user
{
    user.isBlocked = YES;
    [self save];
}

- (void)save
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.friendsList forKey:@"HDRFriendsList"];
}

@end
