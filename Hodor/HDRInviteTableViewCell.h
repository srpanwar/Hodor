//
//  HDRInviteTableViewCell.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "HDRTableViewCell.h"
#import "HDRSession.h"

@interface HDRInviteTableViewCell : HDRTableViewCell<ABPeoplePickerNavigationControllerDelegate,MFMessageComposeViewControllerDelegate>


@end
