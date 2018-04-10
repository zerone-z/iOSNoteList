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

@property (nonatomic, assign) ScanCodeType scanCodeType;

@property (nonatomic, assign) id<ScanCodeViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame scanCodeType:(ScanCodeType)scanCodeType;

- (void)startScanning;

- (void)stopScanning;

@end
