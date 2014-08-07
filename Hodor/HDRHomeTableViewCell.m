//
//  HDRHomeTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRHomeTableViewCell.h"

@implementation HDRHomeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.menuView.alpha = 0;
    self.flashLabel.alpha = 0;
    self.nameLabel.text = @"";
    self.hodorImage.layer.cornerRadius = 15;
    
    self.cancelLabel.titleLabel.font =  [UIFont fontWithName:@"OpenSans-CondensedBold" size:28];
    self.deleteLabel.titleLabel.font =  [UIFont fontWithName:@"OpenSans-CondensedBold" size:28];
    self.blockLabel.titleLabel.font =  [UIFont fontWithName:@"OpenSans-CondensedBold" size:28];
    
    //menu
    UISwipeGestureRecognizer *leftSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe)];
    [leftSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.contentView addGestureRecognizer:leftSwipeUpRecognizer];
    
    //text
    UITapGestureRecognizer *singleTapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTextTemplatesUI)];
    [self.contentView addGestureRecognizer:singleTapGestureRecognizer2];

    
    UISwipeGestureRecognizer *rightSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showTextTemplates)];
    [rightSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.contentView addGestureRecognizer:rightSwipeUpRecognizer];
}

- (void)firstRun
{
    //first run
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (((int)[self getNextRand:30.0f max:60.0f] % 70) / 70.0f) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self rightAndBack:nil];
    });
}

- (void)showTextTemplates
{
    [self rightAndBack:^{
        [self showTextTemplatesUI];
    }];
}

- (void)showTextTemplatesUI
{
    HDRListBox *listBox = (HDRListBox *)[[[NSBundle mainBundle] loadNibNamed:@"HDRListBox" owner:nil options:nil] lastObject];
    [listBox setFrame:[UIScreen mainScreen].bounds];
    
    listBox.collection = [NSMutableArray arrayWithArray:@[@"How is it going?",
                                                          @"Where are you?",
                                                          @"Almost there",
                                                          @"Ready?",
                                                          @"I am ready",
                                                          @"Talk to you soon",
                                                          @"I'm running late",
                                                          @"I am here",
                                                          @"Miss you",
                                                          @"I love you",
                                                          @"Call me when you get this",
                                                          @"Oye!"]];
    
    listBox.callback = ^(NSString *text) {
        [self doText:text];
    };
    
    [listBox show];
    [self.viewController.navigationController.view addSubview:listBox];
}

- (void)doText:(NSString *)text
{
    NSString *name = self.user.name;
    
    self.nameLabel.hidden = YES;
    self.hodorImage.hidden = YES;
    [self.busyIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[HDRNetworkProvider instance] sendText:name text:text];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.busyIndicator stopAnimating];
        self.nameLabel.hidden = NO;
        self.hodorImage.hidden = NO;
        self.nameLabel.text = @"SEND!";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.nameLabel.text = [name uppercaseString];
            [[HDRFriends instance] moveToTop:self.user];
            [self.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:self] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
    });
}


- (void) doHodor
{
    NSString *name = self.user.name;
    
    self.nameLabel.hidden = YES;
    self.hodorImage.hidden = YES;
    [self.busyIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[HDRNetworkProvider instance] sendHODOR:name];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.busyIndicator stopAnimating];
        self.nameLabel.hidden = NO;
        self.hodorImage.hidden = NO;
        self.nameLabel.text = @"HODORED!";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.nameLabel.text = [name uppercaseString];
            [[HDRFriends instance] moveToTop:self.user];
            [self.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:self] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
    });

}

- (void)onSwipe
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

- (void)flashHodor:(NSString *)text
{
    self.flashLabel.text = text;
    self.flashLabel.alpha = 1;
    [UIView animateWithDuration:2.0f delay:5.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.flashLabel.alpha = 0;
    } completion:nil];
}

#pragma mark IBACTIONS

- (IBAction)callHodor:(id)sender
{
    [self doHodor];
}

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
            [self.viewController refreshView];
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
                [self.viewController refreshView];
            });
        }
    });

}


#pragma mark Animation
- (void)rightAndBack:(void (^)(void))callback
{
    CGRect frame = self.contentView.frame;
    frame.origin.x = 70.0f;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.contentView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        CGRect frame2 = self.contentView.frame;
        frame2.origin.x = 0.0f;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.contentView.frame = frame2;
        }];
        
        if (callback)
        {
            callback();
        }
    }];
}

- (void)leftAndBack:(void (^)(void))callback
{
    CGRect frame1 = self.contentView.frame;
    frame1.origin.x = -70.0f;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.contentView.frame = frame1;
        
    } completion:^(BOOL finished) {
        
        CGRect frame2 = self.contentView.frame;
        frame2.origin.x = 0.0f;
        
        [UIView animateWithDuration:0.2f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.contentView.frame = frame2;
                         } completion:^(BOOL finished) {
                             
                         }];
        if (callback)
        {
            callback();
        }
        
    }];
}

@end



