//
//  NSString+Extend.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/11.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

#pragma mark - MD5

/**
 *  MD5加密
 */
- (NSString *)md5;

#pragma mark - size

/**
 *  计算单行的字符串所占大小
 *
 *  @param font 字体
 *
 *  @return CGSize
 */
- (CGSize)sizeWithMyFont:(UIFont *)font;

/**
 *  计算多行的字体所占大小
 *
 *  @param font 字体
 *  @param size 限制大小
 *
 *  @return CGSize
 */
- (CGSize)sizeWithMyFont:(UIFont *)font constrainedToSize:(CGSize)size;

#pragma mark - Compare

/**
 *  判断字符串是否为空（null & @""）
 *
 *  @return 为空返回YES
 */
- (BOOL)isEmpty;

/**
 *  与一个版本号进行比较
 *
 *  @param version 版本号：@"1.2.3"
 *
 *  @return NSOrderedAscending:小于version；NSOrderedSame：等于version；NSOrderedDescending：大于version
 */
- (NSComparisonResult)compareWithVersion:(NSString *)version;

/**
 *  当前系统与与指定系统比较
 *
 *  @param systemVersion 指定系统版本号
 *
 *  @return NSOrderedAscending:小于systemVersion；NSOrderedSame：等于systemVersion；NSOrderedDescending：大于systemVersion
 */
+ (NSComparisonResult)compareWithSystemVersion:(NSString *)systemVersion;

@end
