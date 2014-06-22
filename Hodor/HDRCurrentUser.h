//
//  HDRCurrentUser.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDRCurrentUser : NSObject

+ (NSString *) getCurrentUserName;
+ (void) setCurrentUserName:(NSString *) name;

+ (NSString *) getUUID;
+ (void) setUUID:(NSString *) uuid;

@end
