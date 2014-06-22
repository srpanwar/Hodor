//
//  WMNetworkProvider.h
//  WhereMSG
//
//  Created by Shailesh Panwar on 3/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDRCommon.h"
#import "HDRCurrentUser.h"

@interface HDRNetworkProvider : NSObject

+ (id) instance;

- (BOOL) createUserName:(NSString *)userName;

- (BOOL) blockUser:(NSString *)userName;

- (void) sendHODOR:(NSString *)recipient;

@end
