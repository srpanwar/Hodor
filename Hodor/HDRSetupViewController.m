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
        return;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.messageLabel.alpha = 0;
    self.textField.delegate = self;
    
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{
    NSString *text = [field.text stringByReplacingCharactersInRange:range withString:characters];
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([characters rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound) && text.length < 50;
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
                    [self playSound];
                    [self goHome];
                }
                else
                {
                    self.messageLabel.alpha = 1;
                    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.messageLabel.alpha = 0;
                    } completion:nil];
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

-(void) playSound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Hodor" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
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
