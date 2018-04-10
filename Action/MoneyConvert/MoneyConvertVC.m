//
//  MoneyConvertVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "MoneyConvertVC.h"

#import "NSNumber+MoneyConvert.h"

@interface MoneyConvertVC ()

@end

@implementation MoneyConvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)convertMoney:(UIButton *)sender {
    NSNumber *number = @(self.number.text.doubleValue);
    self.showValue.text = [number convertChinessMoney];
}
@end
