//
//  DirectoryPathVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "DirectoryPathVC.h"

#import "NSString+DirectoryPath.h"

@interface DirectoryPathVC ()

@end

@implementation DirectoryPathVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lbHome.text = [NSString pathOfHome];
    self.lbResource.text = [NSString pathOfResource];
    self.lbDocument.text = [NSString pathOfDocuments];
    self.lbLibrary.text = [NSString pathOfLibrary];
    self.lbCaches.text = [NSString pathOfCaches];
    self.lbTemp.text = [NSString pathOfTemp];
    self.lbImagePath.text = [NSString pathOfResource:@"dao" ofType:@"png"];
    self.imageView.image = [UIImage imageWithContentsOfFile:self.lbImagePath.text];
    self.tvName.text = @"测试.txt";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)changeName:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            self.tvName.text = @"测试.txt";
        }
            break;
        case 1:
        {
            self.tvName.text = @"文件夹";
        }
            break;
        default:
        {
            self.tvName.text = @"文件夹/测试.txt";
        }
            break;
    }
}

- (IBAction)appendingPath:(UIButton *)sender {
    switch (sender.tag) {
        case 1:     // Document
        {
            self.tvDirectoryPath.text = [self.tvName.text stringByAppendingPathOfDocuments];
        }
            break;
        case 2:     // Library
        {
            self.tvDirectoryPath.text = [self.tvName.text stringByAppendingPathOfLibrary];
        }
            break;
        case 3:     // Caches
        {
            self.tvDirectoryPath.text = [self.tvName.text stringByAppendingPathOfCaches];
        }
            break;
        default:    // Temp
        {
            self.tvDirectoryPath.text = [self.tvName.text stringByAppendingPathOfTemp];
        }
            break;
    }
}
@end
