//
//  ClassArchiver.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArchiverItem;

/// 归档
@interface ClassArchiver : NSObject <NSCoding>

+ (instancetype)defaultClassArchiver;

- (BOOL)archiverClassArchiver;

@property (nonatomic, assign) BOOL archiverBool;

@property (nonatomic, assign) NSInteger archiverInteger;

@property (nonatomic, strong) NSString *archiverString;

@property (nonatomic, strong) ArchiverItem *archiverObject;

@end

@interface ArchiverItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *archiverItem;

@end
