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
    static int count = 0;
    
    // Initialization code
    CGFloat red = (count %3 == 0) ? [self getNextRand:150.0f max:220.0f] : [self getNextRand:80.0f max:110.0f];
    CGFloat green = (count %3 == 1) ? [self getNextRand:150.0f max:220.0f] : [self getNextRand:80.0f max:110.0f];
    CGFloat blue = (count %3 == 2) ? [self getNextRand:150.0f max:220.0f] : [self getNextRand:80.0f max:110.0f];
    count++;
    
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.7];
}


- (CGFloat) getNextRand:(CGFloat)min max:(CGFloat)max
{
    return  fminf(fmaxf(rand()%(int)max, min), max) / 255.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
