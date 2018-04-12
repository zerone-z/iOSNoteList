//
//  BarChartView.h
//  iOSNoteList
//
//  Created by LuPengDa on 14-12-2.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 柱状图
@interface BarChartView : UIView

/// 数据源1 存放NSNumber
@property (nonatomic, strong) NSArray *dataSource1;

/// 数据源2 存放NSNumber
@property (nonatomic, strong) NSArray *dataSource2;

/**
 *  加载图表
 */
- (void)loadView;

@end
