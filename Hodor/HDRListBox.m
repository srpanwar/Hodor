//
//  TRPJListBox.m
//  TripJournal
//
//  Created by Shailesh Panwar on 6/18/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRListBox.h"

@implementation HDRListBox

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
    
    //self.backgroundColor = [UIColor colorWithPatternImage:[[self imageWithView:[[UIApplication sharedApplication] keyWindow]] applyLightEffect]];
    self.textBox.delegate = self;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = self.scrollView.bounds.size;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.sectionFooterHeight = 0.0;

    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.contentView addGestureRecognizer:singleTapGestureRecognizer];

    [self registerForKeyboardNotifications];
    [self animateUp];
    
    //[self.textBox becomeFirstResponder];
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
    return 60.0f;
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
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuseIdentifier"];
        
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:20];
        cell.textLabel.minimumScaleFactor = 0.7;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = self.collection[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.27 alpha:0.9];
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }
    @catch (NSException *exception) {
        return [[UITableViewCell alloc] init];
    }
    @finally {
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = self.collection[indexPath.row];
    if (self.callback)
    {
        self.callback(text);
    }
    
    [self close];
}

- (void)close
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    CGRect bFrame = self.buttonsContainer.frame;
    CGRect frame = self.tableView.frame;
    bFrame.origin.y = frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        self.tableView.frame = frame;
        self.buttonsContainer.frame = bFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)animateUp
{
    CGRect bFrame = self.buttonsContainer.frame;
    CGRect frame = self.tableView.frame;
    CGFloat y = frame.origin.y;
    CGFloat by = bFrame.origin.y;
    
    bFrame.origin.y = frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.tableView.frame = frame;
    self.buttonsContainer.frame = bFrame;
    
    frame.origin.y = y;
    bFrame.origin.y = by;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.frame = frame;
        self.buttonsContainer.frame = bFrame;
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
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    self.tableView.hidden = NO;
}

@end
