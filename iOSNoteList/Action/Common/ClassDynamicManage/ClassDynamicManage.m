//
//  ClassDynamicManage.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/10.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

/*
 isKindOfClass              判断是否是这个类或者这个类的子类的实例
 
 isMemberOfClass            判断是否是这个类的实例
 
 isSubclassOfClass          判断是否是这个类或者这个类的子类的实例
 
 conformsToProtocol         判断是否符合特定协议
 
 respondsToSelector         判读实例是否有这样方法
 
 instancesRespondToSelector 判断类是否有这个方法
 
 */

#import "ClassDynamicManage.h"

#import <objc/runtime.h>

@implementation ClassDynamicManage

#pragma mark - 获取属性集合
+ (NSArray *)propertiesWithClassName:(NSString *)className
{
    // 通过字符串获取到类
    Class class = NSClassFromString(className);
    return [self propertiesWithClass:class];
}

+ (NSArray *)propertiesWithClass:(Class)class
{
    unsigned int outCount;
    // 获取所有属性（property）
    objc_property_t *propertyList = class_copyPropertyList(class, &outCount);
    
    NSMutableArray *properties = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        // 获取到属性
        objc_property_t property = propertyList[i];
        // 属性名称
        const char *char_name =  property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        [properties addObject:propertyName];
        
        // 属性类型名称
        const char *char_attribution = property_getAttributes(property);
        NSString *propertyAttribution = [NSString stringWithUTF8String:char_attribution];
        NSArray *array = [propertyAttribution componentsSeparatedByString:@","];
        NSString *typeAtt = [array objectAtIndex:0];
        
        NSString *typeOfProperty = @"";
        if ([typeAtt hasPrefix:@"Tc"]) {
            typeOfProperty = @"CHAR";
        } else if ([typeAtt hasPrefix:@"Td"]) {
            typeOfProperty = @"DOUBLE";
        } else if ([typeAtt hasPrefix:@"Ti"]) {
            typeOfProperty = @"INT";
        } else if ([typeAtt hasPrefix:@"Tf"]) {
            typeOfProperty = @"FLOAT";
        } else if ([typeAtt hasPrefix:@"Tl"]) {
            typeOfProperty = @"LONG";
        } else if ([typeAtt hasPrefix:@"Ts"]) {
            typeOfProperty = @"SHORT";
        } else if ([typeAtt hasPrefix:@"T{"]) {
            typeOfProperty = @"STRUCT";
        } else if ([typeAtt hasPrefix:@"TI"]) {
            typeOfProperty = @"UNSIGNED";
        } else if ([typeAtt hasPrefix:@"T^i"]) {
            typeOfProperty = @"INT_P";
        } else if ([typeAtt hasPrefix:@"T^v"]) {
            typeOfProperty = @"VOID_P";
        } else if ([typeAtt hasPrefix:@"T^?"]) {
            typeOfProperty = @"BLOCK";
        } else if ([typeAtt hasPrefix:@"T@"]) {
            typeOfProperty = @"ID";
            if ([typeAtt length] > 4) {
                class = NSClassFromString([typeAtt substringWithRange:NSMakeRange(3, [typeAtt length] - 4)]);
                if ([class isSubclassOfClass:[NSArray class]]) {
                    NSUInteger location = [propertyName rangeOfString:@"$"].location;
                    if (location != NSNotFound) {
                        Class arrayClass = NSClassFromString([propertyName substringWithRange:NSMakeRange(location + 1,[propertyName length] - location - 1)]);
                        NSString *dicPropertyName = [NSString stringWithString:[propertyName substringWithRange:NSMakeRange(0,location)]];
                    }
                }
            }
        }
        
        BOOL readOnly = NO;
        if ([array count] > 2) {
            for (NSUInteger i = 1; i < [array count] - 1; i++) {
                NSString *att = [array objectAtIndex:i];
                if ([att isEqualToString:@"R"]) {
                    readOnly = YES;
                }
            }
        }
        
    }
    
    // 释放
    if (propertyList) {
        free(propertyList);
    }
    
    return properties;
}

#pragma mark - 获取变量名集合
+ (NSArray *)varsWithClassName:(NSString *)className
{
    // 通过字符串获取到类
    Class class = NSClassFromString(className);
    return [self varsWithClass:class];
}

