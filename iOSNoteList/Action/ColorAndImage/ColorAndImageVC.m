//
//  ColorAndImageVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/26.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "ColorAndImageVC.h"

#import "NSString+DirectoryPath.h"
#import "UIColor+Extend.h"
#import "UIImage+Extend.h"
#import "XJGifImageView.h"
#import "UIImage+QRCodeGenerator.h"

@interface ColorAndImageVC () {
    UIImage *_eagerImage;
    XJGifImageView *_gifIV;
}

@end

@implementation ColorAndImageVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        UIImage *image = [UIImage imageNamed:@"eagerLoading.jpg"];
        _eagerImage = [image eagerLoading];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // UIColor
    UIColor *decimalColor = [UIColor colorWithDecimalRed:204 green:0 blue:255 alpha:1];
    UIView *decimalView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
    decimalView.backgroundColor = decimalColor;
    [self.view addSubview:decimalView];
    
    UIColor *hexStringColor = [UIColor colorWithHexString:@"#CC00FF" alpha:1];
    UIView *hexStringView = [[UIView alloc] initWithFrame:CGRectMake(70, 100, 50, 50)];
    hexStringView.backgroundColor = hexStringColor;
    [self.view addSubview:hexStringView];
    
    UIColor *hexColor = [UIColor colorWithHex:0xCC00FF alpha:1];
    UIView *hexView = [[UIView alloc] initWithFrame:CGRectMake(130, 100, 50, 50)];
    hexView.backgroundColor = hexColor;
    [self.view addSubview:hexView];
    
    NSLog(@"%@,%@", [hexStringColor getRGB], [hexStringColor getRGBA]);
//    NSLog(@"%@,%@", [[UIColor grayColor] getRGB], [[UIColor grayColor] getRGBA]);
    
    // UIImage
    UIImage *image = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(50, 50)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 250, 50, 50)];
    imageview.image = image;
    [self.view addSubview:imageview];
    
    UIImage *snapshot = [UIImage imageWithCaptureView:self.view];
    UIImageView *snapshotIV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 250, 50, 50)];
    snapshotIV.image = snapshot;
    [self.view addSubview:snapshotIV];
    
    UIImage *screenImage = [UIImage screenImage];
    NSString *path = [@"screen.png" stringByAppendingPathOfDocuments];
    [UIImagePNGRepresentation(screenImage) writeToFile:path atomically:YES];
    NSLog(@"全屏图片：%@", path);
    
    UIImage *snapshotRetain = [UIImage imageOfRetainWithCaptureView:self.view];
    NSString *ssPath = [@"snapshot.png" stringByAppendingPathOfDocuments];
    NSString *ssrPath = [@"snapshotRetain.png" stringByAppendingPathOfDocuments];
    [UIImagePNGRepresentation(snapshot) writeToFile:ssPath atomically:YES];
    [UIImagePNGRepresentation(snapshotRetain) writeToFile:ssrPath atomically:YES];
    NSLog(@"普通图片：%@", ssPath);
    NSLog(@"高清图片：%@", ssrPath);
    
    UIImage *resetImage = [snapshotRetain imageWithResetSize:CGSizeMake(50, 50)];
    UIImage *scaleImage = [snapshotRetain imageWithScale:0.5];
    NSString *reset = [@"reset.png" stringByAppendingPathOfDocuments];
    NSString *scale = [@"scale.png" stringByAppendingPathOfDocuments];
    [UIImagePNGRepresentation(resetImage) writeToFile:reset atomically:YES];
    [UIImagePNGRepresentation(scaleImage) writeToFile:scale atomically:YES];
    NSLog(@"重置size图片：%@", reset);
    NSLog(@"等比例图片：%@", scale);
    
    // 预加载图片
    UIImageView *eagerIV = [[UIImageView alloc] initWithFrame:CGRectMake(190, 100, 50, 50)];
    eagerIV.image = _eagerImage;
    [self.view addSubview:eagerIV];
    
    // Gif图片
    NSString *gifPath = [NSString pathOfResource:@"run" ofType:@"gif"];
    _gifIV = [[XJGifImageView alloc] initWithFilePath:gifPath];
    _gifIV.center = CGPointMake(190, 300);
    [_gifIV startAnimating];
    [self.view addSubview:_gifIV];
    
    // 改变图片颜色
    UIImage *blendImage = [[UIImage imageNamed:@"blend"] imageWithTintColor:[UIColor blueColor] size:CGSizeZero];
    UIImageView *blendIV = [[UIImageView alloc] initWithImage:blendImage];
    blendIV.frame = CGRectMake(190, 250, 50, 50);
    [self.view addSubview:blendIV];
    
    // UIImage 圆角
    UIImage *imageCornerRadius = [UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(50, 50) cornerRadius:10];
    UIImageView *imageViewCornerRadius = [[UIImageView alloc] initWithFrame:CGRectMake(10, 400, 50, 50)];
    imageViewCornerRadius.image = imageCornerRadius;
    [self.view addSubview:imageViewCornerRadius];
    
    [self generateQRCodeSample];
}

