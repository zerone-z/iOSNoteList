//
//  ClassCopyAndStatic.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

typedef struct XJOffset {
    CGFloat horizontal, vertical;
} XJOffset;

struct XJPoint {
    CGFloat x;
    CGFloat y;
};
typedef struct XJPoint XJPoint;

static NSString *const staticString = @"staticString"; ///< 静态常量

extern NSString *const externSring;

#import <Foundation/Foundation.h>

@interface ClassCopyAndStatic : NSObject <NSCopying>

@property (nonatomic, strong) NSString *property1;

@property (nonatomic, strong) NSString *property2;

@property (nonatomic, assign) BOOL property3;

@property (nonatomic, assign) NSInteger property4;

@end
