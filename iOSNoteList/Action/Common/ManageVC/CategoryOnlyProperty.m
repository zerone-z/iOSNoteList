//
//  CategoryOnlyProperty.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/7/22.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "CategoryOnlyProperty.h"

@interface CategoryOnlyProperty ()

@property (strong, readwrite, nonatomic) NSString *readOnlyProperty;

@end

@implementation CategoryOnlyProperty

@synthesize readOnlyProperty = readOnlyProperty_;

- (instancetype)init
{
    self = [super init];
    if (self) {
        readOnlyProperty_ = @"只读属性";
    }
    return self;
}

@end

@implementation CategoryOnlyProperty (Extend)

@end
