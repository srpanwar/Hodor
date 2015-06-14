//
//  HDRBaseViewController.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/3/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRBaseViewController.h"

@interface HDRBaseViewController ()

@end

@implementation HDRBaseViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView:(BOOL)clearCache
{
    
}

@end
