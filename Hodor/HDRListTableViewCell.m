//
//  HDRListTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRListTableViewCell.h"

#define INDEX_COLOR_MAP2 @[\
[UIColor colorWithRed:210/255.0f green:186/255.0f blue:90/255.0f alpha:0.77], \
[UIColor colorWithRed:208/255.0f green:79/255.0f blue:119/255.0f alpha:0.77], \
[UIColor colorWithRed:131/255.0f green:175/255.0f blue:155/255.0f alpha:0.77], \
[UIColor colorWithRed:2/255.0f green:119/255.0f blue:158/255.0f alpha:0.77], \
[UIColor colorWithRed:148/255.0f green:140/255.0f blue:117/255.0f alpha:0.77], \
[UIColor colorWithRed:209/255.0f green:117/255.0f blue:141/255.0f alpha:0.77], \
[UIColor colorWithRed:166/255.0f green:157/255.0f blue:211/255.0f alpha:0.77], \
[UIColor colorWithRed:253/255.0f green:123/255.0f blue:159/255.0f alpha:0.77], \
[UIColor colorWithRed:83/255.0f green:205/255.0f blue:218/255.0f alpha:0.77], \
[UIColor colorWithRed:80/255.0f green:61/255.0f blue:166/255.0f alpha:0.77], \
[UIColor colorWithRed:163/255.0f green:200/255.0f blue:128/255.0f alpha:0.77], \
[UIColor colorWithRed:109/255.0f green:172/255.0f blue:173/255.0f alpha:0.77], \
[UIColor colorWithRed:232/255.0f green:147/255.0f blue:86/255.0f alpha:0.77], \
]

@implementation HDRListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateLabel.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:11.0f];
    self.userLabel.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:12.0f];
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

- (void)colorify:(NSInteger)index
{
    UIColor *color = index %2 == 0 ? [UIColor colorWithWhite:0.95 alpha:1] : [UIColor colorWithWhite:0.93 alpha:1];
    //INDEX_COLOR_MAP2[(INDEX_COLOR_MAP2.count - index % INDEX_COLOR_MAP2.count) -1 ];
    self.backgroundColor = color;
}


@end
