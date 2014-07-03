//
//  HDRTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRTableViewCell.h"

@implementation HDRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self colorify];
}


- (void)colorify
{
    // Initialization code

    CGFloat red = [self getNextRand:100.0f max:230.0f] /255.0f;
    CGFloat green = [self getNextRand:100.0f max:230.0f] /255.0f;
    CGFloat blue = [self getNextRand:100.0f max:230.0f] /255.0f;
    
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
}

- (CGFloat) getNextRand:(CGFloat)min max:(CGFloat)max
{
    return  fminf(fmaxf((arc4random())%(int)max, min), max);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
