//
//  ScatterView.h
//  iOSNoteList
//
//  Created by LuPengDa on 14-11-21.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 折线图／曲线图／散点图／直方图
@interface ScatterChartView : UIView

/// 数据源 存放NSNumber
@property (nonatomic, strong) NSArray *dataSource;

/**
 *  加载图表
 */
- (void)loadView;

@end
