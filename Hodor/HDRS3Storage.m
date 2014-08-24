//
//  WMS3Storage.m
//  WhereMsg
//
//  Created by Shailesh Panwar on 4/2/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRS3Storage.h"

@implementation HDRS3Storage

+ (id) instance
{
    static HDRS3Storage *that = nil;
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            that = [[self alloc] init];
        });
    }
    return that;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        self.s3Client = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        self.s3Client.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    }
    
    return self;
}

- (BOOL)uploadProfilePicture:(NSData *)imageData filename:(NSString *)fileName
{
    return [self uploadImage:imageData fileName:fileName inBucket:PROFILE_PICTURE_BUCKET];
}

- (BOOL)uploadMessagePicture:(NSData *)imageData filename:(NSString *)fileName
{
    return [self uploadImage:imageData fileName:fileName inBucket:MESSAGE_PICTURE_BUCKET];
}


- (BOOL)uploadImage:(NSData *)imageData fileName:(NSString *)fileName inBucket:(NSString *) bucket
{
    @try {
        // Upload image data.  Remember to set the content type.
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:fileName
                                                                 inBucket:bucket];
        por.contentType = @"image/png";
        por.data        = imageData;
        por.cannedACL   = [S3CannedACL publicRead];
        
        // Put the image data into the specified s3 bucket and object.
        S3PutObjectResponse *putObjectResponse = [self.s3Client putObject:por];
        
        return putObjectResponse.error == nil;
    }
    @catch (NSException *exception) {
        NSLog(@"Error");
    }
    
    return NO;
}

@end
