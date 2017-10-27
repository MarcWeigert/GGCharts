//
//  NSDate+GGDate.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NSDate+GGDate.h"

@implementation NSDate (GGDate)

- (NSCalendar *)calendar {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
#else
    return [NSCalendar currentCalendar];
#endif
}

- (NSInteger)year
{
    return [[[self calendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month
{
    return [[[self calendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day
{
    return [[[self calendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour
{
    return [[[self calendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute
{
    return [[[self calendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second
{
    return [[[self calendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday
{
    return [[[self calendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSString *)dayFromWeekday
{
    return [NSDate dayFromWeekday:self];
}

+ (NSString *)dayFromWeekday:(NSDate *)date
{
    switch([date weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)stringWithFormat:(NSString *)format
{
    return [[NSDate date] stringWithFormat:format];
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format
{
    return [date stringWithFormat:format];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

+ (NSString *)ymdFormatJoinedByString:(NSString *)string
{
    return [NSString stringWithFormat:@"yyyy%@MM%@dd", string, string];
}

+ (NSString *)ymdHmsFormat
{
    return [NSString stringWithFormat:@"%@ %@", [self ymdFormat], [self hmsFormat]];
}

+ (NSString *)ymdFormat
{
    return @"yyyy-MM-dd";
}

+ (NSString *)hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)dmyFormat {
    return @"dd/MM/yyyy";
}

+ (NSString *)myFormat {
    return @"MM/yyyy";
}

- (NSDate *)dateAddByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents * adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth: month];
    [adcomps setDay:day];
    return [self.calendar dateByAddingComponents:adcomps toDate:self options:0];
}

- (NSDate *)dateAddMonthScalerFirstDay:(NSInteger)month
{
    return [self dateAddByYear:0 month:month day:-self.day + 1];
}

- (NSDate *)dateAddYearScalerFistMonthDay:(NSInteger)year
{
    return [self dateAddByYear:year month:-self.month + 1 day:-self.day + 1];
}

- (NSInteger)interValDay:(NSDate *)date
{
    return [self.calendar components:NSCalendarUnitDay fromDate:self toDate:date options:0].day;
}

- (NSInteger)interValMonth:(NSDate *)date
{
    return [self.calendar components:NSCalendarUnitMonth fromDate:self toDate:date options:0].month;
}

- (NSInteger)interValWeek:(NSDate *)date
{
    return [self.calendar components:NSCalendarUnitWeekOfYear fromDate:self toDate:date options:0].weekOfYear;
}

- (NSInteger)interValDayWithoutWeekEndDay:(NSDate *)date
{
    NSInteger week = [self interValWeek:date];
    return [self interValDay:date] - week * 2;
}

@end
