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
    CGFloat color = [self getNextRand:100.0f max:200.0f];
    CGFloat red = count % 3 == 0 ? color : (1 - color) * 0.9;
    CGFloat green = count % 3 == 1 ? color : (1 - color) * 0.9;
    CGFloat blue = (count % 3 == 2 ? color : 1 - color) * 0.65;
    count++;
    
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.9];
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
