//
//  UIImage+Extend.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/26.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)

+ (UIImage *)screenImage
{
    //CGImageRef screen = UIGetScreenImage();
    //UIImage* image = [UIImage imageWithCGImage:screen];
    //CGImageRelease(screen);
    
    UIImage *image = [self imageWithCaptureView:[UIApplication sharedApplication].keyWindow];
    
    return image;
}

+ (UIImage *)imageWithCaptureView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    //[view.layer drawInContext:UIGraphicsGetCurrentContext()];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageOfRetainWithCaptureView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    [path fill];
    [path addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFor9WithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    UIImage *image = [self imageWithColor:color size:CGSizeMake(cornerRadius * 2 + 2, cornerRadius * 2+ 2) cornerRadius:cornerRadius];
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor size:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.size;
    }
    CGRect bound = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(bound.size, NO, 0.0f);
    [tintColor setFill];
    UIRectFill(bound);
    
    [self drawInRect:bound blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)imageWithResetSize:(CGSize)size
{
    [self resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)imageWithScale:(CGFloat)scale
{
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self imageWithResetSize:size];
}

- (UIImage *)eagerLoading
{
    if (NULL != &UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(self.size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(self.size);
    }
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
