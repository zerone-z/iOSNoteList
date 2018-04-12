//
//  TouchView.m
//  iOSNoteList
//
//  Created by LuPengDa on 14-12-1.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 允许多指接触
        self.multipleTouchEnabled = YES;
    }
    return self;
}

#pragma mark 手指开始接触时触发的事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchViewBegan:touches:withEvent:)]) {
        [self.delegate touchViewBegan:self touches:touches withEvent:event];
    }
}

#pragma mark 手指移动时触发的事件
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchViewMoved:touches:withEvent:)]) {
        [self.delegate touchViewMoved:self touches:touches withEvent:event];
    }
}

#pragma mark 手指离开时触发的事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchViewEnded:touches:withEvent:)]) {
        [self.delegate touchViewEnded:self touches:touches withEvent:event];
    }
}

#pragma mark 取消接触时触发的事件
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchViewCanceled:touches:withEvent:)]) {
        [self.delegate touchViewCanceled:self touches:touches withEvent:event];
    }
}

@end
