//
//  NSDate+Extend.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/20.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

NSString *const XJDateFormat_y_M_d = @"yyyy-MM-dd";      ///< 格式化类型 yyyy-MM-dd
NSString *const XJDateFormat_H_m_s = @"HH:mm:ss";        ///< 格式化类型 HH:mm:ss
NSString *const XJDateFormat_h_m_s = @"hh:mm:ss";        ///< 格式化类型 hh:mm:ss
NSString *const XJDateFormat_y_M_d_H_m_s = @"yyyy-MM-dd HH:mm:ss";   ///< 格式化类型 yyyy-MM-dd HH:mm:ss
NSString *const XJDateFormat_y_M_d_h_m_s = @"yyyy-MM-dd hh:mm:ss";   ///< 格式化类型 yyyy-MM-dd hh:mm:ss
NSString *const XJDateFormat_yMd = @"yyyyMMdd";                      ///< 格式化类型 yyyyMMdd
NSString *const XJDateFormat_zh_y_M_d = @"yyyy年MM月dd日";            ///< 格式化类型 yyyy年MM月dd日
NSString *const XJDateFormat_zh_y_M_d_H_m_s = @"yyyy年MM月dd日 HH:mm:ss";   ///< 格式化类型 yyyy年MM月dd日 HH:mm:ss
NSString *const XJDateFormat_zh_y_M_d_h_m_s = @"yyyy年MM月dd日 hh:mm:ss";   ///< 格式化类型 yyyy年MM月dd日 hh:mm:ss

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

#pragma mark - DateFormat
- (NSString *)stringWithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)dateFromString:(NSString *)string withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter dateFromString:string];
}

#pragma mark - 日期时间自身信息获取
- (NSString *)getYear
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"yyyy";
    //NSString *year = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    NSString *year = [@(components.year) stringValue];
    
    return year;
}

- (NSString *)getQuarter
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"q";
    //NSString *quarter = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger q = [calendar ordinalityOfUnit:NSCalendarUnitQuarter inUnit:NSCalendarUnitYear forDate:self];
    NSString *quarter = [@(q) stringValue];
    
    return quarter;
}

- (NSString *)getMonth
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"M";
    //NSString *month = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    NSString *month = [@(components.month) stringValue];
    
    return month;
}

- (NSString *)getWeekOfYear
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"w";
    //NSString *week = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    NSString *week = [@(components.weekOfYear) stringValue];
    
    return week;
}

- (NSString *)getWeekOfMonth
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"W";
    //NSString *week = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    NSString *week = [@(components.weekOfMonth) stringValue];
    
    return week;
}

- (NSString *)getDayOfYear
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"D";
    NSString *day = [dateFormatter stringFromDate:self];
    return day;
}

- (NSString *)getDayOfMonth
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"d";
    //NSString *day = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    NSString *day = [@(components.day) stringValue];
    
    return day;
}

- (NSString *)getDayOfWeek
{
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"e";
    //NSString *day = [dateFormatter stringFromDate:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSString *day = [@(components.weekday) stringValue];
    
    return day;
}

#pragma mark 本地化日期信息获取
- (NSString *)getSimplyMonthForLocalIdentifier:(NSString *)identifier
{
    NSLocale *local = [NSLocale currentLocale];
    if (identifier && ![identifier isEqualToString:@""]) {
        local = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = local;
    dateFormatter.dateFormat = @"MMM";
    NSString *month = [dateFormatter stringFromDate:self];
    return month;
}

- (NSString *)getFullMonthForLocalIdentifier:(NSString *)identifier
{
    NSLocale *local = [NSLocale currentLocale];
    if (identifier && ![identifier isEqualToString:@""]) {
        local = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = local;
    dateFormatter.dateFormat = @"MMMM";
    NSString *month = [dateFormatter stringFromDate:self];
    return month;
}

- (NSString *)getSimplyWeekDayForLocalIdentifier:(NSString *)identifier
{
    NSLocale *local = [NSLocale currentLocale];
    if (identifier && ![identifier isEqualToString:@""]) {
        local = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = local;
    dateFormatter.dateFormat = @"eee";
    NSString *weekDay = [dateFormatter stringFromDate:self];
    return weekDay;
}

- (NSString *)getFullWeekDayForLocalIdentifier:(NSString *)identifier
{
    NSLocale *local = [NSLocale currentLocale];
    if (identifier && ![identifier isEqualToString:@""]) {
        local = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = local;
    dateFormatter.dateFormat = @"eeee";
    NSString *weekDay = [dateFormatter stringFromDate:self];
    return weekDay;
}

#pragma mark - 日期时间运算
- (NSDate *)dateByCleaningDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    NSString *string = [dateFormatter stringFromDate:self];
    return [dateFormatter dateFromString:string];
}

- (NSComparisonResult)compare:(NSDate *)anotherDate withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    NSDate *selfDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:self]];
    NSDate *otherDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:anotherDate]];
    return [selfDate compare:otherDate];
}

