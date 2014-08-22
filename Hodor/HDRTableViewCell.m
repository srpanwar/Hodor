//
//  HDRTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRTableViewCell.h"

#define INDEX_COLOR_MAP @[\
[UIColor colorWithRed:200/255.0f green:176/255.0f blue:80/255.0f alpha:1], \
[UIColor colorWithRed:198/255.0f green:69/255.0f blue:99/255.0f alpha:1], \
[UIColor colorWithRed:121/255.0f green:165/255.0f blue:145/255.0f alpha:1], \
[UIColor colorWithRed:2/255.0f green:109/255.0f blue:148/255.0f alpha:1], \
[UIColor colorWithRed:138/255.0f green:130/255.0f blue:107/255.0f alpha:1], \
[UIColor colorWithRed:199/255.0f green:107/255.0f blue:131/255.0f alpha:1], \
[UIColor colorWithRed:156/255.0f green:147/255.0f blue:101/255.0f alpha:1], \
[UIColor colorWithRed:233/255.0f green:113/255.0f blue:149/255.0f alpha:1], \
[UIColor colorWithRed:73/255.0f green:195/255.0f blue:198/255.0f alpha:1], \
[UIColor colorWithRed:70/255.0f green:51/255.0f blue:156/255.0f alpha:1], \
[UIColor colorWithRed:153/255.0f green:190/255.0f blue:118/255.0f alpha:1], \
[UIColor colorWithRed:99/255.0f green:162/255.0f blue:163/255.0f alpha:1], \
[UIColor colorWithRed:222/255.0f green:137/255.0f blue:76/255.0f alpha:1], \
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
