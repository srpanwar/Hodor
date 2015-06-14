//
//  HDRFriends.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDRUser.h"
#import "NSDate+Util.h"

@interface HDRFriendsProvider : NSObject

+ (HDRFriendsProvider *) instance;

- (HDRUser *)getFriend:(NSString *)userName;
- (NSMutableArray *)getFriends;
- (void)moveToTop:(HDRUser *)user;
- (BOOL)isFriend:(NSString *)userName;
- (void) addFriend:(HDRUser *)user;
- (void) deleteFriend:(HDRUser *)user;
- (void) blockFriend:(HDRUser *)user;

- (void) setLastSeenId:(NSString *)userName last:(NSInteger)lastid;

@end