#pragma mark 加减时间
- (NSDate *)dateByAddingSecond:(NSTimeInterval)second
{
    NSTimeInterval timeInterval = second * 1;
    return [self dateByAddingTimeInterval:timeInterval];
}

- (NSDate *)dateByAddingMinute:(NSTimeInterval)minute
{
    NSTimeInterval timeInterval = minute * 60;
    return [self dateByAddingTimeInterval:timeInterval];
}

- (NSDate *)dateByAddingHour:(NSTimeInterval)hour
{
    NSTimeInterval timeInterval = hour * 60 * 60;
    return [self dateByAddingTimeInterval:timeInterval];
}

- (NSDate *)dateByAddingDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeek:(NSInteger)week
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = week * 7;
    return [calender dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    components.month = components.month + month;
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateByAddingYear:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    components.year = components.year + year;
    return [calendar dateFromComponents:components];
}

#pragma mark 时间差
- (NSInteger)dayNumberSinceDate:(NSDate *)anotherDate
{
    NSDate *dateSelf = [self dateByCleaningDateFormat:XJDateFormat_yMd];
    NSDate *dateAnother = [anotherDate dateByCleaningDateFormat:XJDateFormat_yMd];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:dateAnother toDate:dateSelf options:0];
    return components.day;
}

- (NSInteger)weekNumberSinceDate:(NSDate *)anotherDate
{
    NSDate *dateSelf = [self dateByCleaningDateFormat:XJDateFormat_yMd];
    NSDate *dateAnother = [anotherDate dateByCleaningDateFormat:XJDateFormat_yMd];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfMonth fromDate:dateAnother toDate:dateSelf options:0];
    return components.weekOfMonth;
}

- (NSInteger)monthNumberSinceDate:(NSDate *)anotherDate
{
    NSDate *dateSelf = [self dateByCleaningDateFormat:@"yyyyMM"];
    NSDate *dateAnother = [anotherDate dateByCleaningDateFormat:@"yyyyMM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:dateAnother toDate:dateSelf options:0];
    return components.month;
}

- (NSInteger)yearNumberSinceDate:(NSDate *)anotherDate
{
    NSInteger yearSelf = [self getYear].integerValue;
    NSInteger yearAnother = [anotherDate getYear].integerValue;
    
    return yearSelf - yearAnother;
}

- (NSInteger)components:(NSCalendarUnit)unitFlags sinceDate:(NSDate *)anotherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:anotherDate toDate:self options:0];
    return [components valueForComponent:unitFlags];
}

#pragma mark 获取第一天及最后一天
- (NSDate *)firstDayOfYearByAddingYear:(NSInteger)year
{
    NSDate *startDate;              /// 单位内地开始时间
    NSTimeInterval intervalLength;  /// 单位内的时间长度 秒
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [self dateByAddingYear:year];
    
    BOOL flag = [calendar rangeOfUnit:NSCalendarUnitYear startDate:&startDate interval:&intervalLength forDate:date];
    
    if (!flag) {
        startDate = nil;
    }
    return startDate;
}

- (NSDate *)lastDayOfYearByAddingYear:(NSInteger)year
{
    NSDate *date = [self firstDayOfYearByAddingYear:(year + 1)];
    if (date) {
        date = [date dateByAddingDay:-1];
    }
    return date;
}

