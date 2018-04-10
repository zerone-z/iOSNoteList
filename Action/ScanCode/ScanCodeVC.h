//
//  ScanCodeVC.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScanCodeView;

@interface ScanCodeVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *code;

- (IBAction)scanQRcode:(UIButton *)sender;
- (IBAction)scanBarCode:(UIButton *)sender;
- (IBAction)scanUniversalCode:(UIButton *)sender;
@end
