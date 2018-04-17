//
//  ScanCodeView.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

/// 条码扫描类型
typedef NS_ENUM(NSInteger, ScanCodeType) {
    ScanCodeTypeUniversal,          ///< 所有
    ScanCodeTypeBar,                ///< 条形吗
    ScanCodeTypeQr                  ///< 二维码
};

#import <UIKit/UIKit.h>

@class ScanCodeView;

@protocol ScanCodeViewDelegate <NSObject>

- (void)scanCodeView:(ScanCodeView *)scanCodeView didScannedCodeValue:(NSString *)codeValue;

@end

@interface ScanCodeView : UIView

/// 识别二维码图片，iOS 8.0 and later
+ (NSArray<NSString *> *)recognizeImage:(UIImage*)image;

@property (nonatomic, assign) ScanCodeType scanCodeType;

@property (nonatomic, assign) id<ScanCodeViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame scanCodeType:(ScanCodeType)scanCodeType;

- (void)startScanning;

- (void)stopScanning;

/// 闪光灯是否开启
- (BOOL)torchOn;
/// 开启/关闭闪光灯
- (void)torchOn:(BOOL)on;
/// 自动改变闪光灯状态
- (void)changeTorch;

@end
