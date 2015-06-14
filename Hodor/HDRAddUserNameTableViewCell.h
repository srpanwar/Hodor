//
//  HDRAddUserNameTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRTableViewCell.h"
#import "HDRUser.h"
#import "HDRFriendsProvider.h"
#import "HDRNetworkProvider.h"

@interface HDRAddUserNameTableViewCell : HDRTableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)startEditing:(id)sender;

@end
