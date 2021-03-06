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
@property NSCache *cachedCells;

@property CGRect rateFrame;
@property CGRect shareFrame;
@property CGRect aboutFrame;

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

    self.cachedCells = [[NSCache alloc] init];
    
    self.pageTitleLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];
    self.pageTitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"header", @""), [HDRSession getCurrentUserName]];

    self.ratingBtn.layer.cornerRadius = 20.0f;
    self.shareBtn.layer.cornerRadius = 20.0f;
    self.moreBtn.layer.cornerRadius = 20.0f;
    self.aboutBtn.layer.cornerRadius = 20.0f;
    
    self.ratingBtn.alpha = 0;
    self.shareBtn.alpha = 0;
    self.aboutBtn.alpha = 0;
    self.overlayVew.alpha = 0;
    
    self.rateFrame = self.ratingBtn.frame;
    self.shareFrame = self.shareBtn.frame;
    self.aboutFrame = self.aboutBtn.frame;
    self.aboutBtn.frame = self.ratingBtn.frame = self.shareBtn.frame = self.moreBtn.frame;
    
    self.nounBtn.layer.cornerRadius = 5;
    self.nounBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nounBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.lingoJamBtn.layer.cornerRadius = 5;
    self.lingoJamBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.lingoJamBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self colorifyRatings];
    //[self checkPushEnabled];
    
    //add the tap gesture on the overlay view
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMore:)];
    [self.overlayVew addGestureRecognizer:singleTapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.overlayVew.backgroundColor = [UIColor colorWithPatternImage:[[self imageWithView:self.view] applyBlurWithRadius:30 tintColor:[UIColor clearColor] saturationDeltaFactor:0 maskImage:nil]];
    });
    
    //add the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor whiteColor]];
     
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)sender
{
    [self refreshView:YES];
    [sender endRefreshing];
};


- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    srand((unsigned)time(NULL));
    
    [self colorifyRatings];
    //[self checkPushEnabled];
    [self refreshView:NO];
}

- (void)colorifyRatings
{
    self.ratingBtn.imageView.image = [self.ratingBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.ratingBtn.imageView.tintColor = [UIColor colorWithWhite:0.95 alpha:1];
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

- (void)refreshView:(BOOL)clearCache
{
    self.friends = [NSMutableArray arrayWithArray:[[HDRFriendsProvider instance] getFriends]];
    
    if (clearCache)
    {
        [self.cachedCells removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.friends = [NSMutableArray arrayWithArray:[[HDRFriendsProvider instance] getFriends]];
    return self.friends.count + 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDRTableViewCell *cell = nil;
    
    if (indexPath.row < (self.friends.count))
    {
        HDRUser *user = self.friends[indexPath.row];
        HDRHomeTableViewCell *cellX = [self.cachedCells objectForKey:user.name];
        if (!cellX)
        {
            cellX = (HDRHomeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HDRHomeTableViewCell"
                                                                           owner:nil options:nil] lastObject];
            cellX.user = user;
            cellX.nameLabel.text = [user.name uppercaseString];
            
            [self.cachedCells setObject:cellX forKey:user.name];
        }

        cell = cellX;
        
        //fetch and show messages
        [cellX loadMessages];
    }
    else
    {
        switch(indexPath.row - self.friends.count)
        {
            case 0:
            {
                HDRInviteTableViewCell *cellX = (HDRInviteTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HDRInviteTableViewCell" owner:nil options:nil] lastObject];
                
                cell = cellX;
            }
                break;
            case 1:
            {
                HDRAddUserNameTableViewCell *cellX = (HDRAddUserNameTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HDRAddUserNameTableViewCell" owner:nil options:nil] lastObject];
                
                cell = cellX;
            }
                break;
        }
    }
    
    cell.viewController = self;
    cell.tableView = tableView;
    
    //colorify the tableview
    [cell colorify:indexPath.row];
    
    return cell;
}


- (IBAction)doShare:(id)sender
{
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"inviteMessage", @""), [HDRSession getCurrentUserName]];
    NSURL *URL = [NSURL URLWithString:[[HDRConfig instance] homePageUrl]];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:nil];
}

- (IBAction)rateTheApp:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[HDRConfig instance] itunesUrl]]];
}

- (IBAction)showMore:(id)sender
{
    static BOOL state = YES;
    if (state)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.ratingBtn.frame = self.rateFrame;
            self.shareBtn.frame = self.shareFrame;
            self.aboutBtn.frame = self.aboutFrame;
            self.aboutBtn.alpha = self.ratingBtn.alpha = self.shareBtn.alpha = 1;
            self.moreBtn.alpha = 0.8;
            self.overlayVew.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.ratingBtn.frame = self.moreBtn.frame;
            self.shareBtn.frame = self.moreBtn.frame;
            self.aboutBtn.frame = self.moreBtn.frame;
            self.aboutBtn.alpha = self.ratingBtn.alpha = self.shareBtn.alpha = 0;
            self.moreBtn.alpha = 1;
            self.overlayVew.alpha = 0;
        }];
    }
    
    state = !state;
}

- (IBAction)gotoNounProject:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://thenounproject.com/simplisto/"]];
}

- (IBAction)gotoLingoJam:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lingojam.com/"]];
}

- (IBAction)showNounLabel:(id)sender
{
    [self showMore:sender];
    
    CGRect frame1 = self.nounBtn.frame;
    CGRect frame2 = self.lingoJamBtn.frame;
    frame1.origin.x = -10;
    frame2.origin.x = 10;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.nounBtn.frame = frame1;
        self.lingoJamBtn.frame = frame2;
    } completion:^(BOOL finished) {

        CGRect frame3 = self.nounBtn.frame;
        frame3.origin.x = -1 * frame3.size.width;

        CGRect frame4 = self.lingoJamBtn.frame;
        frame4.origin.x = frame4.size.width;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5f animations:^{
                self.nounBtn.frame = frame3;
                self.lingoJamBtn.frame = frame4;
            }];
        });
    }];

}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
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

@end
