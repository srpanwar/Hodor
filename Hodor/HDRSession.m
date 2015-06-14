//
//  HDRCurrentUser.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRSession.h"

@implementation HDRSession

static NSString *userName;
static NSString *UUID;
static NSString *UUENCID;
static NSString *deviceToken;
static NSString *address;

+ (NSString *) getCurrentUserName
{
    if (!userName)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        userName = [defaults stringForKey:@"HDRUserName"];
    }
    return userName;
}


+ (void) setCurrentUserName:(NSString *) name
{
    if (name)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:name forKey:@"HDRUserName"];
        userName = name;
    }
    return;
}

+ (NSString *) getDeviceToken
{
    if (!deviceToken)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        userName = [defaults stringForKey:@"HDRDeviceToken"];
    }
    return deviceToken;
}


+ (void) setDeviceToken:(NSString *) dt
{
    if (dt)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dt forKey:@"HDRDeviceToken"];
        deviceToken = dt;
    }
    return;
}



+ (NSString *) getUUID
{
    if (!UUID)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        UUID = [defaults stringForKey:@"HDRUUID"];
    }
    
    return UUID;
}

+ (void) setUUID:(NSString *) uuid
{
    if (uuid && uuid.length)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UUID forKey:@"HDRUUID"];
    }
}

+ (BOOL)isNotificationTokenSet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *flag = [defaults stringForKey:@"HDRNotificationTokenSet"];

    return flag && flag.length;
}


+ (void) setNotificationTokenSet
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"set" forKey:@"HDRNotificationTokenSet"];
    return;
}

+ (NSString *) getAddress
{
    return address;
}

+ (void) setAddress:(NSString *)addr
{
    address = addr;
}


@end
