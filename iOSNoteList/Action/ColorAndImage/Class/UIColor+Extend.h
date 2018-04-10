//
//  UIColor+Extend.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/26.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

/**
 *  十进制转颜色,[UIColor colorWithDecimalRed:12 green:12 blue:12 alpha:1]
 *
 *  @param red   r
 *  @param green g
 *  @param blue  b
 *  @param alpha a
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithDecimalRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

/**
 *  十六进制转颜色 [UIColor colorWithHexString:@"#CC00FF" alpha:1]
 *
 *  @param hexString 十六进制字符串
 *  @param alpha     a
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 *  十六进制颜色 [UIColor colorWithHex:0xCC00FF alpha:1]
 *
 *  @param hex   十六进制数字
 *  @param alpha a
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(long)hex alpha:(CGFloat)alpha;

/**
 *  获取UIColor的RGB [UIColor grayColor]及黑白不适用
 */
- (NSArray *)getRGB;

/**
 *  获取UIColor的RGBA [UIColor grayColor]及黑白不适用
 */
- (NSArray *)getRGBA;

@end
