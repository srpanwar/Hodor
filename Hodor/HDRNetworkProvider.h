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

@property NSString *deviceToken;

- (BOOL)createUserName:(NSString *)userName;

- (BOOL)blockUser:(NSString *)userName;

- (void)sendHODOR:(NSString *)recipient;

- (void)sendRemoteNotificationsDeviceToken:(NSString *)deviceToken;

@end
