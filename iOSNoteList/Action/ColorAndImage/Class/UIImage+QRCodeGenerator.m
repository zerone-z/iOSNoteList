//
//  UIImage+QRCodeGenerator.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/17.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import "UIImage+QRCodeGenerator.h"

@implementation UIImage (QRCodeGenerator)

#pragma mark - Method Private
// 第二种提高清晰度方法
+ (UIImage *)_convertHDImgWithCIImage:(CIImage *)img size:(CGSize)size
{
    CGRect extent = CGRectIntegral(img.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    // 创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();

    // width：图片宽度像素
    // height：图片高度像素
    // bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    // bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    // 创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    // 清晰的二维码图片
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    
    return outputImage;
}

// 第二种提高清晰度，并添加Logo的方法
+ (UIImage *)_convertHDImgWithCIImage:(CIImage *)img size:(CGSize)size logo:(UIImage *)logo
{
    CGRect extent = CGRectIntegral(img.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:img fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    // 原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //logo图
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [logo drawInRect:CGRectMake((size.width-logo.size.width)/2.0, (size.height-logo.size.height)/2.0, logo.size.width, logo.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

/**
 第二种修改二维码颜色方法
 
 @param image 二维码图片
 @param red red
 @param green green
 @param blue blue
 @return 修改颜色后的二维码图片
 */
+ (UIImage *)_convertColorWithQRCodeImg:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue {
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, (CGRect){(CGPointZero), (image.size)}, image.CGImage);
    // 遍历像素点，修改颜色
    int pixelNumber = imageHeight * imageWidth;
    uint32_t * pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNumber; i++, pCurPtr++) {
        if ((*pCurPtr & 0xffffff00) < 0xd0d0d000) {
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[3] = red;
            ptr[2] = green;
            ptr[1] = blue;
        } else {
            //将白色变成透明色
            uint8_t * ptr = (uint8_t *)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    UIImage * resultImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return resultImage;
}

void ProviderReleaseData(void * info, const void * data, size_t size) {
    free((void *)data);
}

#pragma mark - Method Public
+ (UIImage *)generateQRWithString:(NSString *)text size:(CGSize)size
{
    NSData *textData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    // 二维码生成器
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置默认值
    [qrFilter setDefaults];
    
    // 设置二维码值
    [qrFilter setValue:textData forKey:@"inputMessage"];
    /* 设置二维码的纠错水平，纠错水平越高，可以污损的范围越大
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // 输出二维码图片
    CIImage *qrImage = qrFilter.outputImage;
    
    // 绘制, 提高清晰度
    // 也可以使用私有方法：_convertHDImgWithCIImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

+ (UIImage *)generateQRWithString:(NSString *)text size:(CGSize)size tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor
{
    
    NSData *textData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    // 二维码生成器
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置默认值
    [qrFilter setDefaults];
    
    // 设置二维码值
    [qrFilter setValue:textData forKey:@"inputMessage"];
    /* 设置二维码的纠错水平，纠错水平越高，可以污损的范围越大
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // 输出二维码图片
    CIImage *qrImage = qrFilter.outputImage;
    
    // 上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:
                             @"inputImage", qrImage,
                             @"inputColor0", [CIColor colorWithCGColor:tintColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    qrImage = colorFilter.outputImage;
    
    // 绘制, 提高清晰度
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

+ (UIImage*)generateQRWithString:(NSString *)text size:(CGSize)size tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor logo:(UIImage *)logo
{
    NSData *textData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    // 二维码生成器
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置默认值
    [qrFilter setDefaults];
    
    // 设置二维码值
    [qrFilter setValue:textData forKey:@"inputMessage"];
    /* 设置二维码的纠错水平，纠错水平越高，可以污损的范围越大
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // 输出二维码图片
    CIImage *qrImage = qrFilter.outputImage;
    
    // 上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:
                             @"inputImage", qrImage,
                             @"inputColor0", [CIColor colorWithCGColor:tintColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    qrImage = colorFilter.outputImage;
    
    // 返回经过缩放映射变换后的图片
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    // 转化图片
    UIImage *image = [UIImage imageWithCIImage:qrImage];
    
    // 为二维码加自定义图片
    // 开启绘图, 获取图片 上下文<图片大小>
    CGFloat logoWidth = image.size.width / 4.0;
    UIGraphicsBeginImageContext(image.size);
    // 将二维码图片画上去
    [image drawInRect:CGRectMake(0, 0, image.size.width,image.size.height)];
    // 把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来，是由inputCorrectionLevel的级别而定
    UIImage *smallImage =logo;
    [smallImage drawInRect:CGRectMake((image.size.width - logoWidth) / 2, (image.size.width - logoWidth) / 2, logoWidth, logoWidth)];
    // 获取最终的图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 显示
    return finalImage;
}

+ (UIImage *)generateBarCodeWithString:(NSString *)text size:(CGSize)size
{
    NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    // 条形码生成器
    CIFilter *barCodeFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    // 设置默认值
    [barCodeFilter setDefaults];
    // 设置条形码值
    [barCodeFilter setValue:textData forKey:@"inputMessage"];
    // 设置生成的条形码的上，下，左，右的margins的值
    [barCodeFilter setValue:@(0.00) forKey:@"inputQuietSpace"];
    // 输出条形码图片
    CIImage *barcodeImage = [barCodeFilter outputImage];
    
    // 消除模糊 extent：图片的frame
    CGFloat scaleX = size.width / barcodeImage.extent.size.width;
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    
    // 返回经过缩放映射变换后的图片
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

+ (UIImage *)spliceQRImage:(UIImage *)qrImage inImage:(UIImage *)image atLocation:(CGPoint)location
{
    UIGraphicsBeginImageContextWithOptions(qrImage.size, NO, [[UIScreen mainScreen] scale]);
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    
    [image drawInRect:CGRectMake(location.x, location.y, image.size.width, image.size.height)];
    UIImage *spliceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return spliceImage;
}

@end
