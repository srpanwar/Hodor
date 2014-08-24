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
    self.pictureView.layer.cornerRadius = 5;
}

- (void)setDatasource:(HDRMessage *)msg
{
    [super setDatasource:msg];
}

@end
