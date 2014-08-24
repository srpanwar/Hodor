//
//  HDRPictureTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRPictureTableViewCell.h"

@implementation HDRPictureTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.pictureView.layer.cornerRadius = 8;
    
    CGRect frame = self.pictureView.frame;
    CGFloat x = frame.origin.x;
    frame.origin.x = -1 * frame.size.width/4;
    self.pictureView.frame = frame;
    
    frame.origin.x = x;
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pictureView.frame = frame;
    } completion:nil];
}

- (void)setDatasource:(HDRMessage *)msg
{
    [super setDatasource:msg];
    
    [HDRImageUtil fetchAndSetThumbnailImage:msg.picture fillImage:self.pictureView];
}

@end