+ (NSArray *)varsWithClass:(Class)class
{
    unsigned int outCount;
    // 获取所有变量（ivar）
    Ivar *varList = class_copyIvarList(class, &outCount);
    
    NSMutableArray *vars = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        // 获取到变量
        Ivar var = varList[i];
        // 变量名称
        const char *char_name =  ivar_getName(var);
        NSString *varName = [NSString stringWithUTF8String:char_name];
        [vars addObject:varName];
        
        // 变量类型名称
        const char *char_attribution = ivar_getTypeEncoding(var);
        NSString *varAttribution = [NSString stringWithUTF8String:char_attribution];
        NSArray *array = [varAttribution componentsSeparatedByString:@","];
        NSString *typeAtt = [array objectAtIndex:0];
        
        char *t = @encode(char); //查找Char 代表的type
        NSString *typeOfProperty = @"";
        if ([typeAtt hasPrefix:@"Tc"]) {
            typeOfProperty = @"CHAR";
        } else if ([typeAtt hasPrefix:@"Td"]) {
            typeOfProperty = @"DOUBLE";
        } else if ([typeAtt hasPrefix:@"Ti"]) {
            typeOfProperty = @"INT";
        } else if ([typeAtt hasPrefix:@"Tf"]) {
            typeOfProperty = @"FLOAT";
        } else if ([typeAtt hasPrefix:@"Tl"]) {
            typeOfProperty = @"LONG";
        } else if ([typeAtt hasPrefix:@"Ts"]) {
            typeOfProperty = @"SHORT";
        } else if ([typeAtt hasPrefix:@"T{"]) {
            typeOfProperty = @"STRUCT";
        } else if ([typeAtt hasPrefix:@"TI"]) {
            typeOfProperty = @"UNSIGNED";
        } else if ([typeAtt hasPrefix:@"T^i"]) {
            typeOfProperty = @"INT_P";
        } else if ([typeAtt hasPrefix:@"T^v"]) {
            typeOfProperty = @"VOID_P";
        } else if ([typeAtt hasPrefix:@"T^?"]) {
            typeOfProperty = @"BLOCK";
        } else if ([typeAtt hasPrefix:@"T@"]) {
            typeOfProperty = @"ID";
            if ([typeAtt length] > 4) {
                class = NSClassFromString([typeAtt substringWithRange:NSMakeRange(3, [typeAtt length] - 4)]);
                if ([class isSubclassOfClass:[NSArray class]]) {
                    NSUInteger location = [varName rangeOfString:@"$"].location;
                    if (location != NSNotFound) {
                        Class arrayClass = NSClassFromString([varName substringWithRange:NSMakeRange(location + 1,[varName length] - location - 1)]);
                        NSString *dicPropertyName = [NSString stringWithString:[varName substringWithRange:NSMakeRange(0,location)]];
                    }
                }
            }
        }
        
        BOOL readOnly = NO;
        if ([array count] > 2) {
            for (NSUInteger i = 1; i < [array count] - 1; i++) {
                NSString *att = [array objectAtIndex:i];
                if ([att isEqualToString:@"R"]) {
                    readOnly = YES;
                }
            }
        }
        
    }
    
    // 释放
    if (varList) {
        free(varList);
    }
    
    return vars;
}

+ (id)valueForObject:(id)object withVarName:(NSString *)varName
{
    unsigned int outCount;
    // 获取所有变量（ivar）
    Ivar *varList = class_copyIvarList([object class], &outCount);
    
    id value = nil;
    for (int i = 0; i < outCount; i++) {
        // 获取到变量
        Ivar var = varList[i];
        // 变量名称
        const char *char_name =  ivar_getName(var);
        NSString *varNameTem = [NSString stringWithUTF8String:char_name];
        if ([varNameTem isEqualToString:varName]) {
            // 获取对象的变量值
            value = object_getIvar(object, var);
        }
    }
    
    // 释放
    if (varList) {
        free(varList);
    }
    
    return value;
}

#pragma mark - 获取方法名集合
+ (NSArray *)methodsWithClassName:(NSString *)className
{
    // 通过字符串获取到类
    Class class = NSClassFromString(className);
    return [self methodsWithClass:class];
}

+ (NSArray *)methodsWithClass:(Class)class
{
    unsigned int outCount;
    // 获取所有方法
    Method *methodList = class_copyMethodList(class, &outCount);
    
    // 获取对象的某个方法
    //Method *methodObject = class_getInstanceMethod(self, @selector(viewDidAppear:));
    // 交换方法
    //method_exchangeImplementations(<#Method m1#>, <#Method m2#>)
    
    NSMutableArray *methods = [NSMutableArray arrayWithCapacity:outCount];
    
    for (int i = 0; i < outCount; i++) {
        // 获取方法
        Method method = methodList[i];
        // 获取方法（消息）
        SEL sel = method_getName(method);
        // 获取方法（消息）名称
        const char *char_name = sel_getName(sel);
        NSString *methodName = [NSString stringWithUTF8String:char_name];
        [methods addObject:methodName];
        
        // 获取参数个数
        int argumentCount = method_getNumberOfArguments(method);
        // 获取类型编码
        const char *char_encoding = method_getTypeEncoding(method);
        NSString *methodEncoding = [NSString stringWithUTF8String:char_encoding];
        
        // 获取方法指针
        IMP imp = method_getImplementation(method);
        
        // 获取当前方法的IMP
        IMP currentImg = [class instanceMethodForSelector:_cmd];
    }
    
    if (methodList) {
        free(methodList);
    }
    
    return methods;
}

