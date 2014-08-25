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
    [super awakeFromNib];
    // Initialization code
    //self.messageTextView.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:21.0f];
//        self.messageTextView.font = [UIFont fontWithName:@"CooperHewitt-Book" size:16.0f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.messageTextView sizeToFit];
    CGPoint center = self.contentView.center;
    center.x = 20 + self.messageTextView.frame.size.width/2;
    center.y += 10;
    [self.messageTextView setCenter:center];
}

- (void)setDatasource:(HDRMessage *)msg
{
    [super setDatasource:msg];
    self.messageTextView.text = [msg.content capitalizedString];
}

@end
