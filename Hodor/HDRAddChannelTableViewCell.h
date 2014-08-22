//
//  HDRAddChannelTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRTableViewCell.h"
#import "HDRUser.h"
#import "HDRFriends.h"
#import "HDRNetworkProvider.h"

@interface HDRAddChannelTableViewCell : HDRTableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)startEditing:(id)sender;

@end
