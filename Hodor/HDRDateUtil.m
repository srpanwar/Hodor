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
    [formatter setDateFormat:@"MMM d, yyyy hh:mm aaa"];
    return [formatter stringFromDate:senderDate];
}


+(NSString *) getFormattedShortString:(NSDate *)date
{
    NSDate *now = [NSDate date];
    NSDate *senderDate = date;
    NSString *format = nil;
    
    if (([HDRDateUtil getComponent:NSCalendarUnitYear date:now] != [HDRDateUtil getComponent:NSCalendarUnitYear date:senderDate]) ||
        ([HDRDateUtil getComponent:NSCalendarUnitMonth date:now] != [HDRDateUtil getComponent:NSCalendarUnitMonth date:senderDate]) ||
        ([HDRDateUtil getComponent:NSCalendarUnitWeekOfMonth date:now] != [HDRDateUtil getComponent:NSCalendarUnitWeekOfMonth date:senderDate]) ||
        ([HDRDateUtil getComponent:NSCalendarUnitWeekday date:now] != [HDRDateUtil getComponent:NSCalendarUnitWeekday date:senderDate])
        )
    {
        format = @"MMM d, yyyy hh:mm aaa";
    }
    else
    {
        format = @"hh:mm a";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:senderDate];
//
//    NSDate *senderDate = date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"EEE, MMM d, yyyy"];
//    return [formatter stringFromDate:senderDate];
}


@end






