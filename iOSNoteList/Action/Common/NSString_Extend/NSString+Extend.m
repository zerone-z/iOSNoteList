//
//  NSString+Extend.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/11.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "NSString+Extend.h"
#import "NSString+SystemInfo.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extend)

#pragma mark - MD5

- (NSString *)md5
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    const char *input = [data bytes];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)data.length, md5Buffer);
    
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5 appendFormat:@"%02X", md5Buffer[i]];
    }
    
    return [md5 lowercaseString];
    
    // 下面的方法正常情况下没有问题
    // 如果在字符串中有特殊字符（如：转译字符\0)，会有问题
    // 详见：http://qiufeng.me/md5/
//    const char *input = [(NSString *)self UTF8String];
//    
//    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(input, (CC_LONG)strlen(input), md5Buffer);
//    
//    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    
//    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
//        [md5 appendFormat:@"%02x", md5Buffer[i]];
//    }
//    
//    return md5;
}

#pragma mark - size
- (CGSize)sizeWithMyFont:(UIFont *)font
{
    NSDictionary *textAttributes = @{NSFontAttributeName : font};
    CGSize size=[self sizeWithAttributes:textAttributes];
    return size;
}

- (CGSize)sizeWithMyFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSDictionary *textAttributes = @{NSFontAttributeName : font};
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:textAttributes
                                     context:nil];
    return rect.size;
}

#pragma mark - Compare
- (BOOL)isEmpty
{
    if (self && ![self isEqual:[NSNull null]] && ![self isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (NSComparisonResult)compareWithVersion:(NSString *)version
{
    return [self compare:version options:NSNumericSearch];
}

+ (NSComparisonResult)compareWithSystemVersion:(NSString *)systemVersion
{
    return [[NSString systemVersion] compareWithVersion:systemVersion];
}

@end
