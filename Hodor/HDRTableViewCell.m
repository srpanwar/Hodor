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
    static int count = 0;
    
    // Initialization code
    CGFloat color = [self getNextRand:50.0f max:160.0f];
    CGFloat red = count % 3 == 0 ? color : (1 - color) * 0.9;
    CGFloat green = count % 3 == 1 ? color : (1 - color) * 0.9;
    CGFloat blue = (count % 3 == 2 ? color : 1 - color) * 0.65;
    count++;
    
    NSLog(@"color %d %f %f %f", count, red *255, green*255, blue*255);
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.9];
}

- (CGFloat) getNextRand:(CGFloat)min max:(CGFloat)max
{
    min *= 10;
    max *= 10;
    return  fminf(fmaxf(rand()*rand()%(int)max, min), max) / 2550.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
