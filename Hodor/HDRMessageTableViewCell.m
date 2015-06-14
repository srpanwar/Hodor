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
    
    self.messageTextView.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:30.0f];
    
    self.messageTextView.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.messageTextView.layer.shadowColor = [[UIColor colorWithWhite:0.4 alpha:1] CGColor];
    self.messageTextView.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.messageTextView.layer.shadowOpacity = 1.0f;
    self.messageTextView.layer.shadowRadius = 1.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.messageTextView sizeToFit];
    CGPoint center = self.contentView.center;
    center.x = 20 + self.messageTextView.frame.size.width/2;
    center.y += (self.showLocation ? 2 : 5);
    [self.messageTextView setCenter:center];
}

- (void)setDatasource:(HDRMessage *)msg
{
    [super setDatasource:msg];
    self.messageTextView.text = msg.content;
}

@end
