//
//  WMDateUtil.h
//  WhereMSG
//
//  Created by Shailesh Panwar on 3/9/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDRDateUtil : NSObject

+(NSDate *) utcNow;

+(double) utcNowTicks;

+(NSDate *) toUTC:(NSDate *)local;

+(NSDate *) toLocal:(double)ticks;

+(NSInteger) getComponent:(NSCalendarUnit) unit date:(NSDate *) date;

+(NSString *) getFormattedString:(NSDate *)date;
+(NSString *) getFormattedShortString:(NSDate *)date;

@end
