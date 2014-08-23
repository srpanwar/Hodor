//
//  HDRHomeTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDREntityTableViewCell.h"
#import "HDRNetworkProvider.h"
#import "HDRFriends.h"
#import "HDRListBox.h"
#import "HDRListBox2.h"
#import "HDRUtils.h"

@interface HDRHomeTableViewCell : HDREntityTableViewCell

@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet UIButton *cancelLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteLabel;

@property (weak, nonatomic) IBOutlet UIButton *blockLabel;


- (IBAction)onCancel:(id)sender;
- (IBAction)onDelete:(id)sender;

- (IBAction)onBlock:(id)sender;


@end
