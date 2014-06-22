//
//  WMNetworkProvider.m
//  WhereMSG
//
//  Created by Shailesh Panwar on 3/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRNetworkProvider.h"

@interface HDRNetworkProvider ()

@property NSString *deviceToken;

@end

@implementation HDRNetworkProvider

+ (id) instance
{
    static HDRNetworkProvider *that = nil;
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            that = [[self alloc] init];
        });
    }
    return that;
}

-(BOOL) createUserName:(NSString *)userName
{
    return YES;
    
    if (!userName)
    {
        return NO;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:CREATE_USER_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"username=%@", userName];
    body = [self encBody:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *uuid = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    //mark it delivered in db
    if(error == nil && response.statusCode == 200 && uuid && uuid.length && ![EMPTY_GUID isEqualToString:uuid])
    {
        [HDRCurrentUser setUUID:uuid];
        [HDRCurrentUser setCurrentUserName:userName];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self sendRemoteNotificationsDeviceToken:self.deviceToken];
        });
        return YES;
    }
    
    return NO;
}


-(void) sendHODOR:(NSString *)recipient
{
    return;
    
    if (!recipient)
    {
        return;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:SEND_HODOR_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"to=%@&from=%@", recipient, [HDRCurrentUser getCurrentUserName]];
    body = [self encBody:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

- (BOOL) blockUser:(NSString *)userName
{
    return YES;
    
    if (!userName)
    {
        return NO;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:BLOCK_USER_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"blockee=%@&blocker=%@", userName, [HDRCurrentUser getCurrentUserName]];
    body = [self encBody:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return error == nil && response.statusCode == 200;
}

- (void)sendRemoteNotificationsDeviceToken:(NSString *)deviceToken
{
    return;
 
    self.deviceToken = deviceToken;
    if (!deviceToken || ![HDRCurrentUser getCurrentUserName])
    {
        return;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:SEND_DEVICETOKEN_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"devicetoken=%@&username=%@", deviceToken, [HDRCurrentUser getCurrentUserName]];
    body = [self encBody:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

}

- (NSString *)encBody:(NSString *)input
{
    return input;
}


@end




