//
//  HDRUpdater.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRUpdater.h"

@implementation HDRUpdater


+ (void)update
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [defaults stringForKey:@"HRDVersion"];
    //version = @"";
    
    if(!version.length)
    {
        [self migrateToV20];
        version = @"2.0";
    }
    
    if([version isEqualToString:@"2.0"])
    {
        [defaults setObject:@"2.0" forKey:@"HRDVersion"];
    }
}

+ (void)migrateToV20
{
//    //anywhere
//    {
//        HDRUser *user = [[HDRUser alloc] init];
//        user.name = @"#ANYWHERE";
//        user.lastSeenId = 0;
//        user.isBlocked = 0;
//        user.userType = ANYWHERE_CHANNEL_ID;
//        [[HDRFriends instance] addFriend:user];
//    }
//    
//    //here
//    {
//        HDRUser *user = [[HDRUser alloc] init];
//        user.name = @"#HERE";
//        user.lastSeenId = 0;
//        user.isBlocked = 0;
//        user.userType = HERE_CHANNEL_ID;
//        [[HDRFriends instance] addFriend:user];
//    }
}

@end
