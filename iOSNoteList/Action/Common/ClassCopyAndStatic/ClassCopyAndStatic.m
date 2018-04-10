//
//  ClassCopyAndStatic.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

NSString *const externSring = @"externSring";

#import "ClassCopyAndStatic.h"

@implementation ClassCopyAndStatic

- (id)copyWithZone:(NSZone *)zone
{
    ClassCopyAndStatic *copy =[[[self class] allocWithZone:zone] init];
    copy->_property1 = _property1;
    copy->_property2 = _property2;
    copy->_property3 = _property3;
    copy->_property4 = _property4;
    return copy;
}

@end
