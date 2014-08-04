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
    [super awakeFromNib];
    
    // Initialization code
    self.textField.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:28];
    self.textField.delegate = self;
    UIColor *color = [UIColor colorWithWhite:0.95 alpha:0.8];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"TYPE USERNAME TO ADD" attributes:@{NSForegroundColorAttributeName: color}];
}

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters
{
    NSString *text = [field.text stringByReplacingCharactersInRange:range withString:characters];
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([characters rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound) && text.length < 50;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    
    if(textField.text.length)
    {
        HDRUser *user = [[HDRUser alloc] init];
        user.name = textField.text;
        user.isBlocked = NO;
        
        HDRUser *existingFriend = [[HDRFriends instance] getFriend:user.name];
        if (existingFriend)
        {
            [[HDRFriends instance] deleteFriend:existingFriend];
        }
        
        [[HDRFriends instance] addFriend:user];
        [self.viewController refreshView];
    }

    return YES;
}

- (IBAction)startEditing:(id)sender
{
    [self.addBtn setHidden:YES];
    [self.textField setHidden:NO];
    [self.textField becomeFirstResponder];
}
@end
