//
//  UIView+Hierarchy.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Hierarchy)

/**
 *  获取在父视图中的索引
 */
- (NSInteger)getIndexInSuperview;

/**
 *  是否在最上面
 */
- (BOOL)isInFront;

/**
 *  把当前视图调整到最上面
 */
- (void)bringToFront;

/**
 *  把当前视图往上面调整一层
 */
- (void)bringOneLevelUp;

/**
 *  是否在最下面
 */
- (BOOL)isAtBack;

/**
 *  把当前视图调整到最下面
 */
- (void)sendToBack;

/**
 *  把当前视图往下调整一层
 */
- (void)sendOneLevelDown;

/**
 *  交换两个视图在父视图中的位置
 *
 *  @param otherView 要交换的视图
 */
- (void)exchangeDepthsWithView:(UIView *)otherView;

@end
