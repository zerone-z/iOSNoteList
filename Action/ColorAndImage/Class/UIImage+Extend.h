//
//  UIImage+Extend.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/26.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

/**
 *  全屏图片获取
 */
+ (UIImage *)screenImage;

/**
 *  截图 Snapshot
 */
+ (UIImage *)imageWithCaptureView:(UIView *)view;

/**
 *  截图（兼容高清屏） Snapshot
 */
+ (UIImage *)imageOfRetainWithCaptureView:(UIView *)view;

/**
 *  通过UIColor生产UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  UIColor生成带圆角的UIImage
 *
 *  @param color        颜色
 *  @param size         大小
 *  @param cornerRadius 圆角
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 *  UIColor转UIImage，Image支持九切图，四边为圆角
 *
 *  @param color        颜色
 *  @param cornerRadius 圆角
 *
 *  @return UIImage
 */
+ (UIImage *)imageFor9WithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/**
 *  改变UIImage的颜色，并保留透明度
 *
 *  @param color 显示的目标颜色
 *  @param size  图片大小，如果为CGSizeZero，则保持原图片大小
 *。
 *  @return 新的UIImage
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor size:(CGSize)size;

/**
 *  重置image 的 size
 */
- (UIImage *)imageWithResetSize:(CGSize)size;

/**
 *  等比例缩放image
 */
- (UIImage *)imageWithScale:(CGFloat)scale;

/**
 *  预加载
 */
- (UIImage *)eagerLoading;

@end
