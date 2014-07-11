//
//  WMNetworkProvider.m
//  WhereMSG
//
//  Created by Shailesh Panwar on 3/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRNetworkProvider.h"

@interface HDRNetworkProvider ()

@end

@implementation HDRNetworkProvider

+ (HDRNetworkProvider *) instance
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
    if (!userName)
    {
        return NO;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=createuser&username=%@", userName];
    body = [self doHash:body];

    
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
            [self sendRemoteNotificationsDeviceToken:[HDRCurrentUser getDeviceToken]];
        });
        return YES;
    }
    
    return NO;
}


-(void) sendHODOR:(NSString *)recipient
{
    if (!recipient)
    {
        return;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=sendhodor&sender=%@&recipient=%@", [HDRCurrentUser getCurrentUserName], recipient];
    body = [self doHash:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",ret);
    
    return;
}

- (void)sendText:(NSString *)recipient text:(NSString *)text
{
    if (!recipient || !text)
    {
        return;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=sendtext&sender=%@&recipient=%@&text=%@", [HDRCurrentUser getCurrentUserName], recipient, text];
    body = [self doHash:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",ret);
    
    return;
}


- (BOOL) blockUser:(NSString *)userName
{
    if (!userName)
    {
        return NO;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=blockuser&blocker=%@&blockee=%@", [HDRCurrentUser getCurrentUserName], userName];
    body = [self doHash:body];
    
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
    if (!deviceToken || ![HDRCurrentUser getCurrentUserName])// || [HDRCurrentUser isNotificationTokenSet])
    {
        return;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=setdevicetoken&username=%@&devicetoken=%@", [HDRCurrentUser getCurrentUserName], [self stringWithPercentEscape:deviceToken]];
    body = [self doHash:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error == nil && response.statusCode == 200)
    {
        [HDRCurrentUser setNotificationTokenSet];
    }
}

- (NSString *)doHash:(NSString *)input
{
    NSData *dataIn = [[NSString stringWithFormat:@"%@%@",input, ENC_GUID] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *hashData = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(dataIn.bytes, (CC_LONG)dataIn.length, hashData.mutableBytes);
    
    NSString *base64String = [hashData base64EncodedStringWithOptions:0];
    base64String =[self stringWithPercentEscape:base64String];
    
    input = [NSString stringWithFormat:@"%@&authtoken=%@", input, base64String];
    return input;
}

- (NSString*)stringWithPercentEscape:(NSString *)input
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                 NULL,
                                                                 (CFStringRef)[input mutableCopy],
                                                                 NULL, 
                                                                 CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/%-=^_`{|}~"), 
                                                                 kCFStringEncodingUTF8));
}

@end




