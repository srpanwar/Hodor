//
//  HDRInviteTableViewCell.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRInviteTableViewCell.h"

@implementation HDRInviteTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doContactSelection)];
    [self.contentView addGestureRecognizer:gestureRecognizer];
}


- (void) doContactSelection
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSString* mobile = nil;
    ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty));
    for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
    {
        //For Phone number
        mobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
        break;
    }
    NSLog(@"%@", mobile);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.recipients = @[mobile];
        
        picker.body = @"Checkout WhereMsg for you smartphone. Download it today from http://wheremsg.weebly.com";
        
        [self.viewController presentViewController:picker animated:YES completion:nil];
    }];
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end



