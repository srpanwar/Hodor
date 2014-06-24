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

@interface HDRHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)doShare:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end
