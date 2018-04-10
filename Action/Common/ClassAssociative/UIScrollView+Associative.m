//
//  UIScrollView+Associative.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

/*
 Objective-C runtime提供了Associative References支持
 也就是说每一个对象都有一个可选的dictionary字典，我们可以向其添加key/value对。
 这是一个非常强大的功能，我们都知道Objective-C中支持category，我们可以在category中添加方法，但是它不允许我们添加实例变量。
 通过这个Associative References我们就可以在category中添加实例变量了，但是需要指出的是这个是假的实例变量，变量实际上并不是类对象的一部分，而是存储在对象的Associative References的dictionary中；也就是说我们这样添加的变量并不改变类对象的大小。
 */

#define ADD_DYNAMIC_PROPERTY(PROPERTY_TYPE,PROPERTY_NAME,SETTER_NAME) \
@dynamic PROPERTY_NAME ; \
static char kProperty##PROPERTY_NAME; \
- ( PROPERTY_TYPE ) PROPERTY_NAME \
{ \
return ( PROPERTY_TYPE ) objc_getAssociatedObject(self, &(kProperty##PROPERTY_NAME ) ); \
} \
\
- (void) SETTER_NAME :( PROPERTY_TYPE ) PROPERTY_NAME \
{ \
objc_setAssociatedObject(self, &kProperty##PROPERTY_NAME , PROPERTY_NAME , OBJC_ASSOCIATION_RETAIN); \
} \

#import "UIScrollView+Associative.h"

#import <objc/runtime.h>

//static char Associatie2_1;
//static const char *Associatie2_2 = "Associatie";
static const void *Associatie2_3 = &Associatie2_3;

@implementation UIScrollView (Associative)

ADD_DYNAMIC_PROPERTY(NSString *, associative1, setAssociative1);

@dynamic associative2;

- (NSString *)associative2
{
//    return objc_getAssociatedObject(self, &Associatie2_1);
//    return objc_getAssociatedObject(self, @selector(associative2));
//    return objc_getAssociatedObject(self, Associatie2_2);
    return objc_getAssociatedObject(self, Associatie2_3);
}

- (void)setAssociative2:(NSString *)associative2
{
//    objc_setAssociatedObject(self, &Associatie2_1, associative2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(self, @selector(associative2), associative2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(self, Associatie2_2, associative2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, Associatie2_3, associative2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
