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
    self.nameLabel.text = @"";
    
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe)];
    [mSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.contentView addGestureRecognizer:mSwipeUpRecognizer];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHodor)];
    [self.contentView addGestureRecognizer:gestureRecognizer];
}

- (void) doHodor
{
    NSString *name = self.user.name;
    
    self.nameLabel.hidden = YES;
    [self.busyIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[HDRNetworkProvider instance] sendHODOR:name];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.nameLabel.hidden = NO;
            self.nameLabel.text = @"HODORED!";
            [self.busyIndicator stopAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.nameLabel.text = name;
                [self.busyIndicator stopAnimating];
                [[HDRFriends instance] moveToTop:self.user];
                [self.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:self] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [self colorify];
            });
        });
        
    });
}

- (void)onSwipe
{
    [UIView animateWithDuration:0.3f animations:^{
        self.menuView.alpha = 1;
    }];
}

- (IBAction)onCancel:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
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
            [self.tableView reloadData];
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
                [self.tableView reloadData];
            });
        }
    });

}
@end
