//
//  WMNetworkProvider.h
//  WhereMSG
//
//  Created by Shailesh Panwar on 3/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "HDRCommon.h"
#import "HDRMessage.h"
#import "HDRCurrentUser.h"

@interface HDRNetworkProvider : NSObject

@property NSMutableArray *triviaList;

+ (HDRNetworkProvider *) instance;

- (BOOL)createUserName:(NSString *)userName;

- (BOOL)blockUser:(NSString *)userName;

- (BOOL)unBlockUser:(NSString *)userName;

- (void)sendHODOR:(NSString *)recipient;
- (void)sendHODORToChannel:(NSString *)channel;
- (void)sendHODORToAnywhere;
- (void)sendHODORToHere;

- (void)sendText:(NSString *)recipient text:(NSString *)text;
- (void)sendTextToChannel:(NSString *)channel text:(NSString *)text;
- (void)sendTextToAnywhere:(NSString *)text;
- (void)sendTextToHere:(NSString *)text;

- (void)sendRemoteNotificationsDeviceToken:(NSString *)deviceToken;

- (NSMutableArray *)fetchMessages:(NSString *)from after:(NSInteger)lastSeenId;

- (NSMutableArray *)fetchAnywhereMessages:(NSInteger)lastSeenId;

- (void) refreshTriviaList;

@end
