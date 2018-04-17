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
    AVCaptureDeviceInput *_deviceInput;
    AVCaptureMetadataOutput *_metadateOutput;
    AVCaptureStillImageOutput *_stillImageOutput;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    
    BOOL _hadAutoVideoZoom;
}

@end

@implementation ScanCodeView

+ (NSArray<NSString *> *)recognizeImage:(UIImage *)image
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0){
        return nil;
    }
    
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSMutableArray<NSString*> *mutableArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        [mutableArray addObject:scannedResult];
    }
    return [mutableArray copy];
}

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
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _videoPreviewLayer.frame = self.bounds;
}

#pragma mark - Method Public
- (void)setup
{
    // Device
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!captureDevice) {
        return;
    }
    // Input
    NSError *error;
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!_deviceInput) {
        MZOLog(@"%@", [error localizedDescription]);
        return;
    }
    
    // Output
    _metadateOutput = [[AVCaptureMetadataOutput alloc] init];
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [_metadateOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    // 调整镜头
    _stillImageOutput = [AVCaptureStillImageOutput new];
    [_stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
    
    // Session
    _session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    // Set the input device on the capture session.
    if ([_session canAddInput:_deviceInput]) {
        [_session addInput:_deviceInput];
    }
    // Set the output device on the capture session.
    if ([_session canAddOutput:_metadateOutput]) {
        [_session addOutput:_metadateOutput];
    }
    if ([_session canAddOutput:_stillImageOutput]) {
        [_session addOutput:_stillImageOutput];
    }
    
    switch (self.scanCodeType) {
        case ScanCodeTypeUniversal:
        {
            [_metadateOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
        }
            break;
        case ScanCodeTypeBar:
        {
            [_metadateOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode, nil]];
        }
            break;
        default:
        {
            [_metadateOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        }
            break;
    }
    
    // Preview
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.bounds];
    [self.layer addSublayer:_videoPreviewLayer];
    
    // 锁定设备配置
    [_deviceInput.device lockForConfiguration:nil];
    
    // 自动白平衡
    if ([_deviceInput.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        [_deviceInput.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
    }
    // 自动对焦
    if (_deviceInput.device.isFocusPointOfInterestSupported && [_deviceInput.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [_deviceInput.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    // 自动曝光
    if ([_deviceInput.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [_deviceInput.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    // 解锁设备配置
    [_deviceInput.device unlockForConfiguration];
}

- (void)startScanning
{
    [_videoPreviewLayer.session startRunning];
    [self setVideoScale:1];
}

- (void)stopScanning
{
    [_videoPreviewLayer.session stopRunning];
}

- (BOOL)torchOn
{
    AVCaptureTorchMode torch = _deviceInput.device.torchMode;
    if(torch == AVCaptureTorchModeOn) {
        return YES;
    }
    return NO;
}

- (void)torchOn:(BOOL)on
{
    [_deviceInput.device lockForConfiguration:nil];
    [_deviceInput.device setTorchMode:on ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    [_deviceInput.device unlockForConfiguration];
}

- (void)changeTorch
{
    AVCaptureTorchMode torch = _deviceInput.device.torchMode;
    switch (torch) {
        case AVCaptureTorchModeAuto:
            break;
        case AVCaptureTorchModeOff:
            torch = AVCaptureTorchModeOn;
            break;
        case AVCaptureTorchModeOn:
            torch = AVCaptureTorchModeOff;
            break;
        default:
            break;
    }
    
    [_deviceInput.device lockForConfiguration:nil];
    _deviceInput.device.torchMode = torch;
    [_deviceInput.device unlockForConfiguration];
}

#pragma mark - Method Private
- (void)changeVideoScale:(AVMetadataMachineReadableCodeObject *)objc
{
    NSArray *array = objc.corners;
    CGPoint point = CGPointZero;
    int index = 0;
    CFDictionaryRef dict = (__bridge CFDictionaryRef)(array[index++]);
    // 把点转换为不可变字典
    // 把字典转换为点，存在point里，成功返回true 其他false
    CGPointMakeWithDictionaryRepresentation(dict, &point);
    MZOLog(@"X:%f -- Y:%f",point.x,point.y);
    CGPoint point2 = CGPointZero;
    CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)array[2], &point2);
    MZOLog(@"X:%f -- Y:%f",point2.x,point2.y);
    CGFloat scace = 200 / (point2.x-point.x); //当二维码图片宽小于200，进行放大
    if (scace > 1) {
        for (CGFloat i= 1.0; i<=scace; i = i+0.001) {
            [self setVideoScale:i];
        }
    }
    return;
}

- (void)setVideoScale:(CGFloat)scale
{
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    AVCaptureDeviceInput *input =  _videoPreviewLayer.session.inputs.firstObject;
    AVCaptureMetadataOutput *output = _videoPreviewLayer.session.outputs.firstObject;
    
    //获取放大最大倍数
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    if (!videoConnection) {
        return;
    }
    
    CGFloat maxScaleAndCropFactor = ([[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor]) / 16;
    if (scale > maxScaleAndCropFactor) {
        scale = maxScaleAndCropFactor;
    }

    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;

    [input.device lockForConfiguration:nil];
    videoConnection.videoScaleAndCropFactor = scale;
    [input.device unlockForConfiguration];

    CATransform3D transform = _videoPreviewLayer.transform;
    [CATransaction begin];
    [CATransaction setAnimationDuration: 0.025];
    _videoPreviewLayer.transform = CATransform3DScale(transform, zoom, zoom, 1);
    [CATransaction commit];
}

/// 扫码成功存储当前图片
- (void)captureImage
{
    //获取放大最大倍数
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    if (!videoConnection) {
        return;
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         if (error) {
             return;
         }
         // 保存图片
//         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//         UIImage *image1 = [UIImage imageWithData:imageData];
//         [UIImagePNGRepresentation(image1) writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [NSUUID UUID].UUIDString]] atomically:YES];
     }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
//        NSLog(@"码值：%@，%@", metadataObj.stringValue, metadataObj.corners);
        if ([self.delegate respondsToSelector:@selector(scanCodeView:didScannedCodeValue:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MZOLog(@"didScannedCodeValue");
                [self.delegate scanCodeView:self didScannedCodeValue:metadataObj.stringValue];
                [self captureImage];
            });
        }
    }
    
    if (!_hadAutoVideoZoom) {
        // 改变镜头
        AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)[_videoPreviewLayer transformedMetadataObjectForMetadataObject:metadataObjects.lastObject];
        [self changeVideoScale:obj];
        _hadAutoVideoZoom = YES;
    }
}

@end
