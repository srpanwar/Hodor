//
//  HDRListTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRListTableViewCell.h"

#define INDEX_COLOR_MAP2 @[\
[UIColor colorWithRed:200/255.0f green:176/255.0f blue:80/255.0f alpha:0.7], \
[UIColor colorWithRed:198/255.0f green:69/255.0f blue:109/255.0f alpha:0.7], \
[UIColor colorWithRed:121/255.0f green:165/255.0f blue:145/255.0f alpha:0.7], \
[UIColor colorWithRed:2/255.0f green:109/255.0f blue:148/255.0f alpha:0.7], \
[UIColor colorWithRed:138/255.0f green:130/255.0f blue:107/255.0f alpha:0.7], \
[UIColor colorWithRed:199/255.0f green:107/255.0f blue:131/255.0f alpha:0.7], \
[UIColor colorWithRed:156/255.0f green:147/255.0f blue:201/255.0f alpha:0.7], \
[UIColor colorWithRed:243/255.0f green:113/255.0f blue:149/255.0f alpha:0.7], \
[UIColor colorWithRed:73/255.0f green:195/255.0f blue:208/255.0f alpha:0.7], \
[UIColor colorWithRed:70/255.0f green:51/255.0f blue:156/255.0f alpha:0.7], \
[UIColor colorWithRed:153/255.0f green:190/255.0f blue:118/255.0f alpha:0.7], \
[UIColor colorWithRed:99/255.0f green:162/255.0f blue:163/255.0f alpha:0.7], \
[UIColor colorWithRed:222/255.0f green:137/255.0f blue:76/255.0f alpha:0.7], \
]

@implementation HDRListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:12.0f];
    self.userLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:16.0f];
    self.addressLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:14.0f];
}


- (void)setDatasource:(HDRMessage *)msg
{
    self.message = msg;
    
    //set addres
    self.addressLabel.text = msg.address;
    
    //set user value
    self.userLabel.text = [msg.fromUser uppercaseString];
    //[NSString stringWithFormat:@"从 %@", [msg.fromUser uppercaseString]];
    
    //format date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *capturedStartDate = [formatter dateFromString: msg.createdDateString];
    self.dateLabel.text = [[HDRDateUtil getFormattedShortString:[HDRDateUtil toLocal:[capturedStartDate timeIntervalSince1970]]] uppercaseString];

    self.userLabel.hidden = !self.showUserName;
    self.addressView.hidden = !self.showLocation;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)colorify:(NSInteger)index
{
    UIColor *color = INDEX_COLOR_MAP2[(INDEX_COLOR_MAP2.count - index % INDEX_COLOR_MAP2.count) -1 ];
    //index %2 == 0 ? [UIColor colorWithWhite:0.93 alpha:1] : [UIColor colorWithWhite:0.91 alpha:1];
    //
    self.backgroundColor = color;
}


@end
