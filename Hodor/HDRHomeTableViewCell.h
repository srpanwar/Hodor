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

@interface HDRHomeTableViewCell : HDRTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onBlock:(id)sender;
@end
