//
//  HDREntityTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HDRNetworkProvider.h"
#import "HDRFriendsProvider.h"
#import "HDRListBox.h"
#import "HDRListBox2.h"
#import "HDRSoundService.h"

#import "HDRTableViewCell.h"
#import "HDRSoundService.h"

@interface HDREntityTableViewCell : HDRTableViewCell

@property (nonatomic) HDRUser* user;
@property (nonatomic) NSMutableArray *messages;

@property (nonatomic) BOOL showUserName;
@property (nonatomic) BOOL showLocation;


@property (weak, nonatomic) IBOutlet UIView *metaView;
@property (weak, nonatomic) IBOutlet UIImageView *hodorImage;

@property (weak, nonatomic) IBOutlet UIImageView *busyImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busyIndicator;

@property (weak, nonatomic) IBOutlet UIButton *countBtn;

- (void)sendHodorNetwork;
- (void)sendTextNetwork:(NSString *)text picture:(NSString *)picture;

- (IBAction)callHodor:(id)sender;
- (IBAction)viewMessages:(id)sender;

- (void)loadMessages;
- (NSMutableArray *)loadMessagesNetwork;

- (void)firstRun;
- (void)rightSwipe:(void (^)(void))callback;
- (void)leftSwipe:(void (^)(void))callback;
- (void)rotateImageView:(UIImageView *)busyImage
               callback:(void(^)(void))completionBlock;

@end
