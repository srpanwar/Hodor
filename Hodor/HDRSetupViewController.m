//
//  HDRSetupViewController.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRSetupViewController.h"

@interface HDRSetupViewController ()

@end

@implementation HDRSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if ([HDRCurrentUser getCurrentUserName].length)
    {
        [self goHome];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageLabel.hidden = YES;
    self.textField.delegate = self;
    
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length)
    {
        [self.busyIndicator startAnimating];
        NSString *userName = [NSString stringWithString:textField.text];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            BOOL status = [[HDRNetworkProvider instance] createUserName:userName];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (status)
                {
                    [self goHome];
                }
                else
                {
                    self.messageLabel.hidden = NO;
                }
                
                [self.busyIndicator stopAnimating];
            });
            
        });
    }
    
    return YES;
}

- (void)goHome
{
    [self performSegueWithIdentifier:@"HomeSegue" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
