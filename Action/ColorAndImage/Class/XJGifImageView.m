//
//  XJGifImageView.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

typedef struct XJGifFrameAttr {
    CGFloat width;
    CGFloat height;
    CGFloat delayTime;
} XJGifFrameAttr;

static NSString *const XJGifAnimationForKey = @"GifAnimation";     ///< gif动画的key值

#import "XJGifImageView.h"

#import <ImageIO/ImageIO.h>

@interface XJGifImageView () <CAAnimationDelegate> {
    CGImageSourceRef _gifSource;
    NSMutableArray *_frames;
    NSMutableArray *_frameAttrs;
    
    NSMutableArray *_keyTimes;
}

@end

@implementation XJGifImageView

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:
                                       [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                                  forKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        _gifSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], (CFDictionaryRef)gifProperties);
        [self initial];
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:
                                        [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                                   forKey:(NSString *)kCGImagePropertyGIFDictionary];
        _gifSource = CGImageSourceCreateWithData((CFDataRef)data, (CFDictionaryRef)gifProperties);
        [self initial];
    }
    return self;
}

- (void)initial
{
    size_t count =CGImageSourceGetCount(_gifSource);
    _frames = [NSMutableArray arrayWithCapacity:count];
    _frameAttrs = [NSMutableArray arrayWithCapacity:count];
    CGFloat totalTime = 0;
    for (size_t i = 0; i < count; ++i) {
        XJGifFrameAttr frameAttr;
        // 获取当前索引所在的帧图片
        CGImageRef frame = CGImageSourceCreateImageAtIndex(_gifSource, i, NULL);
        if (i == 0) {
            self.layer.contents = (__bridge id)frame;
        }
        [_frames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        // 获取当前帧所在图片的属性
        CFDictionaryRef frameInfo = CGImageSourceCopyPropertiesAtIndex(_gifSource, i, NULL);
        
        // Gif每一帧图片的尺寸
        frameAttr.width = [(NSNumber *)CFDictionaryGetValue(frameInfo, kCGImagePropertyPixelWidth) floatValue];
        frameAttr.height = [(NSNumber *)CFDictionaryGetValue(frameInfo, kCGImagePropertyPixelHeight) floatValue];
        
        // kCGImagePropertyGIFDictionary中kCGImagePropertyGIFDelayTime，kCGImagePropertyGIFUnclampedDelayTime值是一样的
        NSDictionary *gifDict = CFDictionaryGetValue(frameInfo, kCGImagePropertyGIFDictionary);
        frameAttr.delayTime = [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
        
        totalTime += frameAttr.delayTime;
        
        NSValue *frameInfoValue = [NSValue valueWithBytes:&frameAttr objCType:@encode(XJGifFrameAttr)];
        //[frameInfoValue getValue:&gifFrameInfo]; 取值
        [_frameAttrs addObject:frameInfoValue];
        
        CFRelease(frameInfo);
    }
    
    self.animationDuration = totalTime;
    NSValue *frameAttr = _frameAttrs.lastObject;
    XJGifFrameAttr gifFrameAttr;
    [frameAttr getValue:&gifFrameAttr];
    self.frame = CGRectMake(0, 0, gifFrameAttr.width, gifFrameAttr.height);
}

- (void)startAnimating
{
    if (!_keyTimes) {
        NSUInteger count = _frameAttrs.count;
        CGFloat keyTime = 0;
        _keyTimes = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; ++i) {
            NSValue *frameValue = [_frameAttrs objectAtIndex:i];
            XJGifFrameAttr frameAttr;
            [frameValue getValue:&frameAttr];
            
            [_keyTimes addObject:[NSNumber numberWithFloat:(keyTime /self.animationDuration)]];
            keyTime += frameAttr.delayTime;
        }
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.keyTimes = _keyTimes;
    animation.values = _frames;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = self.animationDuration;
    animation.delegate = self;
    animation.repeatCount = INFINITY;
    
    [self.layer addAnimation:animation forKey:XJGifAnimationForKey];
}

- (void)stopAnimating
{
    [self.layer removeAllAnimations];
}

- (BOOL)isAnimating
{
    return (BOOL)[self.layer animationForKey:XJGifAnimationForKey];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.layer.contents = [_frames objectAtIndex:0];
}

- (void)dealloc
{
    CFRelease(_gifSource);
}

@end
