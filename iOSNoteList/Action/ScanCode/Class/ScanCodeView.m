//
//  ScanCodeView.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "ScanCodeView.h"

#import <AVFoundation/AVFoundation.h>

@interface ScanCodeView () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}

@end

@implementation ScanCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [self initWithFrame:frame scanCodeType:ScanCodeTypeUniversal]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame scanCodeType:(ScanCodeType)scanCodeType
{
    if (self = [super initWithFrame:frame]) {
        self.scanCodeType = scanCodeType;
        // Device
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // Input
        NSError *error;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!input) {
            NSLog(@"%@", [error localizedDescription]);
        }else{
            // Session
            AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
            // Set the input device on the capture session.
            [captureSession addInput:input];
            
            // Output
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            // Set the output device on the capture session.
            [captureSession addOutput:output];
            // Create a new serial dispatch queue.
            dispatch_queue_t dispatchQueue;
            dispatchQueue = dispatch_queue_create("myQueue", NULL);
            [output setMetadataObjectsDelegate:self queue:dispatchQueue];
            
            switch (self.scanCodeType) {
                case ScanCodeTypeUniversal:
                {
                    [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
                }
                    break;
                case ScanCodeTypeBar:
                {
                    [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode, nil]];
                }
                    break;
                default:
                {
                    [output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
                }
                    break;
            }
            
            // Preview
            _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
            [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [_videoPreviewLayer setFrame:self.bounds];
            [self.layer addSublayer:_videoPreviewLayer];
        }

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _videoPreviewLayer.frame = self.bounds;
}

- (void)startScanning
{
    [_videoPreviewLayer.session startRunning];
}

- (void)stopScanning
{
    [_videoPreviewLayer.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
//        NSLog(@"码值：%@，%@", metadataObj.stringValue, metadataObj.corners);
        if ([self.delegate respondsToSelector:@selector(scanCodeView:didScannedCodeValue:)]) {
            [self.delegate scanCodeView:self didScannedCodeValue:metadataObj.stringValue];
        }
    }
}

@end
