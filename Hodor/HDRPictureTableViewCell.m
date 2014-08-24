//
//  HDRPictureTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRPictureTableViewCell.h"

@implementation HDRPictureTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.pictureView.layer.cornerRadius = 5;
    self.dateLabel.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:14.0f];
    self.userLabel.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:14.0f];
}

- (void)setDatasource:(HDRMessage *)msg
{
    self.message = msg;
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
