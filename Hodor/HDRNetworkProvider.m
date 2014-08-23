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

- (BOOL) createUserName:(NSString *)userName
{    
    if (!userName)
    {
        return NO;
    }
    
    NSString *body = [NSString stringWithFormat:@"method=createuser&username=%@", userName];
    NSData *responseData = [self doNetwork:body];
    NSString *uuid = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    //mark it delivered in db
    if(uuid && uuid.length && ![EMPTY_GUID isEqualToString:uuid])
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
    NSString *body = [NSString stringWithFormat:@"method=sendhodor&sender=%@&recipient=%@", [HDRCurrentUser getCurrentUserName], recipient];
    
    NSData *responseData = [self doNetwork:body];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",ret);
    
    return;
}

-(void) sendHODORToChannel:(NSString *)channel
{
    NSString *body = [NSString stringWithFormat:@"method=sendhodortochannel&sender=%@&channel=%@", [HDRCurrentUser getCurrentUserName], channel];
    
    NSData *responseData = [self doNetwork:body];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",ret);
    
    return;
    
}

- (void)sendHODORToAnywhere
{
    NSString *body = [NSString stringWithFormat:@"method=sendhodortoanywhere&sender=%@&latitude=%f&longitude=%f", [HDRCurrentUser getCurrentUserName], [HDRCurrentUser getLastLocation].latitude, [HDRCurrentUser getLastLocation].longitude];
    
    NSData *responseData = [self doNetwork:body];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",ret);
    
    return;
}


- (void)sendHODORToHere
{
    NSString *body = [NSString stringWithFormat:@"method=sendhodortohere&sender=%@&latitude=%f&longitude=%f", [HDRCurrentUser getCurrentUserName], [HDRCurrentUser getLastLocation].latitude, [HDRCurrentUser getLastLocation].longitude];
    
    NSData *responseData = [self doNetwork:body];
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
    
    NSString *body = [NSString stringWithFormat:@"method=sendtext&sender=%@&recipient=%@&text=%@", [HDRCurrentUser getCurrentUserName], recipient, text];
    
    NSData *responseData = [self doNetwork:body];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",ret);
    
    return;
}

- (void)sendTextToChannel:(NSString *)channel text:(NSString *)text
{
    if (!channel || !text)
    {
        return;
    }
    
    NSString *body = [NSString stringWithFormat:@"method=sendtexttochannel&sender=%@&channel=%@&text=%@", [HDRCurrentUser getCurrentUserName], channel, text];
    
    NSData *responseData = [self doNetwork:body];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",ret);
    
    return;
}

- (void)sendTextToAnywhere:(NSString *)text
{
    if (!text)
    {
        return;
    }
    
    NSString *body = [NSString stringWithFormat:@"method=sendtexttoanywhere&sender=%@&text=%@&latitude=%f&longitude=%f", [HDRCurrentUser getCurrentUserName], text, [HDRCurrentUser getLastLocation].latitude, [HDRCurrentUser getLastLocation].longitude];
    
    NSData *responseData = [self doNetwork:body];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",ret);
    
    return;
}

- (void)sendTextToHere:(NSString *)text
{
    if (!text)
    {
        return;
    }
    
    NSString *body = [NSString stringWithFormat:@"method=sendtexttohere&sender=%@&text=%@&latitude=%f&longitude=%f", [HDRCurrentUser getCurrentUserName], text, [HDRCurrentUser getLastLocation].latitude, [HDRCurrentUser getLastLocation].longitude];

    NSData *responseData = [self doNetwork:body];
    NSString *ret = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",ret);
    
    return;
}

- (NSMutableArray *)fetchMessages:(NSString *)from after:(NSInteger)lastSeenId
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    NSString *body = [NSString stringWithFormat:@"method=fetchmessages&from=%@&to=%@&after=%lu", from, [HDRCurrentUser getCurrentUserName], (long)lastSeenId];

    NSData *data = [self doNetwork:body];
    
    //parse the results
    if (data)
    {
        messages = [self parseData:data];
    }
    
    return messages;
}

- (NSMutableArray *)fetchAnywhereMessages:(NSInteger)lastSeenId
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    //form the url
    NSString *body = [NSString stringWithFormat:@"method=fetchanywheremessages&after=%lu", (long)lastSeenId];
    NSData *data = [self doNetwork:body];
    
    //parse the results
    if (data)
    {
        messages = [self parseData:data];
    }
    
    return messages;
}

- (NSMutableArray *)fetchHereMessages:(NSInteger)lastSeenId
{
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    
    //form the url
    NSString *body = [NSString stringWithFormat:@"method=fetchheremessages&after=%lu&latitude=%f&longitude=%f", (long)lastSeenId, [HDRCurrentUser getLastLocation].latitude, [HDRCurrentUser getLastLocation].longitude];
    NSData *data = [self doNetwork:body];
    
    //parse the results
    if (data)
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
    
    NSString *body = [NSString stringWithFormat:@"method=blockuser&blocker=%@&blockee=%@", [HDRCurrentUser getCurrentUserName], userName];
    NSHTTPURLResponse *response = [self doNetworkResponse:body];
    
    return response && response.statusCode == 200;
}

- (BOOL) unBlockUser:(NSString *)userName
{
    if (!userName)
    {
        return NO;
    }
    
    NSString *body = [NSString stringWithFormat:@"method=unblockuser&blocker=%@&blockee=%@", [HDRCurrentUser getCurrentUserName], userName];
    NSHTTPURLResponse *response = [self doNetworkResponse:body];
    
    return response && response.statusCode == 200;
}

- (void)sendRemoteNotificationsDeviceToken:(NSString *)deviceToken
{
    if (!deviceToken || ![HDRCurrentUser getCurrentUserName])// || [HDRCurrentUser isNotificationTokenSet])
    {
        return;
    }
    
    NSString *body = [NSString stringWithFormat:@"method=setdevicetoken&username=%@&devicetoken=%@", [HDRCurrentUser getCurrentUserName], [self stringWithPercentEscape:deviceToken]];
    NSHTTPURLResponse *response = [self doNetworkResponse:body];
    
    if (response && response.statusCode == 200)
    {
        //[HDRCurrentUser setNotificationTokenSet];
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

- (NSData *)doNetwork:(NSString *)body
{
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    body = [self doHash:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return responseData;
}

- (NSHTTPURLResponse *)doNetworkResponse:(NSString *)body
{
    //form the url
    NSURL *url = [NSURL URLWithString:HODOR_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    body = [self doHash:body];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return response;
}

@end




