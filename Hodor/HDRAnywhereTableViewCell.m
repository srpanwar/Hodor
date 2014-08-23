//
//  HDRHomeTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRAnywhereTableViewCell.h"

@interface HDRAnywhereTableViewCell ()


@end

@implementation HDRAnywhereTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nameLabel.text = @"#ANYWHERE";
}

@end




