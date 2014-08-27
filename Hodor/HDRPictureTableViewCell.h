//
//  HDRPictureTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"
#import "HDRImageUtil.h"
#import "HDRListTableViewCell.h"

@interface HDRPictureTableViewCell : HDRListTableViewCell

@property (weak, nonatomic) IBOutlet UIView *pictureBackground;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;


@end
