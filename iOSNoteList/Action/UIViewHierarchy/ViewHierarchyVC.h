//
//  ViewHierarchyVC.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewHierarchyVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *indexLb;
@property (weak, nonatomic) IBOutlet UISwitch *isFront;
@property (weak, nonatomic) IBOutlet UISwitch *isBack;

@property (weak, nonatomic) IBOutlet UIView *viewGray;
@property (weak, nonatomic) IBOutlet UIView *viewBlue;
@property (weak, nonatomic) IBOutlet UIView *viewBrown;

- (IBAction)bringFront:(UIButton *)sender;
- (IBAction)bringOneLevel:(UIButton *)sender;
- (IBAction)exchangeView:(UIButton *)sender;
- (IBAction)sendBack:(UIButton *)sender;
- (IBAction)sendOneLevel:(UIButton *)sender;
@end
