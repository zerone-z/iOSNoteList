//
//  NSNumber+Extend.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/26.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

NSString *const XJNumberFormatCurrency1 = @"#,##0.00";          ///< 格式化类型 货币 #,##0.00

#import "NSNumber+Extend.h"

@implementation NSNumber (Extend)

- (NSString *)stringWithNumberFormat:(NSString *)numberFormat
{
    NSNumber *number = self;
    // 无穷大，非数值
    if (number.doubleValue == INFINITY || isnan(number.doubleValue)) {
        number = @0;
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.positiveFormat = numberFormat;
    return [numberFormatter stringFromNumber:number];
}

+ (NSNumber *)numberFromString:(NSString *)string withNumberFormat:(NSString *)numberFormat
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.positiveFormat = numberFormat;
    return [numberFormatter numberFromString:string];
}

- (NSString *)stringOfDecimal
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [numberFormatter stringFromNumber:self];
}

- (NSString *)stringOfCurrency
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return [numberFormatter stringFromNumber:self];
}

- (NSString *)stringOfPercent
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    return [numberFormatter stringFromNumber:self];
}

- (NSString *)stringOfScience
{
    return [NSNumberFormatter localizedStringFromNumber:self numberStyle:NSNumberFormatterScientificStyle];
}

- (NSString *)stringOfSpellOut
{
    return [NSNumberFormatter localizedStringFromNumber:self numberStyle:NSNumberFormatterSpellOutStyle];
}

@end
