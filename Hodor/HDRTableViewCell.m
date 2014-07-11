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
    CGFloat red = [self getNextRand:90.0f max:230.0f];
    CGFloat green = [self getNextRand:90.0f max:230.0f];
    CGFloat blue = [self getNextRand:90.0f max:230.0f];
    
    int counter = 0;
    while (counter++ < 2) {
        red = [self getNextRand:90.0f max:230.0f];
        green = [self getNextRand:90.0f max:230.0f];
        blue = [self getNextRand:90.0f max:230.0f];
    }
    
    self.backgroundColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:0.9];
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
