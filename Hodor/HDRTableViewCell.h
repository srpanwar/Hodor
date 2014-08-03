//
//  HDRTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDRTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property UIViewController *viewController;
@property UITableView *tableView;

- (void)colorify;
- (CGFloat) getNextRand:(CGFloat)min max:(CGFloat)max;

@end
