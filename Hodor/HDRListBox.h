//
//  TRPJListBox.h
//  TripJournal
//
//  Created by Shailesh Panwar on 6/18/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"
#import "HDRImageUtil.h"
#import "HDRTranslator.h"
#import "HDRS3Storage.h"

typedef void (^SelectionCallBack)(NSString *text, NSString *picture);

@interface HDRListBox : UIView<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *buttonsContainer;
@property (weak, nonatomic) IBOutlet UITextField *textBox;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *translatedView;
@property (weak, nonatomic) IBOutlet UILabel *translatedLabel;

@property(readwrite, copy) SelectionCallBack callback;
@property NSMutableArray *collection;
@property UIViewController *viewController;

- (IBAction)sendPicture:(id)sender;
- (IBAction)sendCustomText:(id)sender;
- (void)show;
- (void)close;

@end
