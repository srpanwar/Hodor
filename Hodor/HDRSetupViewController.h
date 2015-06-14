//
//  HDRSetupViewController.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDRSession.h"
#import "HDRNetworkProvider.h"
#import "HDRSoundService.h"

@interface HDRSetupViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;

@end
