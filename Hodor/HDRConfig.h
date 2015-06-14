//
//  HDRCommon.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDRConfig : NSObject

@property (readonly) NSString *emptyGuid;
@property (readonly) NSString *privateKey;

@property (readonly) NSString *serviceEndPoint;
@property (readonly) NSString *messageTemplateEndPoint;
@property (readonly) NSString *homePageUrl;
@property (readonly) NSString *itunesUrl;

+ (HDRConfig *) instance;

@end
