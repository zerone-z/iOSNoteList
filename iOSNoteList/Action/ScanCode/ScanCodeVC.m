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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_scanCodeView changeTorch];
}

#pragma mark - Method Private
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

#pragma mark - Event Response
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

#pragma mark - ScanCodeViewDelegate
- (void)scanCodeView:(ScanCodeView *)scanCodeView didScannedCodeValue:(NSString *)codeValue
{
    self.code.text = codeValue;
//    [_scanCodeView stopScanning];
}

@end
