//
//  NSString+DirectoryPath.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "NSString+DirectoryPath.h"

@implementation NSString (DirectoryPath)

#pragma mark - 获取目录路径
+ (NSString *)pathOfHome
{
    NSString *directoryPath = NSHomeDirectory();
    return directoryPath;
}

+ (NSString *)pathOfResource
{
    NSString *directoryPath = [[NSBundle mainBundle] resourcePath];
//    NSString *directoryPath = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"txt"];
    return directoryPath;
}

+ (NSString *)pathOfResource:(NSString *)name ofType:(NSString *)type
{
    NSString *directoryPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return directoryPath;
}

+ (NSString *)pathOfDocuments
{
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return directoryPath;
}

+ (NSString *)pathOfLibrary
{
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    return directoryPath;
}

+ (NSString *)pathOfCaches
{
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    return directoryPath;
}

+ (NSString *)pathOfTemp
{
    NSString *directoryPath = NSTemporaryDirectory();
    return directoryPath;
}

#pragma mark - 添加到目录路径
- (NSString *)stringByAppendingPathOfDocuments
{
    NSString *path = [[NSString pathOfDocuments] stringByAppendingPathComponent:self];
    return path;
}

+ (NSString *)pathOfDocumentsWithString:(NSString *)string
{
    NSString *path = [string stringByAppendingPathOfDocuments];
    return path;
}

+ (NSString *)pathOfDocumentsWithFormat:(NSString *)format,...
{
    va_list args;
    va_start(args, format);
    NSString *path = [[NSString alloc] initWithFormat:[format stringByAppendingPathOfDocuments] arguments:args];
    va_end(args);
    return path;
}

- (NSString *)stringByAppendingPathOfLibrary
{
    NSString *path = [[NSString pathOfLibrary] stringByAppendingPathComponent:self];
    return path;
}

+ (NSString *)pathOfLibraryWithString:(NSString *)string
{
    NSString *path = [string stringByAppendingPathOfLibrary];
    return path;
}

+ (NSString *)pathOfLibraryWithFormat:(NSString *)format,...
{
    va_list args;
    va_start(args, format);
    NSString *path = [[NSString alloc] initWithFormat:[format stringByAppendingPathOfLibrary] arguments:args];
    va_end(args);
    return path;
}

- (NSString *)stringByAppendingPathOfCaches
{
    NSString *path = [[NSString pathOfCaches] stringByAppendingPathComponent:self];
    return path;
}

+ (NSString *)pathOfCachesWithString:(NSString *)string
{
    NSString *path = [string stringByAppendingPathOfCaches];
    return path;
}

+ (NSString *)pathOfCachesWithFormat:(NSString *)format,...
{
    va_list args;
    va_start(args, format);
    NSString *path = [[NSString alloc] initWithFormat:[format stringByAppendingPathOfCaches] arguments:args];
    va_end(args);
    return path;
}

- (NSString *)stringByAppendingPathOfTemp
{
    NSString *path = [[NSString pathOfTemp] stringByAppendingPathComponent:self];
    return path;
}

+ (NSString *)pathOfTempWithString:(NSString *)string
{
    NSString *path = [string stringByAppendingPathOfTemp];
    return path;
}

+ (NSString *)pathOfTempWithFormat:(NSString *)format,...
{
    va_list args;
    va_start(args, format);
    NSString *path = [[NSString alloc] initWithFormat:[format stringByAppendingPathOfTemp] arguments:args];
    va_end(args);
    return path;
}


@end
