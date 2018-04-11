//
//  DESEncrypt.m
//  iOSNoteList
//
//  Created by LuPengDa on 15-1-3.
//  Copyright (c) 2015年 mobisoft. All rights reserved.
//

#import "DESEncrypt.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation DESEncrypt

#pragma mark 根据制定密钥加密文本
+ (NSString *)encrypt:(NSString *)text key:(NSString *)key
{
    // 加密数据 base64解码
    NSData* encryptData = [text dataUsingEncoding:NSUTF8StringEncoding];
    const void *dataIn = (const void *)[encryptData bytes];
    size_t dataInLength = [encryptData length];
    
    // 加解密后的数据存储
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    size_t dataOutMoved = 0;
    
    // 获取可供使用的秘钥
    char vkey[kCCKeySizeDES + 1];
    // bzero(keyPtr, sizeof(keyPtr));
    memset(vkey, 0, sizeof(vkey));
    NSInteger keyLength = MIN(key.length, (kCCKeySizeDES));
    [[key substringToIndex:keyLength] getCString:vkey maxLength:sizeof(vkey) encoding:NSUTF8StringEncoding];
    // const void *vkey = (const void *) [key UTF8String];
    
    // CCCrypt函数 加密
    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt,//  加密
            kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
            kCCOptionPKCS7Padding|kCCOptionECBMode,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
            vkey,  //密钥
            kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
            NULL, //  可选的初始矢量
            dataIn, // 加解密数据的存储单元
            dataInLength,// 加解密数据的大小
            (void *)dataOut,// 加解密后的数据
            dataOutAvailable,
            &dataOutMoved);
    
    if(cryptorStatus == kCCSuccess){
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        free(dataOut);
        //编码 base64
        NSString *result = [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
        return result;
    }
    
    return nil;
}

+ (NSString *)decrypt:(NSString *)text key:(NSString *)key
{
    // 解密数据
    NSData* encryptData = [[NSData alloc] initWithBase64EncodedString:text options:0];
    const void *dataIn = (const void *)[encryptData bytes];
    size_t dataInLength = [encryptData length];
    
    // 加解密后的数据存储
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    size_t dataOutMoved = 0;
    
    // 获取可供使用的秘钥
    char vkey[kCCKeySizeDES + 1];
    // bzero(keyPtr, sizeof(keyPtr));
    memset(vkey, 0, sizeof(vkey));
    NSInteger keyLength = MIN(key.length, (kCCKeySizeDES));
    [[key substringToIndex:keyLength] getCString:vkey maxLength:sizeof(vkey) encoding:NSUTF8StringEncoding];
    // const void *vkey = (const void *) [key UTF8String];
    
    //CCCrypt函数 加密
    CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt,//  解密
                                            kCCAlgorithmDES,//  解密根据哪个标准（des，3des，aes。。。。）
                                            kCCOptionPKCS7Padding|kCCOptionECBMode,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                                            vkey,  //密钥
                                            kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                                            NULL, //  可选的初始矢量
                                            dataIn, // 加解密数据的存储单元
                                            dataInLength,// 加解密数据的大小
                                            (void *)dataOut,// 加解密后的数据
                                            dataOutAvailable,
                                            &dataOutMoved);
    
    if(cryptorStatus == kCCSuccess){
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        free(dataOut);
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return result;
    }
    
    return nil;
}

@end
