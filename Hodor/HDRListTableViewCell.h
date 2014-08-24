//
//  HDRListTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRMessage.h"
#import "HDRDateUtil.h"

@interface HDRListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;


@property HDRMessage *message;
@property BOOL showUserName;

- (void)colorify:(NSInteger)index;
- (void)setDatasource:(HDRMessage *)msg;

@end
