//
//  HDRMessage.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/19/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDRMessage : NSObject

@property NSInteger msgId;
@property NSString *fromUser;
@property NSString *toUser;
@property NSString *content;
@property NSString *picture;
@property NSString *createdDateString;
@property double createdDate;
@property NSInteger notificationType;
@property NSString *address;

@end