- (NSDate *)firstDayOfMonthByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    components.month = components.month + month;
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)lastDayOfMonthByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    components.month = components.month + month + 1;
    components.day = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)firstDayOfWeekByAddingWeek:(NSInteger)week
{
    NSDate *startDate;              /// 单位内地开始时间
    NSTimeInterval intervalLength;  /// 单位内的时间长度 秒
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [self dateByAddingWeek:week];
    
    BOOL flag = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&intervalLength forDate:date];
    
    if (!flag) {
        startDate = nil;
    }
    return startDate;
}

- (NSDate *)lastDayOfWeekByAddingWeek:(NSInteger)week
{
    NSDate *date = [self firstDayOfWeekByAddingWeek:(week + 1)];
    if (date) {
        date = [date dateByAddingDay:-1];
    }
    return date;
}

- (NSDate *)weekday:(XJWeekDay)weekday byAddingWeek:(NSInteger)week
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:self];
    components.day = components.day + week * 7;
    components.day = components.day - components.weekday + weekday;
    return [calendar dateFromComponents:components];
}

#pragma mark 数量计算
- (NSInteger)monthNumbersByAddingYear:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [self dateByAddingYear:year];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:date];
    return range.length;
}

- (NSInteger)weekNumbersByAddingYear:(NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [self dateByAddingYear:year];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:date];
    return range.length;
}

- (NSInteger)weekNumbersByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [self dateByAddingMonth:month];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

- (NSInteger)dayNumbersByAddingYear:(NSInteger)year
{
    NSInteger dayNumber = 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *yearDate = [self dateByAddingYear:year];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yearDate];
    for (int i = 1; i <= [yearDate monthNumbersByAddingYear:0]; i++) {
        components.month = i;
        NSDate *date = [calendar dateFromComponents:components];
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        dayNumber += range.length;
    }
    return dayNumber;
}

- (NSInteger)dayNumbersByAddingMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [self dateByAddingMonth:month];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

#pragma mark - 日期区域判断
- (BOOL)isThisDay
{
    NSDate *startDate;
    NSTimeInterval intervalLength;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL flag = [calendar rangeOfUnit:NSCalendarUnitDay startDate:&startDate interval:&intervalLength forDate:[NSDate date]];
    if (flag) {
        NSTimeInterval selfInSecs = [self timeIntervalSince1970];
        NSTimeInterval startDateInSecs = [startDate timeIntervalSince1970];
        if (selfInSecs < startDateInSecs || selfInSecs >= startDateInSecs + intervalLength) {
            flag = NO;
        }
    }
    return flag;
}

- (BOOL)isThisWeek
{
    NSDate *startDate;
    NSTimeInterval intervalLength;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL flag = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&intervalLength forDate:[NSDate date]];
    if (flag) {
        NSTimeInterval selfInSecs = [self timeIntervalSince1970];
        NSTimeInterval startDateInSecs = [startDate timeIntervalSince1970];
        if (selfInSecs < startDateInSecs || selfInSecs >= startDateInSecs + intervalLength) {
            flag = NO;
        }
    }
    return flag;
}

- (BOOL)isThisMonth
{
    NSDate *startDate;
    NSTimeInterval intervalLength;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL flag = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:&intervalLength forDate:[NSDate date]];
    if (flag) {
        NSTimeInterval selfInSecs = [self timeIntervalSince1970];
        NSTimeInterval startDateInSecs = [startDate timeIntervalSince1970];
        if (selfInSecs < startDateInSecs || selfInSecs >= startDateInSecs + intervalLength) {
            flag = NO;
        }
    }
    return flag;
}

- (BOOL)isThisYear
{
    NSDate *startDate;
    NSTimeInterval intervalLength;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL flag = [calendar rangeOfUnit:NSCalendarUnitYear startDate:&startDate interval:&intervalLength forDate:[NSDate date]];
    if (flag) {
        NSTimeInterval selfInSecs = [self timeIntervalSince1970];
        NSTimeInterval startDateInSecs = [startDate timeIntervalSince1970];
        if (selfInSecs < startDateInSecs || selfInSecs >= startDateInSecs + intervalLength) {
            flag = NO;
        }
    }
    return flag;
}

@end
