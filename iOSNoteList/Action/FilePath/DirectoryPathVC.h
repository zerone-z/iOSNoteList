//
//  DirectoryPathVC.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryPathVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *lbHome;
@property (weak, nonatomic) IBOutlet UITextField *lbResource;
@property (weak, nonatomic) IBOutlet UITextField *lbDocument;
@property (weak, nonatomic) IBOutlet UITextField *lbLibrary;
@property (weak, nonatomic) IBOutlet UITextField *lbCaches;
@property (weak, nonatomic) IBOutlet UITextField *lbTemp;
@property (weak, nonatomic) IBOutlet UITextField *lbImagePath;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *tvName;
@property (weak, nonatomic) IBOutlet UITextField *tvDirectoryPath;

- (IBAction)changeName:(UISegmentedControl *)sender;

- (IBAction)appendingPath:(UIButton *)sender;

@end
