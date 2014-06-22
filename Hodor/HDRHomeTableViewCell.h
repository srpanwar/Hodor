//
//  HDRHomeTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDRHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *menuView;

- (IBAction)onCancel:(id)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onBlock:(id)sender;
@end
