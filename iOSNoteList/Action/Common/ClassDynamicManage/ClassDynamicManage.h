//
//  ClassDynamicManage.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/10.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 类的动态管理(反射的使用)
@interface ClassDynamicManage : NSObject

#pragma mark - 属性
/**
 *  获取属性集合
 *
 *  @param className 类名
 *
 *  @return
 */
+ (NSArray *)propertiesWithClassName:(NSString *)className;

/**
 *  获取属性集合
 *
 *  @param class 类
 *
 *  @return
 */
+ (NSArray *)propertiesWithClass:(Class)class;

#pragma mark - 变量
/**
 *  获取变量名集合
 *
 *  @param className 类名
 *
 *  @return
 */
+ (NSArray *)varsWithClassName:(NSString *)className;

/**
 *  获取变量名集合
 *
 *  @param class 类
 *
 *  @return
 */
+ (NSArray *)varsWithClass:(Class)class;

/**
 *  获取对象的变量值
 *
 *  @param object  对象
 *  @param varName 变量名称
 *
 *  @return
 */
+ (id)valueForObject:(id)object withVarName:(NSString *)varName;

#pragma mark - 方法
/**
 *  获取方法名集合
 *
 *  @param className 类名
 *
 *  @return
 */
+ (NSArray *)methodsWithClassName:(NSString *)className;

/**
 *  获取方法名集合
 *
 *  @param class 类
 *
 *  @return
 */
+ (NSArray *)methodsWithClass:(Class)class;

#pragma mark - 初始化
/**
 *  初始化类
 *
 *  @param className 类名
 *
 *  @return
 */
+ (id)classInitWithClassName:(NSString *)className;

/**
 *  初始化类
 *
 *  @param class 类
 *
 *  @return
 */
+ (id)classInitWithClass:(Class)class;

/**
 *  初始化类 并调用方法
 *
 *  @param className
 *  @param selector
 *
 *  @return
 */
+ (id)classInitWithClassName:(NSString *)className handleSEL:(SEL)selector;

/**
 *  初始化类 并调用方法
 *
 *  @param className
 *  @param selector
 *
 *  @return
 */
+ (id)classInitWithClassName:(NSString *)className handleString:(NSString *)selector;

/**
 *  初始化类 并调用方法
 *
 *  @param className
 *  @param selector
 *
 *  @return
 */
+ (id)classInitWithClass:(Class)class handleSEL:(SEL)selector;

/**
 *  初始化类 并调用方法
 *
 *  @param className
 *  @param selector
 *
 *  @return
 */
+ (id)classInitWithClass:(Class)class handleString:(NSString *)selector;

/**
 *  初始化类
 *
 *  @param class    类
 *  @param selector 方法
 *  @param objs     参数，以nil结尾
 *
 *  @return
 */
+ (id)classInitWithClass:(Class)class handleSEL:(SEL)selector withObjects:(id)objs,...NS_REQUIRES_NIL_TERMINATION;

#pragma mark - 调用方法
/**
 *  调用方法
 *
 *  @param target 对象
 *  @param action 方法
 *  @param params 参数，以nil结尾
 *
 *  @return
 */
+ (id)invokeWithTarget:(id)target action:(SEL)action params:(id)params,...NS_REQUIRES_NIL_TERMINATION;

@end
