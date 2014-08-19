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
#import "HDRListBox2.h"
#import "HDRUtils.h"

@interface HDRHomeTableViewCell : HDRTableViewCell

@property HDRUser* user;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;
@property (weak, nonatomic) IBOutlet UIImageView *hodorImage;
@property (weak, nonatomic) IBOutlet UIImageView *busyImage;

@property (weak, nonatomic) IBOutlet UIButton *cancelLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteLabel;
@property (weak, nonatomic) IBOutlet UIButton *blockLabel;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;

- (IBAction)callHodor:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onBlock:(id)sender;
- (IBAction)viewMessages:(id)sender;

- (void)loadMessages;
- (void)firstRun;

@end
