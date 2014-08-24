//
//  WMImageUtil.h
//  WhereMsg
//
//  Created by Shailesh Panwar on 4/2/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDRCommon.h"

@interface HDRImageUtil : NSObject

+(void) saveImageToLibrary:(NSString *)fileName;

+(void) fetchAndSetThumbnailImage:(NSString *)imageName fillImage:(UIImageView *)imageView;

+(void) fetchAndSetThumbnailImage:(NSString *)imageName fillImage:(UIImageView *)imageView withCalback:(void (^)(void))callback;

+(void) fetchAndSetImage:(NSString *)imageName fillImage:(UIImageView *)imageView;

+(void) fetchAndSetImage:(NSString *)imageName fillImage:(UIImageView *)imageView withCalback:(void (^)(void))callback;

@end
