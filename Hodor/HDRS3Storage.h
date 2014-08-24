//
//  WMS3Storage.h
//  WhereMsg
//
//  Created by Shailesh Panwar on 4/2/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>
#import "HDRCommon.h"
#import "HDRImageUtil.h"

@interface HDRS3Storage : NSObject<AmazonServiceRequestDelegate>

@property AmazonS3Client *s3Client;

+ (id) instance;

- (BOOL)uploadProfilePicture:(NSData *)imageData filename:(NSString *)fileName;
- (BOOL)uploadMessagePicture:(NSData *)imageData filename:(NSString *)fileName;

@end
