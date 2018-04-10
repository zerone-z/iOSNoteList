//
//  AssetsPickerVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/10.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import "AssetsPickerVC.h"
#import "XJAssetsPickerController.h"

@interface AssetsPickerVC ()<XJAssetsPickerDelegate> {
    
}

- (IBAction)choosePictureEvent:(UIButton *)sender;
- (IBAction)chooseVideoEvent:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *showPicture;

@end

@implementation AssetsPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Response
- (IBAction)choosePictureEvent:(UIButton *)sender {
    XJAssetsPickerController *assetsPicker=[[XJAssetsPickerController alloc]initPhotosPicker];
    assetsPicker.delegate=self;
    assetsPicker.maxSelectCount=4;
    [self presentViewController:assetsPicker animated:YES completion:nil];
}

- (IBAction)chooseVideoEvent:(UIButton *)sender {
    XJAssetsPickerController *assetsPicker=[[XJAssetsPickerController alloc]initVideosPicker];
    assetsPicker.titleButtonSure=@"确定";
    assetsPicker.delegate=self;
    //assetsPicker.maxSelectCount=4; 设置无效，默认为1
    [self presentViewController:assetsPicker animated:YES completion:nil];
}

#pragma mark - XJAssetsPickerDelegate
- (void)assetsPicker:(XJAssetsPickerController *)assetsPicker didFinishPickingMediaWithInfo:(NSArray *)info
{
    //图片
    if (assetsPicker.AssetType==AssetsPickerAssetPhoto) {
        int i=0;
        for (UIView *view in self.showPicture.subviews) {
            [view removeFromSuperview];
        }
        for (NSDictionary *dic in info) {
            MZOLog(@"媒体名称：%@",dic[AssetsPickerMediaName]);
            UIImageView *imageView=[[UIImageView alloc]initWithImage:dic[AssetsPickerImageFullScreen]];
            imageView.frame=CGRectMake(self.showPicture.bounds.size.width*i++, 0, self.showPicture.bounds.size.width, self.showPicture.bounds.size.height);
            [self.showPicture addSubview:imageView];
        }
        self.showPicture.contentSize=CGSizeMake(self.showPicture.bounds.size.width*info.count, self.showPicture.bounds.size.height);
    }
    //视频
    if (assetsPicker.AssetType==AssetsPickerAssetVideo) {
        for (NSDictionary *dic in info) {
            MZOLog(@"媒体名称：%@",dic[AssetsPickerMediaName]);
            MZOLog(@"视频路径：%@",dic[AssetsPickerVedioCompress]);
        }
    }
}

@end
