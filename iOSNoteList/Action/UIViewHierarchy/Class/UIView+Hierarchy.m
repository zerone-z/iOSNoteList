//
//  UIView+Hierarchy.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "UIView+Hierarchy.h"

@implementation UIView (Hierarchy)

- (NSInteger)getIndexInSuperview
{
    return [self.superview.subviews indexOfObject:self];
}

- (BOOL)isInFront
{
    return (self.superview.subviews.lastObject == self);
}

- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)bringOneLevelUp
{
    NSInteger currentIndex = [self getIndexInSuperview];
    if (currentIndex != self.superview.subviews.count - 1) {
        [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:(currentIndex + 1)];
    }
}

- (BOOL)isAtBack
{
    return ([self.superview.subviews objectAtIndex:0] == self);
}

- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}

- (void)sendOneLevelDown
{
    NSInteger currentIndex = [self getIndexInSuperview];
    if (currentIndex != 0) {
        [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:(currentIndex - 1)];
    }
}

- (void)exchangeDepthsWithView:(UIView *)otherView
{
    [self.superview exchangeSubviewAtIndex:[self getIndexInSuperview] withSubviewAtIndex:[otherView getIndexInSuperview]];
}

@end
