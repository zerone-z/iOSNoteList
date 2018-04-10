//
//  ScanCodeVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "ScanCodeVC.h"

#import "ScanCodeView.h"

@interface ScanCodeVC () <ScanCodeViewDelegate> {
    ScanCodeView *_scanCodeView;
    ScanCodeType currentCodeType;
}
@end

@implementation ScanCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScanCodeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createScanCodeView
{
    CGRect frame = CGRectZero;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    if (_scanCodeView) {
        [_scanCodeView removeFromSuperview];
        frame = _scanCodeView.frame;
    }else {
        frame = CGRectMake(10, 140, CGRectGetWidth(screenFrame) - 20, CGRectGetWidth(screenFrame) - 20);
    }
    _scanCodeView = [[ScanCodeView alloc] initWithFrame:frame scanCodeType:currentCodeType];
    _scanCodeView.delegate = self;
    [_scanCodeView startScanning];
    [self.view addSubview:_scanCodeView];
}

- (IBAction)scanQRcode:(UIButton *)sender {
    if (currentCodeType == ScanCodeTypeQr) {
        [_scanCodeView stopScanning];
        return;
    }
    
    currentCodeType = ScanCodeTypeQr;
}

- (IBAction)scanBarCode:(UIButton *)sender {
    if (currentCodeType == ScanCodeTypeBar) {
        [_scanCodeView stopScanning];
        return;
    }
    
    currentCodeType = ScanCodeTypeBar;
    [self createScanCodeView];
}

- (IBAction)scanUniversalCode:(UIButton *)sender {
    if (currentCodeType == ScanCodeTypeUniversal) {
        [_scanCodeView stopScanning];
        return;
    }
    
    currentCodeType = ScanCodeTypeUniversal;
    [self createScanCodeView];
}

- (void)scanCodeView:(ScanCodeView *)scanCodeView didScannedCodeValue:(NSString *)codeValue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.code.text = codeValue;
        [self->_scanCodeView stopScanning];
    });
}

@end
