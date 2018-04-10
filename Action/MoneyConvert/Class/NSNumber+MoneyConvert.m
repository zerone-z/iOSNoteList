//
//  NSNumber+MoneyConvert.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "NSNumber+MoneyConvert.h"

@implementation NSNumber (MoneyConvert)

- (NSString *)convertChinessMoney
{
    NSArray *chinessMoney = [NSArray arrayWithObjects:@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖", nil];
    NSArray *integerUnits = [NSArray arrayWithObjects:@"圆",@"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"万", nil];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%.2lf",self.doubleValue];
    NSString *intStr = [moneyStr componentsSeparatedByString:@"."].firstObject;
    NSString *floatStr = [moneyStr componentsSeparatedByString:@"."].lastObject;
    
//    double intPart,decimalPart;
//    decimalPart = modf(self.doubleValue, &intPart);
//    NSString *intStr = [NSString stringWithFormat:@"%d",(int)intPart];
//    NSString *floatStr = [NSString stringWithFormat:@"%d",(int)decimalPart];
    
    if (intStr.length > 13) {
        return @"金额过大无法计算！";
    }
    
    NSMutableString *chinessMoneyStr = [NSMutableString string];
    // 数字转中文
    for (int i = 0; i < intStr.length; i++) {
        NSString *num = [intStr substringWithRange:NSMakeRange(i, 1)];
        [chinessMoneyStr appendFormat:@"%@%@", chinessMoney[num.intValue], integerUnits[intStr.length - i - 1]];
    }
    
    if ([chinessMoneyStr hasPrefix:@"壹拾"]) {
        [chinessMoneyStr replaceCharactersInRange:NSMakeRange(0, 2) withString:@"拾"];
    }
    
    // 去除重复的零,但不去除“零万”、“零亿”
    for (int i = 0; i < (NSInteger)chinessMoneyStr.length - 3; i++) {
        NSString *curChar = [chinessMoneyStr substringWithRange:NSMakeRange(i, 2)];
        NSString *nextChar = [chinessMoneyStr substringWithRange:NSMakeRange(i + 2, 2)];
        
        if ([curChar hasPrefix:@"零"] && [nextChar hasPrefix:@"零"] && ![@[@"万", @"亿"] containsObject:[curChar substringFromIndex:1]]) {
            [chinessMoneyStr deleteCharactersInRange:NSMakeRange(i, 2)];
            --i;
        }
    }
    // 去除“零万”，“零亿”，“零圆”的零以及其他后面的，@“亿万”的万
    for (int i = 0; i < (NSInteger)chinessMoneyStr.length - 1; i++) {
        NSString *curChar = [chinessMoneyStr substringWithRange:NSMakeRange(i, 1)];
        NSString *nextChar = [chinessMoneyStr substringWithRange:NSMakeRange(i + 1, 1)];
        
        if ([curChar isEqualToString:@"零"] && [@[@"万", @"亿", @"圆"] containsObject:nextChar]) {
            [chinessMoneyStr deleteCharactersInRange:NSMakeRange(i, 1)];
            i -= 2;
            continue;
        }
        
        if ([curChar isEqualToString:@"零"] && [integerUnits containsObject:nextChar]) {
            [chinessMoneyStr deleteCharactersInRange:NSMakeRange(i + 1, 1)];
            i -= 2;
            continue;
        }
        
        if ([curChar isEqualToString:@"亿"] && [nextChar isEqualToString:@"万"]) {
            [chinessMoneyStr deleteCharactersInRange:NSMakeRange(i + 1, 1)];
            --i;
            continue;
        }
    }
    
    // 角分
    if ([floatStr substringWithRange:NSMakeRange(0, 1)].intValue != 0) {
        NSString *jiao = [floatStr substringWithRange:NSMakeRange(0, 1)];
        [chinessMoneyStr appendFormat:@"%@角", chinessMoney[jiao.intValue]];
    }
    if ([floatStr substringWithRange:NSMakeRange(1, 1)].intValue != 0) {
        NSString *fen = [floatStr substringWithRange:NSMakeRange(1, 1)];
        [chinessMoneyStr appendFormat:@"%@分", chinessMoney[fen.intValue]];
    }
    
    if ([floatStr substringWithRange:NSMakeRange(0, 1)].intValue == 0 &&
        [floatStr substringWithRange:NSMakeRange(1, 1)].intValue == 0) {
        [chinessMoneyStr appendString:@"整"];
    }
    
    return chinessMoneyStr;
}

@end
