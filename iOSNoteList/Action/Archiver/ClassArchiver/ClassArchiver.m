//
//  ClassArchiver.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "ClassArchiver.h"
#import "NSString+DirectoryPath.h"

@implementation ClassArchiver

- (instancetype)init
{
    if (self = [super init]) {
        self.archiverBool = YES;
        self.archiverInteger = 10;
        self.archiverString = @"归档";
        self.archiverObject = [[ArchiverItem alloc] init];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.archiverBool forKey:@"archiverBool"];
    [aCoder encodeInteger:self.archiverInteger forKey:@"archiverInteger"];
    [aCoder encodeObject:self.archiverString forKey:@"archiverString"];
    [aCoder encodeObject:self.archiverObject forKey:@"archiverObject"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.archiverBool = [aDecoder decodeBoolForKey:@"archiverBool"];
        self.archiverInteger = [aDecoder decodeIntegerForKey:@"archiverInteger"];
        self.archiverString = [aDecoder decodeObjectForKey:@"archiverString"];
        self.archiverObject = [aDecoder decodeObjectForKey:@"archiverObject"];
    }
    return self;
}

+ (instancetype)defaultClassArchiver
{
    NSString *archiverPath = [NSStringFromClass([ClassArchiver class]) stringByAppendingPathOfDocuments];
    ClassArchiver *archiver = [NSKeyedUnarchiver unarchiveObjectWithFile:archiverPath];
    if (!archiver) {
        archiver = [[ClassArchiver alloc] init];
    }
    return archiver;
}

- (BOOL)archiverClassArchiver
{
    NSString *archiverPath = [NSStringFromClass([ClassArchiver class]) stringByAppendingPathOfDocuments];
    return [NSKeyedArchiver archiveRootObject:self toFile:archiverPath];
}

@end


@implementation ArchiverItem

- (instancetype)init
{
    if (self = [super init]) {
        self.archiverItem = @"archiverItem";
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.archiverItem forKey:@"archiverItem"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.archiverItem = [aDecoder decodeObjectForKey:@"archiverItem"];
    }
    return self;
}

@end
