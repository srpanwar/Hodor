//
//  HDRHomeViewController.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/21/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRHomeViewController.h"

@interface HDRHomeViewController ()

@property NSMutableArray *friends;

@end

@implementation HDRHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    srand((unsigned)time(NULL));
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    self.shareBtn.layer.cornerRadius = 20.0f;
    self.ratingBtn.layer.cornerRadius = 20.0f;
    
    self.pageTitleLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    self.pageTitleLabel.text = [NSString stringWithFormat:@"HODOR + YOU(%@)", [HDRCurrentUser getCurrentUserName]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self colorifyRatings];
    [self checkPushEnabled];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)colorifyRatings
{
    self.ratingBtn.imageView.image = [self.ratingBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.ratingBtn.imageView.tintColor = [UIColor colorWithRed:200/255.0f green:40/255.0f blue:40/255.0f alpha:0.7];
}
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    srand((unsigned)time(NULL));
    [self colorifyRatings];
    [self checkPushEnabled];
    [self refreshView];
}

- (void)checkPushEnabled
{
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types & UIRemoteNotificationTypeAlert)
    {
        self.enablePushView.hidden = YES;
    }
    else
    {
        self.enablePushView.hidden = NO;
    }
}

- (void)refreshView
{
    self.friends = [NSMutableArray arrayWithArray:[[HDRFriends instance] getFriends]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.friends = [NSMutableArray arrayWithArray:[[HDRFriends instance] getFriends]];
    return self.friends.count + 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDRTableViewCell *cell = nil;
    
    if (indexPath.row < (self.friends.count))
    {
        HDRUser *user = self.friends[indexPath.row];
        HDRHomeTableViewCell *cell1 = (HDRHomeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HDRHomeTableViewCell" owner:nil options:nil] lastObject];

        cell1.user = user;
        cell1.nameLabel.text = [user.name uppercaseString];
        cell = cell1;
        
        //flash
        if (self.userWhoPinged && [self.userWhoPinged caseInsensitiveCompare:cell1.user.name] == NSOrderedSame)
        {
            self.userWhoPinged = nil;
            NSString *pingedText = self.userPingedText;
            
            self.userWhoPinged = nil;
            self.userPingedText = nil;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [cell1 flashHodor: pingedText];
            });
        }
    }
    else
    {
        if (indexPath.row == (self.friends.count + 1))
        {
            HDRAddUserNameTableViewCell *cell2 = (HDRAddUserNameTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HDRAddUserNameTableViewCell" owner:nil options:nil] lastObject];

            cell = cell2;
        }
        else
        {
            HDRInviteTableViewCell *cell3 = (HDRInviteTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HDRInviteTableViewCell" owner:nil options:nil] lastObject];
            
            cell = cell3;
        }
    }
    
    cell.viewController = self;
    cell.tableView = tableView;
    [cell colorify:indexPath.row];
    
    return cell;
}


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 30, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)doShare:(id)sender
{
    NSString *string = @"Why 'Yo' when you can 'Hodor'!!";
    NSURL *URL = [NSURL URLWithString:@"http://troupeofvagrants.weebly.com/hodor.html"];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];

}

- (IBAction)rateTheApp:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id892252299"]];
}

@end
