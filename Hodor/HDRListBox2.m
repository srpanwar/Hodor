//
//  TRPJListBox.m
//  TripJournal
//
//  Created by Shailesh Panwar on 6/18/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRListBox2.h"

@interface HDRListBox2 ()

@property NSCache *cachedCells;

@end

@implementation HDRListBox2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.alpha = 0;
    self.cachedCells = [[NSCache alloc] init];
    self.collection = [[NSMutableArray alloc] init];
    
    self.fromLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];

    //self.backgroundColor = [UIColor colorWithPatternImage:[[self imageWithView:[[UIApplication sharedApplication] keyWindow]] applyLightEffect]];
    
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    
    self.tableView.sectionHeaderHeight = 0.0;
    //self.tableView.sectionFooterHeight = 0.0;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.contentView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:nil]];
    
    [self registerForKeyboardNotifications];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDRMessage *msg = [self.collection objectAtIndex:indexPath.row];
    
    if (msg.picture.length)
    {
        return 387.0f;
    }
    else
    {
        if (msg.content.length)
        {
            CGFloat height = 40.0f;
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 270.0f, MAXFLOAT)];
            
            //textView.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:23.0f];
            //textView.font = [UIFont fontWithName:@"CooperHewitt-Book" size:16.0f];
            //textView.font = [UIFont fontWithName:@"AmericanTypewriter-Condensed" size:22.0f];
            
            textView.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:32.0f];
            
            textView.text = msg.content;
            CGSize nSize = [textView sizeThatFits:CGSizeMake(290.0f, MAXFLOAT)];
            height += nSize.height + 21;
            
            return fmaxf(height, 190.0f);
        }
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellX = [self.cachedCells objectForKey:indexPath];
    if (cellX)
    {
        return cellX;
    }
    
    @try {
        HDRMessage *msg = [self.collection objectAtIndex:indexPath.row];
        HDRListTableViewCell *cell = nil;
        if (msg.picture.length)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HDRPictureTableViewCell" owner:self options:nil] lastObject];
        }
        else
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HDRMessageTableViewCell" owner:self options:nil] lastObject];
        }
        
        [cell setShowUserName:self.showUserName];
        [cell setShowLocation:self.showLocation];
        [cell setDatasource:msg];
        [cell colorify:indexPath.row];
        [self.cachedCells setObject:cell forKey:indexPath];
        
        return cell;
        
    }
    @catch (NSException *exception) {
        return [[UITableViewCell alloc] init];
    }
    @finally {
    }
}

- (void)close
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    CGRect hFrame = self.headeView.frame;
    CGRect frame = self.tableView.frame;
    hFrame.origin.y = frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        self.tableView.frame = frame;
        self.headeView.frame = hFrame;
    } completion:^(BOOL finished) {
        if (self.superview)
        {
            [self removeFromSuperview];
        }
    }];
}

- (void)animateUp
{
    CGRect hFrame = self.headeView.frame;
    CGRect frame = self.tableView.frame;
    
    CGFloat y = [UIScreen mainScreen].bounds.size.height - self.tableView.contentSize.height;
    y = fmaxf(y, 100.0f);
    CGFloat hy = y - hFrame.size.height;
    
    hFrame.origin.y = frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.tableView.frame = frame;
    self.headeView.frame = hFrame;
    
    frame.size.height = [UIScreen mainScreen].bounds.size.height - y;
    frame.origin.y = y;
    hFrame.origin.y = hy;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.frame = frame;
        self.headeView.frame = hFrame;
        self.alpha = 1;
    }];
}

- (void)show
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
    
    [self animateUp];
}


//[UIApplication sharedApplication] keyWindow]
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 10, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    self.tableView.hidden = YES;
    self.headeView.hidden = YES;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    self.tableView.hidden = NO;
    self.headeView.hidden = NO;
}

@end
