//
//  HDRHomeTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRAnywhereTableViewCell.h"

@interface HDRAnywhereTableViewCell ()


@end

@implementation HDRAnywhereTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nameLabel.text = @"#ANYWHERE";
}

- (NSMutableArray *)loadMessagesNetwork
{
    return [[HDRNetworkProvider instance] fetchAnywhereMessages:self.user.lastSeenId];
}

- (void)doTextNetwork:(NSString *)text
{
    [[HDRNetworkProvider instance] sendTextToAnywhere:text];
}

- (void)doHodorNetwork
{
    [[HDRNetworkProvider instance] sendHODORToAnywhere];
}

@end




