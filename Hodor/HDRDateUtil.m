//
//  WMDateUtil.m
//  WhereMSG
//
//  Created by Shailesh Panwar on 3/9/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRDateUtil.h"

@implementation HDRDateUtil

+(NSDate *) utcNow
{
    NSDate *d  =[NSDate date];
    return [HDRDateUtil toUTC:d];
}

+(NSDate *) toUTC:(NSDate *)local
{
    if(local)
    {
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        NSInteger ii = -1 * zone.secondsFromGMT;
        NSDate *gmt = [[NSDate alloc] initWithTimeInterval:ii sinceDate:local];
        return gmt;
    }
    
    return nil;
}

+(NSDate *) toLocal:(double)ticks
{
    NSDate *utc = [NSDate dateWithTimeIntervalSince1970:ticks];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSDate *local = [[NSDate alloc] initWithTimeInterval:zone.secondsFromGMT sinceDate:utc];
    return local;
}


+(double) utcNowTicks
{
    NSDate *utc = [HDRDateUtil utcNow];
    return [utc timeIntervalSince1970];
}


+(NSInteger) getComponent:(NSCalendarUnit) unit date:(NSDate *) date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:unit fromDate:date];
    
    switch (unit) {
        case NSCalendarUnitYear:
            return [weekdayComponents year];
        case NSCalendarUnitMonth:
            return [weekdayComponents month];
        case NSCalendarUnitWeekOfMonth:
            return [weekdayComponents weekOfMonth];
        case NSCalendarUnitWeekday:
            return [weekdayComponents weekday];
        case NSCalendarUnitHour:
            return [weekdayComponents hour];
        case NSCalendarUnitMinute:
            return [weekdayComponents minute];
        case NSCalendarUnitSecond:
            return [weekdayComponents second];
        default:
            break;
    }
    
    return 0;
}


+(NSString *) getFormattedString:(NSDate *)date
{
    NSDate *senderDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM d, yyyy 'at' hh:mm aaa"];
    return [formatter stringFromDate:senderDate];
}

+(NSString *) getFormattedShortString:(NSDate *)date
{
    NSDate *senderDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMM d, yyyy"];
    return [formatter stringFromDate:senderDate];
}


@end






