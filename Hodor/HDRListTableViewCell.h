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

@property HDRMessage *message;

- (void)colorify:(NSInteger)index;
- (void)setDatasource:(HDRMessage *)msg;

@end
