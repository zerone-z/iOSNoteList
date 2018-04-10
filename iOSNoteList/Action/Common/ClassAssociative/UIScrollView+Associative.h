//
//  UIScrollView+Associative.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 为cagetory添加属性支持
@interface UIScrollView (Associative)

@property (nonatomic, strong) NSString *associative1;

@property (nonatomic, strong) NSString *associative2;

@end
