//
//  UIColor+Extend.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/26.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

+ (UIColor *)colorWithDecimalRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    //去掉字符串首位的空格，并且返回新的字符串
    NSString *hex = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([hex length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([hex hasPrefix:@"0X"])
        hex = [hex substringFromIndex:2];
    if ([hex hasPrefix:@"#"])
        hex = [hex substringFromIndex:1];
    if ([hex length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *redString = [hex substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *greenString = [hex substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *blueString = [hex substringWithRange:range];
    
    // Scan values  将16进制数转换为10进制  分别存到r,g,b中
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
    
    return [UIColor colorWithDecimalRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHex:(long)hex alpha:(CGFloat)alpha
{
    float red = (float)((hex & 0xFF0000) >> 16);
    float green = (float)((hex & 0xFF00) >> 8);
    float blue = (float)(hex & 0xFF);
    return [UIColor colorWithDecimalRed:red green:green blue:blue alpha:alpha];
}

- (NSArray *)getRGB
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",self];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr;
}

- (NSArray *)getRGBA
{
    size_t  n = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    
    NSMutableArray *rgbaList = [NSMutableArray arrayWithCapacity:n];
    for (int i=0; i<n; i++)
    {
        [rgbaList addObject:[NSNumber numberWithFloat:rgba[i]]];
    }
    return rgbaList;
}

@end
