//
//  HDRAddUserNameTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRAddUserNameTableViewCell.h"

@implementation HDRAddUserNameTableViewCell

- (void)awakeFromNib
{
    srand((unsigned)rand());
    
    // Initialization code
    CGFloat red = [self getNextRand];
    CGFloat green = [self getNextRand];
    CGFloat blue = [self getNextRand];
    self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    
    self.textField.delegate = self;
}

- (CGFloat) getNextRand
{
    return  fminf(fmaxf(rand()%170, 70.0f), 170.0f) / 255.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)startEditing:(id)sender
{
    [self.addBtn setHidden:YES];
    [self.textField setHidden:NO];
    [self.textField becomeFirstResponder];
}
@end
