//
//  HDRHomeViewController.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRInviteTableViewCell.h"
#import "HDRHomeTableViewCell.h"
#import "HDRAddUserNameTableViewCell.h"
#import "HDRFriends.h"

@interface HDRHomeViewController : HDRBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property NSMutableDictionary *userPingedData;

@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *ratingBtn;
@property (weak, nonatomic) IBOutlet UIView *enablePushView;

- (IBAction)doShare:(id)sender;
- (IBAction)rateTheApp:(id)sender;

@end
