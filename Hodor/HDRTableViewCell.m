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
    [super awakeFromNib];
    
    [self colorify];
}

- (void)colorify
{
    static int count = 0;
    
    // Initialization code
    CGFloat color1 = [self getNextRand:170.0f max:220.0f];
    CGFloat color2 = [self getNextRand:50.0f max:150.0f];
    CGFloat color3 = [self getNextRand:50.0f max:150.0f];
    CGFloat color4 = [self getNextRand:50.0f max:150.0f];
    
    CGFloat red = count % 3 == 0 ? color1 : color2;
    CGFloat green = count % 3 == 1 ? color1 : color3;
    CGFloat blue = count % 3 == 2 ? color1 : color4;
    count++;
    
    NSLog(@"color %d %f %f %f", count, red *255, green*255, blue*255);
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
