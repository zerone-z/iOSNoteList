//
//  TouchView.h
//  iOSNoteList
//
//  Created by LuPengDa on 14-12-1.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchView;

/// 触摸协议
@protocol TouchViewDelegate <NSObject>

/**
 *  手指开始接触时触发的事件
 */
- (void)touchViewBegan:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 *  手指移动时触发的事件
 */
- (void)touchViewMoved:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 *  手指离开时触发的事件
 */
- (void)touchViewEnded:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event;

/**
 *  取消接触时触发的事件
 */
- (void)touchViewCanceled:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event;

@end

/// 手势控制
@interface TouchView : UIView

/// 委托
@property (nonatomic, weak) id<TouchViewDelegate> delegate;

@end
