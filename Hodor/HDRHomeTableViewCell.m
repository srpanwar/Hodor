//
//  HDRHomeTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRHomeTableViewCell.h"

@interface HDRHomeTableViewCell ()

@property NSMutableArray *messages;

@end

@implementation HDRHomeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.showLocation = NO;
    self.showUserName = YES;
    
    self.cancelLabel.titleLabel.font =  [UIFont fontWithName:@"OpenSans-CondensedBold" size:28];
    self.deleteLabel.titleLabel.font =  [UIFont fontWithName:@"OpenSans-CondensedBold" size:28];
    self.blockLabel.titleLabel.font =  [UIFont fontWithName:@"OpenSans-CondensedBold" size:28];
    
    //menu
    UISwipeGestureRecognizer *leftSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
    [leftSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.nameLabel addGestureRecognizer:leftSwipeUpRecognizer];    
}

#pragma mark GESTURE ACTIONS

- (void)cToClipboard
{
    NSString *cpString = @"";
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:cpString];
}

- (void)showMenu
{
    [self leftAndBack:^{
        CGRect frame = self.menuView.frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.menuView.frame = frame;
            self.menuView.alpha = 1;
        }];
    }];
}

#pragma mark IBACTIONS

- (IBAction)onCancel:(id)sender {
    CGRect frame = self.menuView.frame;
    frame.origin.x = frame.size.width;
    [UIView animateWithDuration:0.3f animations:^{
        self.menuView.frame = frame;
        self.menuView.alpha = 0;
    }];
}

- (IBAction)onDelete:(id)sender
{
    self.menuView.alpha = 0;
    self.nameLabel.alpha = 0;
    [self.busyIndicator startAnimating];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[HDRFriends instance] deleteFriend:self.user];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController refreshView:YES];
        });
    });
}

- (IBAction)onBlock:(id)sender
{
    self.menuView.alpha = 0;
    self.nameLabel.alpha = 0;
    [self.busyIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL status = [[HDRNetworkProvider instance] blockUser:self.user.name];
        if (status)
        {
            [[HDRFriends instance] blockFriend:self.user];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController refreshView:YES];
            });
        }
    });

}

@end


//more action
//    UISwipeGestureRecognizer *rightSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showTextTemplates)];
//    [rightSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//    [nameLabel addGestureRecognizer:rightSwipeUpRecognizer];



