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
    self.messageTextView.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:20.0f];
    self.dateLabel.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:14.0f];
    self.userLabel.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:14.0f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.messageTextView sizeToFit];
    CGPoint center = self.contentView.center;
    center.x = 12 + self.messageTextView.frame.size.width/2;
    center.y -= 13;
    [self.messageTextView setCenter:center];
}

- (void)setDatasource:(HDRMessage *)msg
{
    self.messageTextView.text = [msg.content capitalizedString];
    self.userLabel.text = [NSString stringWithFormat:@"从 %@", [msg.fromUser uppercaseString]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *capturedStartDate = [formatter dateFromString: msg.createdDateString];
    NSLog(@"%@", capturedStartDate);
    
    if (self.showUserName)
    {
        self.dateLabel.text = [[NSString stringWithFormat:@"%@, %@", msg.fromUser, [HDRDateUtil getFormattedString:[HDRDateUtil toLocal:[capturedStartDate timeIntervalSince1970]]]] uppercaseString];
    }
    else
    {
        self.dateLabel.text = [[HDRDateUtil getFormattedShortString:[HDRDateUtil toLocal:[capturedStartDate timeIntervalSince1970]]] uppercaseString];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

@end
