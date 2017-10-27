//
//  NSDate+GGDate.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GGDate)

@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, assign, readonly) NSInteger weekday;

- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

+ (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

+ (NSString *)ymdFormatJoinedByString:(NSString *)string;
+ (NSString *)ymdHmsFormat;
+ (NSString *)ymdFormat;
+ (NSString *)hmsFormat;
+ (NSString *)dmyFormat;
+ (NSString *)myFormat;

- (NSDate *)dateAddMonthScalerFirstDay:(NSInteger)month;
- (NSDate *)dateAddYearScalerFistMonthDay:(NSInteger)year;

- (NSInteger)interValDay:(NSDate *)date;
- (NSInteger)interValMonth:(NSDate *)date;
- (NSInteger)interValWeek:(NSDate *)date;
- (NSInteger)interValDayWithoutWeekEndDay:(NSDate *)date;

@end
