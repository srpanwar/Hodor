//
//  HDRCommon.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRConfig.h"

@interface HDRConfig () {
    NSDictionary *configDictionary;
}

@end

@implementation HDRConfig

+ (HDRConfig *) instance
{
    static HDRConfig *that = nil;
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            that = [[self alloc] init];
        });
    }
    
    return that;
}

- (void)initConfig
{
    if (!configDictionary)
    {
        configDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]];
    }
}

- (NSString *)emptyGuid
{
    return [self getObjectForKey:@"emptyGuid"];
}

- (NSString *)privateKey
{
    return [self getObjectForKey:@"privateKey"];
}

- (NSString *)serviceEndPoint
{
    return [self getObjectForKey:@"serviceEndPoint"];
}

- (NSString *)messageTemplateEndPoint
{
    return [self getObjectForKey:@"messageTemplateEndPoint"];
}

- (NSString *)homePageUrl
{
    return [self getObjectForKey:@"homePageUrl"];
}

- (NSString *)itunesUrl
{
    return [self getObjectForKey:@"itunesUrl"];
}

- (NSString *)getObjectForKey:(NSString *)key
{
    [self initConfig];
    return [configDictionary objectForKey:key];
}


@end
