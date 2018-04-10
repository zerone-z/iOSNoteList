//
//  NSNumber+MoneyConvert.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/4/9.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 数字金额转换中文金额
@interface NSNumber (MoneyConvert)

/// 最大支持13位金额
- (NSString *)convertChinessMoney;

@end
