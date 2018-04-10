//
//  NSDate+Extend.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/20.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

/**
 详细官方说明：http://unicode.org/reports/tr35/tr35-10.html#Date_Format_Patterns
 紀元的顯示：
 G：顯示AD，也就是公元
 G～GGG：BC/AD
 GGGG：纪元完整名称，Anno Domini
 g：未知
 
 年的顯示：
 yy：年的後面2位數字
 yyyy/yyy/y：顯示完整的年
 YYYY/Y：未知
 YY/YYY：未知
 u：未知
 
 季度的表示
 Q/q：显示1~4，一位数字，第几季度
 QQ/qq：显示01~04，两位数字 第几季度
 QQQ/qqq: Q1(1季度)/Q2(2季度)/Q3(3季度)/Q4(4季度) 季度简写
 QQQQ/qqqq: 1st quarter(第一季度)/2nd quarter(第二季度)/3rd quarter(第三季度)/4th quarter(第四季度) 季度全拼
 
 月的顯示：
 M/L：顯示成1~12，1位數或2位數
 MM/LL：顯示成01~12，不足2位數會補0
 MMM/LLL：英文月份的縮寫，例如：Jan（1月）
 MMMM/LLLL：英文月份完整顯示，例如：January（一月）
 
 日的顯示：
 d：顯示成1~31，1位數或2位數
 dd：顯示成01~31，不足2位數會補0
 D：顯示成1~366
 
 星期的顯示：
 e/c：1~7 一周的第几天，周末为1
 ee/cc：01~07 一周的第几天，周末为01
 EEE/ccc：星期的英文縮寫，如Sun/Mon/Tue/Wed/Thu/Fri/Sat  周一
 EEEE/cccc：星期的英文完整顯示，如Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday  星期一
 F/W：1~6 (每月的第几周, 一周的开始为周一)
 w：1~53，一年的第几周, 一周的开始为周日,第一周从去年的最后一个周日起算
 
 上/下午的顯示：
 a：AM/PM (上午/下午)
 aa：顯示AM或PM
 A：0~86399999 (一天的第A微秒)
 
 小時的顯示：
 h：顯示成1~12，1位數或2位數(12小時制)
 hh：顯示成01~12，不足2位數會補0(12小時制)
 H：顯示成0~23，1位數或2位數(24小時制)
 HH：顯示成00~23，不足2位數會補0(24小時制)
 
 K：顯示成0~11，1位數或2位數(12小時制)
 KK：顯示成0~11，不足2位數會補0(12小時制)
 k：顯示成1~24，1位數或2位數(24小時制)
 kk：顯示成01~24，不足2位數會補0(24小時制)
 
 分的顯示：
 m：顯示0~59，1位數或2位數
 mm：顯示00~59，不足2位數會補0
 
 秒的顯示：
 s：顯示0~59，1位數或2位數
 ss：顯示00~59，不足2位數會補0
 S：毫秒的顯示（SSS）
 
 時區的顯示：
 z / zz /zzz ：PDT
 zzzz：Pacific Daylight Time
 Z / ZZ / ZZZ ：-0800
 ZZZZ：GMT -08:00
 v~vvv：PT，常规时区的编写
 vvvv：常规时区名称
 
 'T'：日期与时间的分割符
 **/

#import <Foundation/Foundation.h>

extern NSString *const XJDateFormat_y_M_d;          ///< 格式化类型 yyyy-MM-dd
extern NSString *const XJDateFormat_H_m_s;          ///< 格式化类型 HH:mm:ss
extern NSString *const XJDateFormat_h_m_s;          ///< 格式化类型 hh:mm:ss
extern NSString *const XJDateFormat_y_M_d_H_m_s;    ///< 格式化类型 yyyy-MM-dd HH:mm:ss
extern NSString *const XJDateFormat_y_M_d_h_m_s;    ///< 格式化类型 yyyy-MM-dd hh:mm:ss
extern NSString *const XJDateFormat_yMd;            ///< 格式化类型 yyyyMMdd
extern NSString *const XJDateFormat_zh_y_M_d;       ///< 格式化类型 yyyy年MM月dd日
extern NSString *const XJDateFormat_zh_y_M_d_H_m_s; ///< 格式化类型 yyyy年MM月dd日 HH:mm:ss
extern NSString *const XJDateFormat_zh_y_M_d_h_m_s; ///< 格式化类型 yyyy年MM月dd日 hh:mm:ss