- (void)generateQRCodeSample
{
    // 普通二维码
    UIImage *normal = [UIImage generateQRWithString:@"普通二维码" size:CGSizeMake(50, 50)];
    UIImageView *normalIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 460, 50, 50)];
    [normalIV setImage:normal];
    [self.view addSubview:normalIV];
    
    // 颜色二维码
    UIImage *colorI = [UIImage generateQRWithString:@"颜色二维码" size:CGSizeMake(50, 50) tintColor:[UIColor purpleColor] backgroundColor:[UIColor blueColor]];
    UIImageView *colorIV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 460, 50, 50)];
    [colorIV setImage:colorI];
    [self.view addSubview:colorIV];
    
    // logo二维码
    UIImage *logoI = [UIImage generateQRWithString:@"logo二维码" size:CGSizeMake(50, 50) tintColor:[UIColor redColor] backgroundColor:[UIColor whiteColor] logo:[UIImage imageNamed:@"dao"]];
    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(130, 460, 50, 50)];
    [logoIV setImage:logoI];
    [self.view addSubview:logoIV];
    
    // 条形码
    UIImage *barCodeI = [UIImage generateBarCodeWithString:@"barcode" size:CGSizeMake(100, 50)];
    UIImageView *barCodeIV = [[UIImageView alloc] initWithFrame:CGRectMake(190, 460, 100, 50)];
    [barCodeIV setImage:barCodeI];
    [self.view addSubview:barCodeIV];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_gifIV isAnimating]) {
        [_gifIV stopAnimating];
    }else {
        [_gifIV startAnimating];
    }
    
//    UIColor *gray = [UIColor grayColor];
//    UIColor *black = [UIColor blackColor];
//    UIColor *white = [UIColor whiteColor];
//    UIColor *red = [UIColor redColor];
//    CGFloat r;
//    CGFloat g;
//    CGFloat b;
//    CGFloat a;
//    
//    [gray getRed:&r green:&g blue:&b alpha:&a];
//    NSLog(@"%lf, %lf, %lf, %lf", r, g, b, a);
//    NSLog(@"%@, %@", [gray getRGB], [gray getRGBA]);
//    
//    [black getRed:&r green:&g blue:&b alpha:&a];
//    NSLog(@"%lf, %lf, %lf, %lf", r, g, b, a);
//    NSLog(@"%@, %@", [black getRGB], [black getRGBA]);
//    
//    [white getRed:&r green:&g blue:&b alpha:&a];
//    NSLog(@"%lf, %lf, %lf, %lf", r, g, b, a);
//    NSLog(@"%@, %@", [white getRGB], [white getRGBA]);
//    
//    [red getRed:&r green:&g blue:&b alpha:&a];
//    NSLog(@"%lf, %lf, %lf, %lf", r, g, b, a);
//    NSLog(@"%@, %@", [red getRGB], [red getRGBA]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
