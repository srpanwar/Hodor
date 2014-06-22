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
    srand((unsigned)rand());
    
    // Initialization code
    CGFloat red = [self getNextRand];
    CGFloat green = [self getNextRand];
    CGFloat blue = [self getNextRand];
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
}


- (CGFloat) getNextRand
{
    return  fminf(fmaxf(rand()%170, 90.0f), 170.0f) / 255.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
