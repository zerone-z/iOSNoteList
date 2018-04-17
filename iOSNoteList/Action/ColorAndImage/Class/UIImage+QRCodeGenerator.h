//
//  UIImage+QRCodeGenerator.h
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/17.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 二维码生产器
@interface UIImage (QRCodeGenerator)

/**
 生成QR二维码
 
 @param text 字符串
 @param size 二维码大小
 @return 返回二维码图像
 */
+ (UIImage *)generateQRWithString:(NSString *)text size:(CGSize)size;

/**
 生成QR二维码
 
 @param text 字符串
 @param size 大小
 @param tintColor 二维码前景色
 @param backgroundColor 二维码背景色
 @return 二维码图像
 */
+ (UIImage *)generateQRWithString:(NSString *)text size:(CGSize)size tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor;

/**
 生成QR二维码
 
 @param text 字符串
 @param size 大小
 @param tintColor 二维码前景色
 @param backgroundColor 二维码背景色
 @param logo  二维码logo
 @return 二维码图像
 */
+ (UIImage *)generateQRWithString:(NSString *)text size:(CGSize)size tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor logo:(UIImage *)logo;

/**
 生成条形码
 
 @param text 字符串
 @param size 大小
 @return 返回条码图像
 */
+ (UIImage *)generateBarCodeWithString:(NSString *)text size:(CGSize)size;

/**
 把二维码图片镶嵌在指定图片中
 
 @param qrImage 二维码
 @param image 图片
 @param location 图片起点
 @return 镶嵌后的图片
 */
+ (UIImage *)spliceQRImage:(UIImage *)qrImage inImage:(UIImage *)image atLocation:(CGPoint)location;

@end
