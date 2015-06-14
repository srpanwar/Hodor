//
//  HDRRefreshableView.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/14/15.
//  Copyright (c) 2015 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDRRefreshableView <NSObject>

- (void)refreshView:(BOOL)clearCache;

@end
