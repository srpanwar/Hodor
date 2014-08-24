//
//  HDRHereTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRHereTableViewCell.h"

@implementation HDRHereTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nameLabel.text = @"#HERE";
}

- (NSMutableArray *)loadMessagesNetwork
{
    return [[HDRNetworkProvider instance] fetchHereMessages:self.user.lastSeenId];
}

- (void)doTextNetwork:(NSString *)text picture:(NSString *)picture
{
    if (text && text.length)
    {
        [[HDRNetworkProvider instance] sendTextToHere:text];
    }
}

- (void)doHodorNetwork
{
    [[HDRNetworkProvider instance] sendHODORToHere];
}

@end
