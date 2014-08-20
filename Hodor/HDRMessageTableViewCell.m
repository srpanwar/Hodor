//
//  HDRMessageTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/19/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRMessageTableViewCell.h"

@implementation HDRMessageTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.messageTextView.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:18.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
