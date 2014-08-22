//
//  HDRMessageTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/19/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRMessage.h"
#import "HDRDateUtil.h"

@interface HDRMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)colorify:(NSInteger)index;
- (void)setDatasource:(HDRMessage *)msg;

@end
