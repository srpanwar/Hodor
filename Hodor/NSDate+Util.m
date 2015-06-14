//
//  NSDate+Util.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/13/15.
//  Copyright (c) 2015 Troupe Of Vagrants. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

+ (NSDate *)utcNow
{
    NSDate *d  =[NSDate date];
    return [NSDate toUTC:d];
}

+ (NSDate *)toUTC:(NSDate *)local
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

+ (NSDate *)toLocal:(double)ticks
{
    NSDate *utc = [NSDate dateWithTimeIntervalSince1970:ticks];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSDate *local = [[NSDate alloc] initWithTimeInterval:zone.secondsFromGMT sinceDate:utc];
    return local;
}


+ (double)utcNowTicks
{
    NSDate *utc = [NSDate utcNow];
    return [utc timeIntervalSince1970];
}


- (NSInteger)getComponent:(NSCalendarUnit)unit
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:unit fromDate:self];
    
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


- (NSString *)getFormattedString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy hh:mm aaa"];
    return [formatter stringFromDate:self];
}


- (NSString *)getShortFormattedString
{
    NSDate *now = [NSDate date];
    NSString *format = nil;
    
    if (([now getComponent:NSCalendarUnitYear] != [self getComponent:NSCalendarUnitYear]) ||
        ([now getComponent:NSCalendarUnitMonth] != [self getComponent:NSCalendarUnitMonth]) ||
        ([now getComponent:NSCalendarUnitWeekOfMonth] != [self getComponent:NSCalendarUnitWeekOfMonth]) ||
        ([now getComponent:NSCalendarUnitWeekday] != [self getComponent:NSCalendarUnitWeekday])
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
    return [formatter stringFromDate:self];
}



@end
