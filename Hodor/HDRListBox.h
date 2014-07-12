//
//  TRPJListBox.h
//  TripJournal
//
//  Created by Shailesh Panwar on 6/18/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

typedef void (^SelectionCallBack)(NSString *text);

@interface HDRListBox : UIView<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *collection;

@property(readwrite, copy) SelectionCallBack callback;

- (void)show;
- (void)close;

@end
