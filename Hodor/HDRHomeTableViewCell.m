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
    NSString *name = self.nameLabel.text;
    
    self.nameLabel.hidden = YES;
    [self.busyIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[HDRNetworkProvider instance] sendHODOR:name];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.nameLabel.hidden = NO;
            self.nameLabel.text = @"HODORED!";
            [self.busyIndicator stopAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.nameLabel.text = name;
                [self.busyIndicator stopAnimating];
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

- (IBAction)onDelete:(id)sender {
}

- (IBAction)onBlock:(id)sender {
}
@end
