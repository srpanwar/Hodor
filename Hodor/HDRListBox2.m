//
//  TRPJListBox.m
//  TripJournal
//
//  Created by Shailesh Panwar on 6/18/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRListBox2.h"

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
    self.collection = [[NSMutableArray alloc] init];
    
    self.fromLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:24];

    //self.backgroundColor = [UIColor colorWithPatternImage:[[self imageWithView:[[UIApplication sharedApplication] keyWindow]] applyLightEffect]];
    self.textBox.delegate = self;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.sectionFooterHeight = 0.0;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.contentView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:nil]];
    
    [self registerForKeyboardNotifications];
    [self animateUp];
}

- (void)refresh:(NSMutableArray *)items
{
    self.collection = items;
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.textBox.text.length > 100)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendCustomText:nil];
    return YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    HDRMessage *msg = [self.collection objectAtIndex:indexPath.row];
    if (msg.content.length)
    {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 290.0f, MAXFLOAT)];
        textView.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:18.0f];
        textView.text = msg.content;
        CGSize nSize = [textView sizeThatFits:CGSizeMake(290.0f, MAXFLOAT)];
        height = 15.0f + nSize.height;
    }
    
    return height;
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
    @try {
        
        HDRMessageTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HDRMessageTableViewCell" owner:self options:nil] lastObject];
        
        HDRMessage *msg = [self.collection objectAtIndex:indexPath.row];
        
        cell.messageTextView.text = msg.content;
        [cell.messageTextView sizeToFit];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *capturedStartDate = [formatter dateFromString: msg.createdDateString];
        NSLog(@"%@", capturedStartDate);

        cell.dateLabel.text = [HDRDateUtil getFormattedString:[HDRDateUtil toLocal:        [capturedStartDate timeIntervalSince1970]]];

        cell.backgroundColor = [UIColor clearColor];
        
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
    
    CGRect bFrame = self.buttonsContainer.frame;
    CGRect hFrame = self.headeView.frame;
    CGRect frame = self.tableView.frame;
    hFrame.origin.y = bFrame.origin.y = frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        self.tableView.frame = frame;
        self.buttonsContainer.frame = bFrame;
        self.headeView.frame = hFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)animateUp
{
    CGRect bFrame = self.buttonsContainer.frame;
    CGRect hFrame = self.headeView.frame;
    CGRect frame = self.tableView.frame;
    
    CGFloat y = frame.origin.y;
    CGFloat by = bFrame.origin.y;
    CGFloat hy = hFrame.origin.y;
    
    hFrame.origin.y = bFrame.origin.y = frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.tableView.frame = frame;
    self.buttonsContainer.frame = bFrame;
    self.headeView.frame = hFrame;
    
    frame.origin.y = y;
    bFrame.origin.y = by;
    hFrame.origin.y = hy;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.frame = frame;
        self.buttonsContainer.frame = bFrame;
        self.headeView.frame = hFrame;
        self.alpha = 1;
    }];
}

- (IBAction)sendCustomText:(id)sender
{
    NSString *text = self.textBox.text;
    if (self.callback && text.length)
    {
        self.callback(text);
    }
    
    [self close];
}

- (void)show
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
