//
//  MoneyConvertVC.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyConvertVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UILabel *showValue;

- (IBAction)convertMoney:(UIButton *)sender;

@end
