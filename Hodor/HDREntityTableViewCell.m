//
//  HDREntityTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDREntityTableViewCell.h"

@implementation HDREntityTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.messages = [[NSMutableArray alloc] init];
    
    self.busyImage.alpha = 0;
    self.nameLabel.text = @"";
    
    self.countBtn.titleLabel.font =  [UIFont fontWithName:@"OpenSans-CondensedBold" size:17];
    self.countBtn.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    self.countBtn.layer.borderWidth = 1;
    self.countBtn.layer.cornerRadius = 13.5;
    self.countBtn.hidden = YES;
    
    self.hodorImage.layer.cornerRadius = 15;
    
    //text
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(showTextTemplatesUI)];
    [self.nameLabel addGestureRecognizer:singleTapGestureRecognizer];
    
    //text
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(resetMessageReadCounter)];
    doubleTapGestureRecognizer.numberOfTouchesRequired = 2;
    [self.nameLabel addGestureRecognizer:doubleTapGestureRecognizer];
}

- (void)resetMessageReadCounter
{
    self.user.lastSeenId = 0;
    [[HDRFriendsProvider instance] setLastSeenId:self.user.name
                                            last:self.user.lastSeenId];
    [self loadMessages];
}

- (void)firstRun
{
    //first run
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (((int)[self getNextRand:30.0f max:60.0f] % 70) / 70.0f) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self rightSwipe:nil];
    });
}

- (void)loadMessages
{
    dispatch_async_default(^{
        self.countBtn.hidden = YES;
        self.messages = [self loadMessagesNetwork];
        if (self.messages.count)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countBtn.hidden = NO;
                [self.countBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.messages.count]
                               forState:UIControlStateNormal];
            });
        }
    });
}

- (NSMutableArray *)loadMessagesNetwork
{
    return [[HDRNetworkProvider instance] fetchMessages:self.user.name
                                                  after:self.user.lastSeenId];
}


#pragma mark GESTURE ACTIONS

- (void)showTextTemplatesUI
{
    HDRListBox *listBox = (HDRListBox *)[[[NSBundle mainBundle] loadNibNamed:@"HDRListBox"
                                                                       owner:nil
                                                                     options:nil] lastObject];
    [listBox setFrame:[UIScreen mainScreen].bounds];
    listBox.viewController = self.viewController;
    listBox.collection = [HDRNetworkProvider instance].triviaList;
    
    listBox.callback = ^(NSString *text, NSString *picture) {
        [self sendText:text picture:picture];
    };
    
    
    [listBox show];
    [self.viewController.navigationController.view addSubview:listBox];
}

- (void)sendText:(NSString *)text picture:(NSString *)picture
{
    [self sendTextNetwork:text picture:picture];
    [self showSendHint:@"SEND!"];
}

- (void)sendTextNetwork:(NSString *)text picture:(NSString *)picture
{
    NSString *textP = text ? text : @"";
    NSString *pictureP = picture ? picture : @"";
    
    dispatch_async_default(^{
        [[HDRNetworkProvider instance] sendText:self.user.name
                                           text:textP
                                        picture:pictureP];
    });
}

- (void) sendHodor
{
    [self sendHodorNetwork];
    [self showSendHint:@"HODORED!"];
}

- (void)sendHodorNetwork
{
    dispatch_async_default(^{
        [[HDRNetworkProvider instance] sendHODOR:self.user.name];
    });
}

- (void)showSendHint:(NSString *)message
{
    //hide the metadataview
    self.metaView.hidden = YES;
    
    [self rotateImageView:self.busyImage callback:^{
        self.metaView.hidden = NO;
        self.nameLabel.text = message;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.nameLabel.text = [self.user.name uppercaseString];
            [[HDRFriendsProvider instance] moveToTop:self.user];
            [self.tableView moveRowAtIndexPath:[self.tableView indexPathForCell:self]
                                   toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });
    }];
}


#pragma mark IBACTIONS

- (IBAction)callHodor:(id)sender
{
    [self sendHodor];
}

- (IBAction)viewMessages:(id)sender
{
    if (self.messages.count)
    {
        HDRMessage *msg = self.messages[0];
        
        //set the last seen id
        [[HDRFriendsProvider instance] setLastSeenId:self.user.name last:msg.msgId];
        
        //show the messages to the user
        HDRListBox2 *listBox = (HDRListBox2 *)[[[NSBundle mainBundle] loadNibNamed:@"HDRListBox2" owner:nil options:nil] lastObject];
        [listBox setFrame:[UIScreen mainScreen].bounds];
        
        listBox.fromLabel.text = [self.user.name uppercaseString];
        listBox.collection = self.messages;
        listBox.callback = nil;
        
        listBox.showUserName = self.showUserName;
        listBox.showLocation = self.showLocation;
        
        [listBox show];
        [self.viewController.navigationController.view addSubview:listBox];
    }
}


#pragma mark Animation
- (void)rightSwipe:(void (^)(void))callback
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

- (void)leftSwipe:(void (^)(void))callback
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

- (void)rotateImageView:(UIImageView *)busyImage
               callback:(void(^)(void))completionBlock
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HDRSoundService playSoundOutgoing];
    });
    
    busyImage.alpha = 1;
    
    //rotation
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 2 * 0.25 ];
    rotationAnimation.duration = 0.4f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 4.5;
    [busyImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [UIView animateWithDuration:0.5f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         busyImage.alpha = 0;
                     } completion:^(BOOL finished) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if (completionBlock)
                             {
                                 completionBlock();
                             }
                         });
                     }];
}

@end