#pragma mark - 初始化类
+ (id)classInitWithClassName:(NSString *)className
{
    // 通过字符串获取到类
    Class class = NSClassFromString(className);
    return [self classInitWithClass:class];
}

+ (id)classInitWithClass:(Class)class
{
    id obj = [[class alloc] init];
    return obj;
}

#pragma mark - 初始化类 并调用方法
+ (id)classInitWithClass:(Class)class handleString:(NSString *)selector
{
    // 通过字符串获取到类的方法（消息）
    SEL sel = NSSelectorFromString(selector);
    return [self classInitWithClass:class handleSEL:sel];
}

+ (id)classInitWithClass:(Class)class handleSEL:(SEL)selector
{
    id obj = [self classInitWithClass:class];
    // 检测是否有对selector方法（消息）的实现，有则调用该方法
    if ([obj respondsToSelector:selector]) {
        [obj performSelector:selector];
    }
    
    return obj;
}

+ (id)classInitWithClassName:(NSString *)className handleString:(NSString *)selector
{
    // 通过字符串获取到类
    Class class = NSClassFromString(className);
    // 通过字符串获取到类的方法（消息）
    SEL sel = NSSelectorFromString(selector);
    return  [self classInitWithClass:class handleSEL:sel];
}

+ (id)classInitWithClassName:(NSString *)className handleSEL:(SEL)selector
{
    // 通过字符串获取到类
    Class class = NSClassFromString(className);
    return [self classInitWithClass:class handleSEL:selector];
}

+ (id)classInitWithClass:(Class)class handleSEL:(SEL)selector withObjects:(id)objs, ...
{
    id classObj = [self classInitWithClass:class];
    // NSInvocation调用
    NSMethodSignature *sig = [class instanceMethodSignatureForSelector:selector];   // instanceMethodSignatureForSelector 比较耗时
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target = classObj;   // 设置目的实例
    invocation.selector = selector; // 设立方法
    
    int argIndex = 2;
    va_list params;             //定义一个指向个数可变的参数列表指针
    va_start(params, objs);     //va_start 得到第一个可变参数地址
    if (objs) {
        id prev = objs;
        id arg;
        
        //设置参数atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
        [invocation setArgument:&prev atIndex:argIndex];
        while ((arg = va_arg(params, id))) {        //va_arg 指向下一个参数地址
            [invocation setArgument:&arg atIndex:++argIndex];
        }
    }
    va_end(params);         //置空
    
    [invocation retainArguments];       //retain 所有参数，防止参数被释放dealloc
    [invocation invoke];                //调用方法
    
    //id returnValue;
    //[invocation getReturnValue:&returnValue];       //完成调用设置调用返回值
    
    return classObj;
}

#pragma mark - 调用方法
+ (id)invokeWithTarget:(id)target action:(SEL)action params:(id)params, ...
{
    
    //id test = objc_msgSend(target, action, @"5", @"3");
    
    // NSInvocation调用
    NSMethodSignature *sig = [target methodSignatureForSelector:action];  // methodSignatureForSelector 比较耗时
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    invocation.target = target;   // 设置目的实例
    invocation.selector = action; // 设立方法
    
    int argIndex = 2;
    va_list paramList;             //定义一个指向个数可变的参数列表指针
    va_start(paramList, params);     //va_start 得到第一个可变参数地址
    if (params) {
        id prev = params;
        id arg;
        
        //设置参数atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
        [invocation setArgument:&prev atIndex:argIndex];
        while ((arg = va_arg(paramList, id))) {        //va_arg 指向下一个参数地址
            if (arg) {
                [invocation setArgument:&arg atIndex:++argIndex];
            }
        }
    }
    va_end(paramList);         //置空
    
    [invocation retainArguments];       //retain 所有参数，防止参数被释放dealloc
    [invocation invoke];                //调用方法
    
    id returnValue;
    [invocation getReturnValue:&returnValue];       //完成调用设置调用返回值
    
    return returnValue;
}

@end
