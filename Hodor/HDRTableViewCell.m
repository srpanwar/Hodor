//
//  HDRTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRTableViewCell.h"

#define INDEX_COLOR_MAP @[\
    [UIColor colorWithRed:220/255.0f green:196/255.0f blue:100/255.0f alpha:1], \
    [UIColor colorWithRed:208/255.0f green:79/255.0f blue:119/255.0f alpha:1], \
    [UIColor colorWithRed:131/255.0f green:175/255.0f blue:155/255.0f alpha:1], \
    [UIColor colorWithRed:2/255.0f green:119/255.0f blue:158/255.0f alpha:1], \
    [UIColor colorWithRed:148/255.0f green:140/255.0f blue:117/255.0f alpha:1], \
    [UIColor colorWithRed:209/255.0f green:117/255.0f blue:141/255.0f alpha:1], \
    [UIColor colorWithRed:166/255.0f green:157/255.0f blue:211/255.0f alpha:1], \
    [UIColor colorWithRed:253/255.0f green:123/255.0f blue:159/255.0f alpha:1], \
    [UIColor colorWithRed:83/255.0f green:205/255.0f blue:218/255.0f alpha:1], \
    [UIColor colorWithRed:80/255.0f green:61/255.0f blue:166/255.0f alpha:1], \
    [UIColor colorWithRed:163/255.0f green:200/255.0f blue:128/255.0f alpha:1], \
    [UIColor colorWithRed:109/255.0f green:172/255.0f blue:173/255.0f alpha:1], \
    [UIColor colorWithRed:232/255.0f green:147/255.0f blue:86/255.0f alpha:1], \
    ]

@implementation HDRTableViewCell

- (void)awakeFromNib
{
    self.nameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:48];
    self.nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.95];
}


- (void)colorify:(NSInteger)index
{
    UIColor *color = INDEX_COLOR_MAP[ index % INDEX_COLOR_MAP.count ];
    self.backgroundColor = color;
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
