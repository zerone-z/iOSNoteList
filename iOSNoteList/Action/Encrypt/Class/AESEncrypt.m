//
//  AESEncrypt.m
//  iOSNoteList
//
//  Created by LuPengDa on 16/9/5.
//  Copyright © 2016年 myzerone. All rights reserved.
//

#import "AESEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation AESEncrypt

+ (NSString *)decodeWithKey:(NSString *)key iv:(NSString *)iv text:(NSString *)text
{
    NSData *textData = [self convertHexStrToData:text];
    
    NSData *decodeData = [self AES256operation:kCCDecrypt key:key iv:iv ForData:textData];
    
    return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

+ (NSString *)encodeWithKey:(NSString *)key iv:(NSString *)iv text:(NSString *)text
{
    NSData *encodeData = [self AES256operation:kCCEncrypt key:key iv:iv ForData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    
    return [self convertDataToHexStr:encodeData];
}

+ (NSData *)AES256operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv ForData:(NSData *)data
{
    NSAssert(iv, @"IV must not be NULL");
    NSAssert(key, @"key must not be NULL");
    NSAssert(data, @"data must not be NULL");
    
    // 获取可供使用的秘钥
    char keyPtr[kCCKeySizeAES256 + 1];
    // bzero(keyPtr, sizeof(keyPtr));
    memset(keyPtr, 0, sizeof(keyPtr));
    NSInteger keyLength = MIN(key.length, (kCCKeySizeAES256));
    [[key substringToIndex:keyLength] getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // const char *keyPtr = [key dataUsingEncoding:NSUTF8StringEncoding].bytes;
    
    // IV 可选的初始矢量
    char ivPtr[kCCKeySizeAES256 + 1];
    //bzero(ivPtr, sizeof(ivPtr));
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    // 加解密后的数据存储
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;

    // AES 算法的密钥长度有 128、192、256 比特三种情况，因此加密时分组长度也有 128、192、256 比特，即 16、24、32 字节三种情况。
    // 加解密后的状态
    CCCryptorStatus cryptorStatus = CCCrypt(operation,  // 加密/解密
                                            kCCAlgorithmAES,    // 加解密标准
                                            kCCOptionPKCS7Padding,  // 选项分组密码算法
                                            keyPtr, // 秘钥 加解密需保持一致
                                            kCCKeySizeAES256,   // 秘钥长度
                                            ivPtr,  // 可选的初始矢量
                                            [data bytes],   // 需要加解密的数据存储单元
                                            [data length],  // 需要加解密的数据大小
                                            buffer, // 加解密后的数据
                                            bufferSize, //  加解密后的数据长度
                                            &numBytesEncrypted);

    if(cryptorStatus == kCCSuccess){
        NSData *bufferData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
        free(buffer);
        return bufferData;
    }
    
    free(buffer);
    return nil;
}

/// 将16进制字符串转为数据
+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

/// 将数据转为16进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    
    NSMutableString *str = [NSMutableString stringWithCapacity:64];
    NSUInteger length = [data length];
    char *bytes = malloc(sizeof(char) * length);
    
    [data getBytes:bytes length:length];
    
    for (int i = 0; i < length; i++)
    {
        [str appendFormat:@"%02.2hhX", bytes[i]];
    }
    free(bytes);
    
    return str;
}

@end