typedef NS_ENUM(NSInteger, XJWeekDay) {
    XJWeekDaySun = 1,        ///< 星期天
    XJWeekDayMon,            ///< 星期一
    XJWeekDayTues,           ///< 星期二
    XJWeekDayWed,            ///< 星期三
    XJWeekDayThurs,          ///< 星期四
    XJWeekDayFri,            ///< 星期五
    XJWeekDaySat,            ///< 星期六
};

@interface NSDate (Extend)

#pragma mark - DateFormat
/**
 *  把时间格式化为一个指定格式的字符串
 *
 *  @param dateFormat 格式化样式
 *
 *  @return 格式化后的字符串
 */
- (NSString *)stringWithDateFormat:(NSString *)dateFormat;

/**
 *  把日期字符串转为NSDate对象
 *
 *  @param string     时间字符串
 *  @param dateFormat 格式化样式
 *
 *  @return 日期
 */
+ (NSDate *)dateFromString:(NSString *)string withDateFormat:(NSString *)dateFormat;

#pragma mark - 日期时间自身信息获取
/**
 *  获取当前日期所在的年
 *
 *  @return
 */
- (NSString *)getYear;

/**
 *  获取当前日期所在的季度
 *
 *  @return 1～4
 */
- (NSString *)getQuarter;

/**
 *  获取当前日期所在的月份
 *
 *  @return 1～12
 */
- (NSString *)getMonth;

/**
 *  获取当前日期在年份中的第几周
 *
 *  @return 1～53
 */
- (NSString *)getWeekOfYear;

/**
 *  获取当前日期在月份中的第几周
 *
 *  @return 1～5
 */
- (NSString *)getWeekOfMonth;

/**
 *  获取当前日期在年份中的第几天
 *
 *  @return 1～366
 */
- (NSString *)getDayOfYear;

/**
 *  获取当前日期在月份中的第几天
 *
 *  @return 1~31
 */
- (NSString *)getDayOfMonth;

/**
 *  获取当前日期在这周中的第几天
 *
 *  @return 1～7，周末为1
 */
- (NSString *)getDayOfWeek;

#pragma mark 本地化日期信息获取
/**
 *  指定语言获取简写月份，
 *
 *  @param identifier 语言，中文：zh 英文：en_US     nil／“” 是默认采用当前语言
 *
 *  @return 月份  Jan（1月）
 */
- (NSString *)getSimplyMonthForLocalIdentifier:(NSString *)identifier;

/**
 *  指定语言获取全写月份，
 *
 *  @param identifier 语言，中文：zh 英文：en_US；   nil／“” 是默认采用当前语言
 *
 *  @return 月份 January（一月）
 */
- (NSString *)getFullMonthForLocalIdentifier:(NSString *)identifier;

/**
 *  指定语言获取简写星期
 *
 *  @param identifier 语言，中文：zh 英文：en_US     nil／“” 是默认采用当 前语言
 *
 *  @return 星期 Mon（周一）
 */
- (NSString *)getSimplyWeekDayForLocalIdentifier:(NSString *)identifier;

/**
 *  指定语言获取全写星期
 *
 *  @param identifier 语言，中文：zh 英文：en_US     nil／“” 是默认采用当前语言
 *
 *  @return 星期 Monday（星期一）
 */
- (NSString *)getFullWeekDayForLocalIdentifier:(NSString *)identifier;

#pragma mark - 日期时间运算
/**
 *  清楚格式化样式以外的时间
 *
 *  @param dateFormat 格式化样式
 *
 *  @return 时间
 */
- (NSDate *)dateByCleaningDateFormat:(NSString *)dateFormat;

/**
 *  格式化样式内的时间比较
 *
 *  @param anotherDate  比较时间
 *  @param dateFormat   格式化样式
 *
 *  @return 比较结果
 */
- (NSComparisonResult)compare:(NSDate *)anotherDate withDateFormat:(NSString *)dateFormat;

