//
//  NSDate+Util.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/13/15.
//  Copyright (c) 2015 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

+ (NSDate *)toLocal:(double)ticks;
+ (NSDate *)utcNow;
+ (double)utcNowTicks;
+ (NSDate *)toUTC:(NSDate *)local;

- (NSInteger)getComponent:(NSCalendarUnit)unit;
- (NSString *)getFormattedString;
- (NSString *)getShortFormattedString;

@end
