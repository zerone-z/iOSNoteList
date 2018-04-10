//
//  NSString+DirectoryPath.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 项目路径获取
@interface NSString (DirectoryPath)

#pragma mark - 获取目录路径

/// 程序app所在的Home路径
+ (NSString *)pathOfHome;

/// 程序资源文件路径
+ (NSString *)pathOfResource;

/**
 *  获取指定的资源文件路径
 *
 *  @param name 资源名称
 *  @param type 类型
 *
 *  @return 
 */
+ (NSString *)pathOfResource:(NSString *)name ofType:(NSString *)type;

/// 程序Document路径
+ (NSString *)pathOfDocuments;

/// 程序Library路径
+ (NSString *)pathOfLibrary;

/// 程序Cache路径
+ (NSString *)pathOfCaches;

/// 程序Temp路径
+ (NSString *)pathOfTemp;

#pragma mark - 添加到目录路径

/**
 *  添加到项目沙盒中Documents所在路径
 *
 *  @return Documents路径
 */
- (NSString *)stringByAppendingPathOfDocuments;

+ (NSString *)pathOfDocumentsWithString:(NSString *)string;
+ (NSString *)pathOfDocumentsWithFormat:(NSString *)format,...;

/**
 *  添加到项目沙盒中Library所在路径
 *
 *  @return Library路径
 */
- (NSString *)stringByAppendingPathOfLibrary;

+ (NSString *)pathOfLibraryWithString:(NSString *)string;
+ (NSString *)pathOfLibraryWithFormat:(NSString *)format,...;

/**
 *  添加到项目沙盒中Caches所在路径
 *
 *  @return Caches路径
 */
- (NSString *)stringByAppendingPathOfCaches;

+ (NSString *)pathOfCachesWithString:(NSString *)string;
+ (NSString *)pathOfCachesWithFormat:(NSString *)format,...;

/**
 *  添加到项目沙盒中Temp所在路径
 *
 *  @return Temp路径
 */
- (NSString *)stringByAppendingPathOfTemp;

+ (NSString *)pathOfTempWithString:(NSString *)string;
+ (NSString *)pathOfTempWithFormat:(NSString *)format,...;

@end
