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
            that.triviaList = [NSMutableArray arrayWithArray:@[@"How is it going?",
                                                               @"Where are you?",
                                                               @"Almost there",
                                                               @"Ready?",
                                                               @"I am ready",
                                                               @"Talk to you soon",
                                                               @"I'm running late",
                                                               @"I am here",
                                                               @"Miss you",
                                                               @"I love you",
                                                               @"Call me when you get this",
                                                               @"Oye!"]];
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


-(void) sendHODORToChannel:(NSString *)recipient
{
    [self sendHODOR:@"sendhodortochannel" recipient:recipient];
}

-(void) sendHODOR:(NSString *)recipient
{
    [self sendHODOR:@"sendhodor" recipient:recipient];
}

-(void) sendHODOR:(NSString *)method recipient:(NSString *)recipient
{
    if (!recipient)
    {
        return;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=%@&sender=%@&recipient=%@", method, [HDRCurrentUser getCurrentUserName], recipient];
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

- (void)sendTextToChannel:(NSString *)recipient text:(NSString *)text
{
    [self sendText:@"sendtexttochannel" recipient:recipient text:text];
}

- (void)sendText:(NSString *)recipient text:(NSString *)text
{
    [self sendText:@"sendtext" recipient:recipient text:text];
}

- (void)sendText:(NSString *)method recipient:(NSString *)recipient text:(NSString *)text
{
    if (!recipient || !text)
    {
        return;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=%@&sender=%@&recipient=%@&text=%@", method, [HDRCurrentUser getCurrentUserName], recipient, text];
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

- (NSMutableArray *)fetchMessages:(NSString *)from after:(NSInteger)lastSeenId
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=fetchmessages&from=%@&to=%@&after=%lu", from, [HDRCurrentUser getCurrentUserName], (long)lastSeenId];
    body = [self doHash:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //parse the results
    if ( error == nil && response.statusCode == 200)
    {
        messages = [self parseData:data];
    }
    
    return messages;
}

- (NSMutableArray *)fetchAnywhereMessages:(NSInteger)lastSeenId
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=fetchanywheremessages&after=%lu", (long)lastSeenId];
    body = [self doHash:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //parse the results
    if ( error == nil && response.statusCode == 200)
    {
        messages = [self parseData:data];
    }
    
    return messages;
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

- (BOOL) unBlockUser:(NSString *)userName
{
    if (!userName)
    {
        return NO;
    }
    
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *body = [NSString stringWithFormat:@"method=unblockuser&blocker=%@&blockee=%@", [HDRCurrentUser getCurrentUserName], userName];
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


- (void) refreshTriviaList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"https://hodorcdn.s3.amazonaws.com/trivia.txt"]];
    
    //fetch the data
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (!data)
    {
        return;
    }
    
    //parse the results
    NSError* error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions
                                                                    error:&error];
                  
    if (json)
    {
        for(int i = 0; i < json.count; i++)
        {
            NSString *text =  json[i];
            [list addObject:text];
        }
        
        if (list.count > 0)
        {
            self.triviaList = list;
        }
        else
        {
            self.triviaList = [NSMutableArray arrayWithArray:@[@"How is it going?",
                                                               @"Where are you?",
                                                               @"Almost there",
                                                               @"Ready?",
                                                               @"I am ready",
                                                               @"Talk to you soon",
                                                               @"I'm running late",
                                                               @"I am here",
                                                               @"Miss you",
                                                               @"I love you",
                                                               @"Call me when you get this",
                                                               @"Oye!"]];
        }
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


- (NSMutableArray *)parseData:(NSData *)responseData
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    if (responseData)
    {
        //parse out the json data
        NSError* error;
        NSArray* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions
                                                          error:&error];
        
        if (json)
        {
            for(int i = 0; i < json.count; i++)
            {
                NSDictionary *jMsg =  json[i];
                HDRMessage *message = [[HDRMessage alloc] init];

                message.msgId = [(NSNumber *)[jMsg objectForKey:@"ID"] integerValue];
                message.fromUser = [jMsg objectForKey:@"Sender"];
                message.toUser = [jMsg objectForKey:@"Receiver"];
                message.content = [jMsg objectForKey:@"Content"];
                message.notificationType = [(NSNumber *)[jMsg objectForKey:@"NotificationType"] integerValue];
                message.createdDateString = [jMsg objectForKey:@"CreatedDate"];
                
                //message.createdDate = [(NSNumber *)[jMsg objectForKey:@"CreatedDate"] doubleValue];
                
                [messages addObject:message];
            }
        }
    }
    
    return messages;
}


@end




