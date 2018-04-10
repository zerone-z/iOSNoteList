//
//  NSNumber+Extend.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/26.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

/**
 详细官方说明：http://unicode.org/reports/tr35/tr35-10.html#Number_Format_Patterns
 **/

extern NSString *const XJNumberFormatCurrency1;     ///< 格式化类型 货币 #,##0.00

#import <Foundation/Foundation.h>

@interface NSNumber (Extend)

#pragma mark - NumberFormat
/**
 *  把数字格式化为一个指定格式的字符串
 *
 *  @param numberFormat 格式化样式
 *
 *  @return 格式化后的字符串
 */
- (NSString *)stringWithNumberFormat:(NSString *)numberFormat;

/**
 *  把一个字符串转为NSNumber对象
 *
 *  @param string       时间字符串
 *  @param numberFormat 格式化样式
 *
 *  @return 日期
 */
+ (NSNumber *)numberFromString:(NSString *)string withNumberFormat:(NSString *)numberFormat;

/// 返回数字样式 123,456.12
- (NSString *)stringOfDecimal;

/// 返回货币样式 ¥123,456.12
- (NSString *)stringOfCurrency;

/// 返回百分比样式 12345612%
- (NSString *)stringOfPercent;

/// 返回科学计数（指数） 1.23456E5
- (NSString *)stringOfScience;

/// 返回朗读样式 十二万三千四百五十六点一二三
- (NSString *)stringOfSpellOut;

@end
