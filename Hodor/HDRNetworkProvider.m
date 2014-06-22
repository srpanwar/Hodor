//
//  WMNetworkProvider.m
//  WhereMSG
//
//  Created by Shailesh Panwar on 3/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRNetworkProvider.h"

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
    if(error == nil && response.statusCode == 200 && ![EMPTY_GUID isEqualToString:uuid])
    {
        [HDRCurrentUser setUUID:uuid];
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


- (NSString *)encBody:(NSString *)input
{
    return input;
}


@end



