//
//  HDREntityTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HDRNetworkProvider.h"
#import "HDRFriends.h"
#import "HDRListBox.h"
#import "HDRListBox2.h"
#import "HDRUtils.h"

#import "HDRTableViewCell.h"
#import "HDRUtils.h"

@interface HDREntityTableViewCell : HDRTableViewCell

@property HDRUser* user;
@property NSMutableArray *messages;

@property (weak, nonatomic) IBOutlet UIView *metaView;
@property (weak, nonatomic) IBOutlet UIImageView *hodorImage;

@property (weak, nonatomic) IBOutlet UIImageView *busyImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *countBtn;

- (void)doHodorNetwork;
- (void)doTextNetwork:(NSString *)text picture:(NSString *)picture;

- (IBAction)callHodor:(id)sender;
- (IBAction)viewMessages:(id)sender;

- (void)loadMessages;
- (NSMutableArray *)loadMessagesNetwork;

- (void)firstRun;
- (void)rightAndBack:(void (^)(void))callback;
- (void)leftAndBack:(void (^)(void))callback;
- (void)rotateImageView:(UIImageView *)busyImage callback:(void(^)(void))completionBlock;

@end
