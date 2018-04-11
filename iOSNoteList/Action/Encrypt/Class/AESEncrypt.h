//
//  AESEncrypt.h
//  iOSNoteList
//
//  Created by LuPengDa on 16/9/5.
//  Copyright © 2016年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

/// AES加解密
@interface AESEncrypt : NSObject

+ (NSString *)decodeWithKey:(NSString *)key iv:(NSString *)iv text:(NSString *)text;
+ (NSString *)encodeWithKey:(NSString *)key iv:(NSString *)iv text:(NSString *)text;

@end
