//
//  SafeCollection.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/10/28.
//  Copyright © 2015年 myzerone. All rights reserved.
//

#import "SafeCollection.h"
#import <objc/runtime.h>

#define SAFE_LOG 0

#if (SAFE_LOG)
#define SAFELOG(...) safeCollectionLog(__VA_ARGS__)
#else
#define SAFELOG(...)
#endif

void safeCollectionLog(NSString *fmt, ...) NS_FORMAT_FUNCTION(1, 2);

void safeCollectionLog(NSString *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    NSString *content = [[NSString alloc] initWithFormat:fmt arguments:ap];
    NSLog(@"%@", content);
    va_end(ap);
    
    NSLog(@" ============= call stack ========== \n%@", [NSThread callStackSymbols]);
}

#pragma mark - NSArray

@interface NSArray (SafeI)

@end

@implementation NSArray (SafeI)

+ (Method)methodOfSelectorI:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayI"),selector);
}

- (id)safe_objectAtIndexI:(NSUInteger)index
{
    if (index >= self.count) {
        SAFELOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return nil;
    }
    
    return [self safe_objectAtIndexI:index];
}


@end

@interface NSArray (Safe0)

@end

@implementation NSArray (Safe0)

+ (Method)methodOfSelector0:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArray0"),selector);
}

- (id)safe_objectAtIndex0:(NSUInteger)index
{
    if (index >= self.count) {
        SAFELOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return nil;
    }
    
    return [self safe_objectAtIndex0:index];
}

@end

#pragma mark - NSMutableArray

@interface NSMutableArray (Safe)

@end

@implementation NSMutableArray (Safe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayM"),selector);
}

- (id)safe_objectAtIndexM:(NSUInteger)index
{
    if (index >= self.count) {
        SAFELOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return nil;
    }
    
    return [self safe_objectAtIndexM:index];
}

- (void)safe_addObject:(id)anObject
{
    if (!anObject) {
        SAFELOG(@"[%@ %@], NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    [self safe_addObject:anObject];
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= self.count) {
        SAFELOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }
    
    if (!anObject) {
        SAFELOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (index > self.count) {
        SAFELOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }
    
    if (!anObject) {
        SAFELOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        SAFELOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }
    [self safe_removeObjectAtIndex:index];
}

- (void)safe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    if (idx1 >= self.count || idx2 >= self.count) {
        SAFELOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }
    [self safe_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

@end

#pragma mark - SafeCollection

@implementation SafeCollection

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NSArray __NSArrayI
        [self exchangeOriginalMethod:[NSArray methodOfSelectorI:@selector(objectAtIndex:)] withNewMethod:[NSArray methodOfSelectorI:@selector(safe_objectAtIndexI:)]];
        
        // NSArray __NSArray0
        [self exchangeOriginalMethod:[NSArray methodOfSelector0:@selector(objectAtIndex:)] withNewMethod:[NSArray methodOfSelector0:@selector(safe_objectAtIndex0:)]];
        
        // NSMutableArray
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(safe_objectAtIndexM:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(replaceObjectAtIndex:withObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(safe_replaceObjectAtIndex:withObject:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(addObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(safe_addObject:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(insertObject:atIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(safe_insertObject:atIndex:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(removeObjectAtIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(safe_removeObjectAtIndex:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(exchangeObjectAtIndex:withObjectAtIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(safe_exchangeObjectAtIndex:withObjectAtIndex:)]];
    });
}

+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod
{
    method_exchangeImplementations(originalMethod, newMethod);
}

@end
