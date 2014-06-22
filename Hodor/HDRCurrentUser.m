//
//  HDRCurrentUser.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRCurrentUser.h"

@implementation HDRCurrentUser

NSString *userName;
NSString *UUID;
NSString *UUENCID;

+(NSString *) getCurrentUserName
{
    if (!userName)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        userName = [defaults stringForKey:@"HDRUserName"];
    }
    return userName;
}


+(void) setCurrentUserName:(NSString *) name
{
    if (name)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:name forKey:@"HDRUserName"];
        userName = name;
    }
    return;
}

+(NSString *) getUUID
{
    //get the last good known coordinate
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

@end
