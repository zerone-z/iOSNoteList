//
//  NSString+SystemInfo.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/10.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 获取系统相关信息
@interface NSString (SystemInfo)

/// 设备型号,终端类型
+ (NSString *)terminalType;

/// 是否越狱
+ (BOOL)isJailBreak;

#pragma mark 操作系统
/// 操作系统名称
+ (NSString *)systemName;

/// 操作系统版本
+ (NSString *)systemVersion;

/// 设备名称
+ (NSString *)deviceName;

/// 设备模型
+ (NSString *)deviceModel;

/// 设备本地模型
+ (NSString *)deviceLocalizedModel;

/// 当前用户的登陆名
+ (NSString *)currentUserName;

/// 当前用户的完整登陆名
+ (NSString *)currentFullUserName;

#pragma mark 程序App信息
/// 程序名称
+ (NSString *)appName;

/// 本地化程序名称
+ (NSString *)appLocalizedName;

/// 程序用于显示的名称
+ (NSString *)appDisplayName;

/// 本地化程序显示名称
+ (NSString *)appLocalizedDisplayName;

/// 程序软件版本号
+ (NSString *)appVersion;

/// 程序编译的版本号
+ (NSString *)appBuildVersion;

/// 程序bundle id 前缀，如：D75W8X4F7B
+ (NSString *)appIdentifierPrefix;

@end
