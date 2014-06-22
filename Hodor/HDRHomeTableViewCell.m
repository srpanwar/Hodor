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
     srand((unsigned)rand());
    
    // Initialization code
    self.menuView.alpha = 0;
    self.nameLabel.text = @"";
    
    CGFloat red = [self getNextRand];
    CGFloat green = [self getNextRand];
    CGFloat blue = [self getNextRand];
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe)];
    [mSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.contentView addGestureRecognizer:mSwipeUpRecognizer];

}

- (CGFloat) getNextRand
{
    return  fminf(fmaxf(rand()%170, 90.0f), 170.0f) / 255.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