#pragma mark 加减时间
/**
 *  返回时间加上second秒后的时间。second>0,是fabs(second)秒后的时间, second<0, 是fabs(second)秒前的时间
 *
 *  @param second 秒
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingSecond:(NSTimeInterval)second;

/**
 *  返回时间加上minute分钟后的时间。minute>0,是fabs(minute)分钟后的时间, minute<0, 是fabs(minute)分钟前的时间
 *
 *  @param minute 分钟
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingMinute:(NSTimeInterval)minute;

/**
 *  返回时间加上hour小时后的时间。hour>0,是fabs(hour)小时后的时间, hour<0, 是fabs(hour)小时前的时间
 *
 *  @param hour 小时
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingHour:(NSTimeInterval)hour;

/**
 *  返回时间加上day天后的时间。day>0,是fabs(day)天后的时间, day<0, 是fabs(day)天前的时间
 *
 *  @param day 天
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingDay:(NSInteger)day;

/**
 *  返回时间加上week周后的时间。week>0,是fabs(week)周后的时间, week<0, 是fabs(week)周前的时间
 *
 *  @param week 周
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingWeek:(NSInteger)week;

/**
 *  返回时间加上month月后的时间。month>0,是fabs(month)月后的时间, month<0, 是fabs(month)月前的时间
 *
 *  @param month 月
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingMonth:(NSInteger)month;

/**
 *  返回时间加上year年后的时间。year>0,是fabs(year)年后的时间, year<0, 是fabs(year)年前的时间
 *
 *  @param year 年
 *
 *  @return NSDate
 */
- (NSDate *)dateByAddingYear:(NSInteger)year;

#pragma mark 时间差
/**
 *  计算时间相差天数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 天数
 */
- (NSInteger)dayNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算时间相差周数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 周数
 */
- (NSInteger)weekNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算时间相差月数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 月数
 */
- (NSInteger)monthNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算时间相差年数
 *
 *  @param anotherDate 比较的时间
 *
 *  @return 年数
 */
- (NSInteger)yearNumberSinceDate:(NSDate *)anotherDate;

/**
 *  计算指定单位内的时间相差值
 *
 *  @param unitFlags   时间相差单位
 *  @param anotherDate 比较的单位
 *
 *  @return 单位内时间相差值
 */
- (NSInteger)components:(NSCalendarUnit)unitFlags sinceDate:(NSDate *)anotherDate;

#pragma mark 获取第一天及最后一天
/**
 *  返回year年后，年的第一天。
 *
 *  @param year 年
 *
 *  @return NSDate
 */
- (NSDate *)firstDayOfYearByAddingYear:(NSInteger)year;

/**
 *  返回year年后，年的最后一天。
 *
 *  @param year 年
 *
 *  @return NSDate
 */
- (NSDate *)lastDayOfYearByAddingYear:(NSInteger)year;

/**
 *  返回month月后，月的第一天。
 *
 *  @param month 月
 *
 *  @return NSDate
 */
- (NSDate *)firstDayOfMonthByAddingMonth:(NSInteger)month;

/**
 *  返回month月后，月的最后一天。
 *
 *  @param month 月
 *
 *  @return NSDate
 */
- (NSDate *)lastDayOfMonthByAddingMonth:(NSInteger)month;

/**
 *  返回week周后，周的第一天。
 *
 *  @param week 周
 *
 *  @return NSDate
 */
- (NSDate *)firstDayOfWeekByAddingWeek:(NSInteger)week;

/**
 *  返回week周后，周的最后一天。
 *
 *  @param week 周
 *
 *  @return NSDate
 */
- (NSDate *)lastDayOfWeekByAddingWeek:(NSInteger)week;

/**
 *  返回week周后的星期几的时间。
 *
 *  @param weekday 星期几
 *  @param week    周
 *
 *  @return NSDate
 */
- (NSDate *)weekday:(XJWeekDay)weekday byAddingWeek:(NSInteger)week;

#pragma mark 数量计算
/**
 *  计算year年后的月数
 *
 *  @return 月数
 */
- (NSInteger)monthNumbersByAddingYear:(NSInteger)year;

/**
 *  计算year年后的周数
 *
 *  @return 周数
 */
- (NSInteger)weekNumbersByAddingYear:(NSInteger)year;

/**
 *  计算month月份后的周数
 *
 *  @return 周数
 */
- (NSInteger)weekNumbersByAddingMonth:(NSInteger)month;

/**
 *  计算year年后的天数
 *
 *  @return 天数
 */
- (NSInteger)dayNumbersByAddingYear:(NSInteger)year;

/**
 *  计算month月份后的天数
 *
 *  @return 天数
 */
- (NSInteger)dayNumbersByAddingMonth:(NSInteger)month;

#pragma mark - 日期区域判断

/**
 *  是否在当天
 */
- (BOOL)isThisDay;

/**
 *  是否在本周内
 */
- (BOOL)isThisWeek;

/**
 *  是否在本月
 */
- (BOOL)isThisMonth;

/**
 *  是否在本年
 */
- (BOOL)isThisYear;

@end
