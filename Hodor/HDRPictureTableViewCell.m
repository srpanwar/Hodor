//
//  HDRPictureTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRPictureTableViewCell.h"

@implementation HDRPictureTableViewCell

- (void)setDatasource:(HDRMessage *)msg
{
    self.message = msg;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *capturedStartDate = [formatter dateFromString: msg.createdDateString];
    NSLog(@"%@", capturedStartDate);
    
    self.dateLabel.text = [HDRDateUtil getFormattedString:[HDRDateUtil toLocal:[capturedStartDate timeIntervalSince1970]]];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
