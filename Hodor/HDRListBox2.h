//
//  TRPJListBox.h
//  TripJournal
//
//  Created by Shailesh Panwar on 6/18/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"
#import "HDRMessageTableViewCell.h"
#import "HDRMessage.h"
#import "HDRDateUtil.h"

typedef void (^SelectionCallBack)(NSString *text);

@interface HDRListBox2 : UIView<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

@property (weak, nonatomic) IBOutlet UIView *headeView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(readwrite, copy) SelectionCallBack callback;
@property NSMutableArray *collection;

- (void)show;
- (void)close;

@end
