//
//  HDRHomeTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRTableViewCell.h"
#import "HDRNetworkProvider.h"
#import "HDRFriends.h"
#import "HDRListBox.h"

@interface HDRHomeTableViewCell : HDRTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *flashLabel;
@property HDRUser* user;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onBlock:(id)sender;

- (void)flashHodor:(NSString *)text;

@end
