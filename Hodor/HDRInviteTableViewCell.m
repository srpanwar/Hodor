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
    if ([MFMessageComposeViewController canSendText])
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
                    
                    NSString *personName = (__bridge NSString *)ABRecordCopyCompositeName(person);
                    NSLog(@"Removing %@",personName);
                    CFRelease((__bridge CFTypeRef)(personName));
                }
                
                if (phones)
                {
                    CFRelease(phones);
                }
            }
        }
        
        CFRelease((__bridge CFTypeRef)(allContacts));
        
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
    else
    {
        [self doShare];
    }
}

- (void)doShare
{
    NSString *string = [self getInviteMessage];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string]
                                      applicationActivities:nil];
    [self.viewController presentViewController:activityViewController
                                            animated:YES
                                          completion:nil];
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
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    NSString* mobile = nil;
    if (property == kABPersonPhoneProperty)
    {
        ABMultiValueRef phones = ABRecordCopyValue(person, property);
        long count = ABMultiValueGetCount(phones);
        mobile = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, identifier % count);
        if (phones) {
            CFRelease(phones);
        }
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
                
                picker.body = [self getInviteMessage];
                
                [self.viewController presentViewController:picker animated:YES completion:nil];
            }
        }];
    }
    
    if (mobile) {
        CFRelease(CFBridgingRetain(mobile));
    }
    
    return NO;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult) result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)getInviteMessage
{
    return [NSString stringWithFormat:NSLocalizedString(@"inviteMessage", @""), [HDRSession getCurrentUserName]];
}

@end



