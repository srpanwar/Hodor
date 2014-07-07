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
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (int i =0; i < allContacts.count; i++)
    {
        ABRecordRef person = (__bridge ABRecordRef)([allContacts objectAtIndex:i]);
        
        if (person != nil)
        {
            ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            if (ABMultiValueGetCount(phones) == 0)
            {
                CFErrorRef error = nil;
                ABAddressBookRemoveRecord(addressBook, person, &error);
                NSLog(@"Removing %@",(__bridge NSString *)ABRecordCopyCompositeName(person));
            }
            
            CFRelease(phones);
        }
    }
    
    CFErrorRef saveError = nil;
    ABAddressBookSave(addressBook, &saveError);
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    picker.addressBook = addressBook;
    
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    picker.displayedProperties = displayedItems;
    
    // Show the picker
    [self.viewController presentViewController:picker animated:YES completion:nil];
    
    CFRelease(addressBook);
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString* mobile = nil;
    if (property == kABPersonPhoneProperty)
    {
        ABMultiValueRef phones = ABRecordCopyValue(person, property);
        long count = ABMultiValueGetCount(phones);
        mobile = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, identifier % count);
    }
    NSLog(@"%@", mobile);
    
    if (mobile && mobile.length)
    {
        [peoplePicker dismissViewControllerAnimated:YES completion:^{
            if ([MFMessageComposeViewController canSendText])
            {
                MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                picker.messageComposeDelegate = self;
                picker.recipients = @[mobile];
                
                picker.body = [NSString stringWithFormat:@"Why 'Yo' when you can 'Hodor'! Add my 'Hodor' username %@ (if you don't have the app get it here http://goo.gl/68WSRK)", [HDRCurrentUser getCurrentUserName]];
                
                [self.viewController presentViewController:picker animated:YES completion:nil];
            }
        }];
    }
    
    return NO;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end



