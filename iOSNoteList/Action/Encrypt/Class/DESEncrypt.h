//
//  DESEncrypt.h
//  iOSNoteList
//
//  Created by LuPengDa on 15-1-3.
//  Copyright (c) 2015年 mobisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/// DES加解密
@interface DESEncrypt : NSObject

/**
 *  根据指定密钥加密文本
 *
 *  @param text 要加密的文本
 *  @param key  密钥
 *
 *  @return 加密后的文本
 */
+ (NSString *)encrypt:(NSString *)text key:(NSString *)key;


/**
 根据指定密钥解密文本

 @param text 要解密的文本
 @param key 秘钥
 @return 解密后的文本
 */
+ (NSString *)decrypt:(NSString *)text key:(NSString *)key;

@end
