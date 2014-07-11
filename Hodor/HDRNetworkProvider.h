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
#import "HDRCurrentUser.h"

@interface HDRNetworkProvider : NSObject

+ (HDRNetworkProvider *) instance;

- (BOOL)createUserName:(NSString *)userName;

- (BOOL)blockUser:(NSString *)userName;

- (void)sendHODOR:(NSString *)recipient;

- (void)sendText:(NSString *)recipient text:(NSString *)text;

- (void)sendRemoteNotificationsDeviceToken:(NSString *)deviceToken;

@end
