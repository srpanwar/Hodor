//
//  HDRTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRTableViewCell.h"

#define INDEX_COLOR_MAP @[\
[UIColor colorWithRed:205/255.0f green:181/255.0f blue:85/255.0f alpha:1], \
[UIColor colorWithRed:203/255.0f green:74/255.0f blue:104/255.0f alpha:1], \
[UIColor colorWithRed:126/255.0f green:169/255.0f blue:150/255.0f alpha:1], \
[UIColor colorWithRed:2/255.0f green:114/255.0f blue:153/255.0f alpha:1], \
[UIColor colorWithRed:143/255.0f green:135/255.0f blue:113/255.0f alpha:1], \
[UIColor colorWithRed:204/255.0f green:113/255.0f blue:136/255.0f alpha:1], \
[UIColor colorWithRed:160/255.0f green:153/255.0f blue:106/255.0f alpha:1], \
[UIColor colorWithRed:237/255.0f green:118/255.0f blue:154/255.0f alpha:1], \
[UIColor colorWithRed:77/255.0f green:200/255.0f blue:203/255.0f alpha:1], \
[UIColor colorWithRed:75/255.0f green:56/255.0f blue:161/255.0f alpha:1], \
[UIColor colorWithRed:158/255.0f green:195/255.0f blue:123/255.0f alpha:1], \
[UIColor colorWithRed:104/255.0f green:167/255.0f blue:168/255.0f alpha:1], \
[UIColor colorWithRed:227/255.0f green:142/255.0f blue:781/255.0f alpha:1], \
]

@implementation HDRTableViewCell

- (void)awakeFromNib
{
    self.nameLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:42];
    self.nameLabel.textColor = [UIColor colorWithWhite:0.96 alpha:0.95];
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

@end
