//
//  HDRHomeTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRHomeTableViewCell.h"

@implementation HDRHomeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.nameLabel.text = @"";
    CGFloat red = fminf(fmaxf(rand()%150, 50.0f), 150.0f) / 255.0f;
    CGFloat green = fminf(fmaxf(rand()%150, 50.0f), 150.0f) / 255.0f;
    CGFloat blue = fminf(fmaxf(rand()%150, 50.0f), 150.0f) / 255.0f;
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
