//
//  HDRUser.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDRUser : NSObject<NSCoding>

@property NSString *name;
@property double lastSyncTime;
@property BOOL isBlocked;

@end
