//
//  HDRImageUtil.m
//  WhereMsg
//
//  Created by Shailesh Panwar on 4/2/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRImageUtil.h"

@implementation HDRImageUtil

+ (UIImage *) scaleDownImage:(UIImage *)chosenImage
{
    NSData *imgData = UIImageJPEGRepresentation(chosenImage, 1);
    if (imgData.length <= 1*1024*1024)
    {
        return chosenImage;
    }
    
    CGFloat width = chosenImage.size.width / 5;
    CGFloat height = chosenImage.size.height / 5;
    
    CGSize destinationSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(destinationSize);
    [chosenImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+(void) fetchAndSetThumbnailImage:(NSString *)imageName fillImage:(UIImageView *)imageView
{
    [self fetchAndSetImageBackground:imageName fillImage:imageView inBucket:MESSAGE_PICTURE_ENDPOINT isThumbail:YES withCalback:nil];
}

+(void) fetchAndSetThumbnailImage:(NSString *)imageName fillImage:(UIImageView *)imageView withCalback:(void (^)(void))callback
{
    [self fetchAndSetImageBackground:imageName fillImage:imageView inBucket:MESSAGE_PICTURE_ENDPOINT isThumbail:YES withCalback:callback];
}

+(void) fetchAndSetImage:(NSString *)imageName fillImage:(UIImageView *)imageView
{
    [self fetchAndSetImageBackground:imageName fillImage:imageView inBucket:MESSAGE_PICTURE_ENDPOINT isThumbail:NO withCalback:nil];
}

+(void) fetchAndSetImage:(NSString *)imageName fillImage:(UIImageView *)imageView withCalback:(void (^)(void))callback
{
    [self fetchAndSetImageBackground:imageName fillImage:imageView inBucket:MESSAGE_PICTURE_ENDPOINT isThumbail:NO withCalback:callback];
}


+(void) fetchAndSetImage:(NSString *)imageName fillImage:(UIImageView *)imageView inBucket:(NSString *) bucket isThumbail:(BOOL)isThumbnail withCalback:(void (^)(void))callback
{
    if(!imageName || !imageView)
    {
        return;
    }
    
    srand((unsigned int)time(NULL));
    unsigned long tag = rand();
    imageView.tag = tag;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [HDRImageUtil getImageDataNetwork:imageName inBucket:bucket];
        if (isThumbnail)
        {
            imageData = [self createThumbnailImage:imageData];
        }
        
        UIImage *image = imageData ? [UIImage imageWithData:imageData] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(image)
            {
                [self setImageViewWithImage:imageView image:image tag:tag];
            }
            
            if (callback)
            {
                callback();
            }
        });
    });
    
}


+(void) fetchAndSetImageBackground:(NSString *)imageName fillImage:(UIImageView *)imageView inBucket:(NSString *) bucket isThumbail:(BOOL)isThumbnail withCalback:(void (^)(void))callback
{
    if(!imageName || !imageView)
    {
        return;
    }
    
    srand((unsigned int)time(NULL));
    unsigned long tag = rand();
    imageView.tag = tag;

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [HDRImageUtil getImageDataNetwork:imageName inBucket:bucket];

        if (isThumbnail)
        {
            imageData = [self createThumbnailImage:imageData];
        }
        
        UIImage *image = imageData ? [UIImage imageWithData:imageData] : nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(image)
            {
                [self setImageViewWithImage:imageView image:image tag:tag];
            }
            
            if (callback)
            {
                callback();
            }
        });
    });
    
}

+(NSData *) createThumbnailImage:(NSData *)imageData
{
    UIImage *chosenImage = [UIImage imageWithData:imageData];
    
    CGFloat width = chosenImage.size.width > 300 ? 300 :chosenImage.size.width;
    CGFloat height = width * chosenImage.size.height/chosenImage.size.width;
    
    CGSize destinationSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(destinationSize);
    [chosenImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(newImage) ;
}

+(void) setImageViewWithImage:(UIImageView *)imageView image:(UIImage *)image tag:(unsigned long) tag
{
    if ( imageView.tag == tag)
    {
        [imageView setImage:image];
    }
}

+(void) saveImageToLibrary:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = nil;//[HDRImageUtil getImageDataCached:imageName];
        if (!imageData)
        {
            [HDRImageUtil getImageDataNetwork:imageName inBucket:MESSAGE_PICTURE_ENDPOINT];
        }
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    });
}

+(NSData *) getImageDataNetwork:(NSString *)imageName inBucket:(NSString *) bucket
{
    NSData *imageData = nil;
    NSString *encImageName = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)imageName, NULL, (__bridge CFStringRef) @"!#$%&’*+-/=?^_`{|}~", kCFStringEncodingUTF8);
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:bucket,encImageName]];
    imageData = [NSData dataWithContentsOfURL:url];
    
    return imageData;
}

@end
