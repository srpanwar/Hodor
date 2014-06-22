//
//  HDRFriends.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDRUser.h"

@interface HDRFriends : NSObject

+ (HDRFriends *) instance;

- (NSMutableArray *)getFriends;
- (void) addFriend:(HDRUser *)user;
- (void) deleteFriend:(HDRUser *)user;
- (void) blockFriend:(HDRUser *)user;

@end
