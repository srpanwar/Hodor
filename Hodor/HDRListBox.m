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
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.contentView addGestureRecognizer:singleTapGestureRecognizer];

    
    [self animateUp];
}

- (void)refresh:(NSMutableArray *)items
{
    self.collection = items;
    [self.tableView reloadData];
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
        
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-CondensedBold" size:23];
        cell.textLabel.text = self.collection[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.27 alpha:0.9];
        cell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.63];
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
    CGRect frame = self.tableView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;

    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)animateUp
{
    CGRect frame = self.tableView.frame;
    CGFloat y = frame.origin.y;
    
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.tableView.frame = frame;
    
    frame.origin.y = y;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.frame = frame;
        self.alpha = 1;
    }];
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
@end
