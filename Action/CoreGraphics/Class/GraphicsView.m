//
//  GraphicsView.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/12.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "GraphicsView.h"

@implementation GraphicsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)reloadView
{
    // 标记为需要重绘 drawRect
    [self setNeedsDisplay];
    // 标记为需要局部重绘
    //self setNeedsDisplayInRect:<#(CGRect)#>
    
    // 标记为需要重新布局 layoutSubviews
    //[self setNeedsLayout];
    // 如果已经标记为需要重新布局 则立即重新布局 layoutSubviews
    //[self layoutIfNeeded];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    // 获取一个与视图相关联的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 线条
    [self drawLineForMethod1WithContext:context];
    [self drawLineForMethod2WithContext:context];
    [self drawLineForMethod3WithContext:context];
    
    // 矩形
    [self drawRectangleForMethod1WithContext:context];
    [self drawRectangleForMethod2WithContext:context];
    [self drawRectangleForMethod3WithContext:context];
    [self drawRectangleForMethod4WithContext:context];
    
    // 圆
    [self drawCircleForMethod1WithContext:context];
    [self drawCircleForMethod2WithContext:context];
    [self drawCircleForMethod3WithContext:context];
    
    // 渐变
    [self drawGradientForMethod1WithContext:context];
    
    // 绘制文本
    [self drawTextForMethod1WithContext:context];
    [self drawTextForMethod2WithContext:context];
    
    // 绘制图片
    [self drawImageWithContext:context];
    [self drawWaterMarkForImageWithContext:context];
    
    // 整体context操作
    [self drawOperateWithContext:context];
}

#pragma mark - 线条
- (void)setStyleOfLineWithContext:(CGContextRef)context
{
    // 属性
    {
        CGContextSetLineWidth(context, 2);                              // 宽度
        CGContextSetLineCap(context, kCGLineCapRound);                  // 线段收尾样式
        CGContextSetLineJoin(context, kCGLineJoinRound);                // 线段连接样式
        
        // 设置虚线
        CGFloat lengths[] = {5, 15};
        CGContextSetLineDash(context, 0, lengths, 2);   // 2就是lengths数组的长度
        
        // 颜色
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        // CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1);
        //[[UIColor blueColor] setStroke];
    }
    
    // 阴影
    {
        // 默认颜色的阴影
        //CGContextSetShadow(context, CGSizeMake(4, 4), 2);
        // 带有颜色的阴影
        CGContextSetShadowWithColor(context, CGSizeMake(4, 4), 2, [UIColor redColor].CGColor);
    }
}

#pragma mark 方法一 CGPointMake(2, 100) -> CGPointMake(102, 100)
- (void)drawLineForMethod1WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    // 构建路径(可以不要)
    CGContextBeginPath(context);
    
    // 设置上下文路径起点
    CGContextMoveToPoint(context, 2, 100);
    // 增加路径内容
    CGContextAddLineToPoint(context, 100, 100);
    
    [self setStyleOfLineWithContext:context];
    
    // 绘制路径
    //CGContextDrawPath(context, kCGPathStroke);
    CGContextStrokePath(context);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法二 CGPointMake(104, 100) -> CGPointMake(204, 100)
- (void)drawLineForMethod2WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    // 构建路径
    CGMutablePathRef path = CGPathCreateMutable();
    // 设置路径起点
    CGPathMoveToPoint(path, NULL, 104, 100);
    // 增加路径内容
    CGPathAddLineToPoint(path, NULL, 204, 100);
    // 关闭路径
    CGPathCloseSubpath(path);
    
    // 将路径添加到上下文
    CGContextAddPath(context, path);
    
    [self setStyleOfLineWithContext:context];
    
    // 绘制路径
    CGContextDrawPath(context, kCGPathStroke);
    //CGContextStrokePath(context);
    
    // 释放路径
    CGPathRelease(path);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法三 CGPointMake(206, 100) -> CGPointMake(306, 100)
- (void)drawLineForMethod3WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    // 构建路径
    CGPoint points[] = {CGPointMake(206, 100), CGPointMake(306, 100)};
    CGContextAddLines(context, points, 2);
    
    [self setStyleOfLineWithContext:context];
    
    // 绘制路径
    CGContextDrawPath(context, kCGPathStroke);
    //CGContextStrokePath(context);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark - 矩形
- (void)setStyleOfRectangleWithContext:(CGContextRef)context
{
    // 边框
    {
        CGContextSetLineWidth(context, 2);                              // 宽度
        CGContextSetLineCap(context, kCGLineCapRound);                  // 线段收尾样式
        CGContextSetLineJoin(context, kCGLineJoinRound);                // 线段连接样式
        
        // 设置虚线
        CGFloat lengths[] = {5, 10};
        CGContextSetLineDash(context, 0, lengths, 2); // 2就是lengths数组的长度
        
        // 颜色
        CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
        // CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1);
    }
    
    // 填充色
    {
        //[[UIColor purpleColor] setFill];
        CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 1);
    }
    
    // 阴影
    {
        // 默认颜色的阴影
        //CGContextSetShadow(context, CGSizeMake(4, 4), 2);
        
        // 带有颜色的阴影
        CGContextSetShadowWithColor(context, CGSizeMake(4, 4), 5, [UIColor redColor].CGColor);
    }
}

#pragma mark 方法一 CGRectMake(5, 120, 50, 50)
- (void)drawRectangleForMethod1WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    // 确定矩形区域
    // 设置路径起点
    CGContextMoveToPoint(context, 5, 120);
    // 增加路径内容
    CGContextAddLineToPoint(context, 55, 120);
    CGContextAddLineToPoint(context, 55, 170);
    CGContextAddLineToPoint(context, 5, 170);
    CGContextAddLineToPoint(context, 5, 120);
    
    [self setStyleOfRectangleWithContext:context];
    
    // 绘制路径和填充色
    //CGContextDrawPath(context, kCGPathEOFillStroke);
    // 绘制路径
    //CGContextStrokePath(context);
    // 绘制填充色
    CGContextFillPath(context);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法二 CGRectMake(65, 120, 50, 50)
- (void)drawRectangleForMethod2WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    [self setStyleOfRectangleWithContext:context];
    
    // 绘制填充色
    CGContextFillRect(context, CGRectMake(65, 120, 50, 50));
    // 绘制路径
    CGContextStrokeRect(context, CGRectMake(65, 120, 50, 50));
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法三 CGRectMake(125, 120, 50, 50)
- (void)drawRectangleForMethod3WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    // 确定矩形区域
    CGContextAddRect(context, CGRectMake(125, 120, 50, 50));
    
    [self setStyleOfRectangleWithContext:context];
    
    // 绘制填充色
    CGContextFillPath(context);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法四 CGRectMake(185, 120, 50, 50)
- (void)drawRectangleForMethod4WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    // 设置贝赛尔曲线
    UIBezierPath *path=[UIBezierPath bezierPath];
    // 设置路径起点
    [path moveToPoint:CGPointMake(185, 120)];
    // 增加路径内容
    [path addLineToPoint:CGPointMake(235, 120)];
    [path addLineToPoint:CGPointMake(235, 170)];
    [path addLineToPoint:CGPointMake(185, 170)];
    [path closePath];
    
    [self setStyleOfRectangleWithContext:context];
    
    // 绘制填充色
    [path fill];
    // 绘制路径
    [path stroke];
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark - 圆
- (void)setStyleOfCircleWithContext:(CGContextRef)context
{
    // 边框
    {
        CGContextSetLineWidth(context, 2);                              // 宽度
        CGContextSetLineCap(context, kCGLineCapRound);                  // 线段收尾样式
        CGContextSetLineJoin(context, kCGLineJoinRound);                // 线段连接样式
        
        // 设置虚线
        CGFloat lengths[] = {5, 10};
        CGContextSetLineDash(context, 0, lengths, 2); // 2就是lengths数组的长度
        
        // 颜色
        CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
        // CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1);
    }
    
    // 填充色
    {
        //[[UIColor purpleColor] setFill];
        CGContextSetRGBFillColor(context, 0.3, 0.3, 0.3, 1);
    }
    
    // 阴影
    {
        // 默认颜色的阴影
        //CGContextSetShadow(context, CGSizeMake(4, 4), 2);
        
        // 带有颜色的阴影
        CGContextSetShadowWithColor(context, CGSizeMake(4, 4), 5, [UIColor redColor].CGColor);
    }
}

#pragma mark 方法一 圆心：CGPointMake(60, 280) 半径：50
- (void)drawCircleForMethod1WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    CGContextAddArc(context, 60, 280, 50, 0, M_PI * 2, 0);
    
    [self setStyleOfCircleWithContext:context];
    
    //CGContextStrokePath(context);
    CGContextFillPath(context);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法二 CGRectMake(120, 230, 100, 100)
- (void)drawCircleForMethod2WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    CGContextAddEllipseInRect(context, CGRectMake(120, 230, 100, 100));
    
    [self setStyleOfCircleWithContext:context];
    
    CGContextStrokePath(context);
    //CGContextFillPath(context);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法三 圆心：CGPointMake(280, 280) 半径：50
- (void)drawCircleForMethod3WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    [self setStyleOfCircleWithContext:context];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(280, 280) radius:50 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [path fill];
    [path stroke];
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark - 渐变
#pragma mark 方法一 CGRectMake(10, 340, 100, 100)
- (void)drawGradientForMethod1WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    
    //1. 定义渐变引用CGGradientRef
    CGGradientRef gradient;
    //2. 定义色彩空间引用
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //3. 定义渐变颜色组件
    //每四个数一组，分别对应r,g,b,透明度
    CGFloat components[8] = {1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0};
    //4. 定义颜色渐变位置
    // 第一个颜色开始渐变的位置
    // 第二个颜色结束渐变的位置
    CGFloat locations[2] = {0, 1};
    
    //5. 创建颜色渐进
    gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    //6. 创建贝塞尔路径，是OC的，如果只是制定了渐变，没有指定剪切路径，就是整个视图的渐变
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 340, 100, 100)];
    //7. 添加剪切路径
    [path addClip];
    
    //8. 绘制线性渐进
    CGContextDrawLinearGradient(context, gradient, CGPointMake(10, 340), CGPointMake(110, 440), kCGGradientDrawsAfterEndLocation);
    
    //9. 释放颜色空间
    CGColorSpaceRelease(colorSpace);
    //10. 释放渐变引用
    CGGradientRelease(gradient);
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark - 绘制文本
- (void)setStyleOfTextWithContext:(CGContextRef)context
{
    [[UIColor redColor] set];
}

#pragma mark 方法一 CGRectMake(10, 450, 100, 50)
- (void)drawTextForMethod1WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    [self setStyleOfTextWithContext:context];
    
    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:17];
    
    NSString *text = @"绘制文本！绘制文本！";
    
    CGRect rect = CGRectMake(10, 450, 100, 50);
    [[UIColor blueColor] set];
    UIRectFill(rect);
    
    [text drawInRect:rect withAttributes:@{NSFontAttributeName : font}];

    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark 方法二 CGRectMake(130, 450, 100, 50)
- (void)drawTextForMethod2WithContext:(CGContextRef)context
{
    // 状态保存  填充色、阴影、线条颜色、路径...
    CGContextSaveGState(context);
    [self setStyleOfTextWithContext:context];
    
    UIFont *font = [UIFont fontWithName:@"Marker Felt" size:17];
    
    NSString *text = @"绘制文本二！绘制文本二！";
    
    [text drawAtPoint:CGPointMake(130, 450) withAttributes:@{NSFontAttributeName : font}];
    
    // 状态撤销到保存之前的
    CGContextRestoreGState(context);
}

#pragma mark - 绘制图片 
#pragma mark CGRectMake(10, 560, 50, 50)
- (void)drawImageWithContext:(CGContextRef)context
{
    UIImage *image = [UIImage imageNamed:@"icon"];
    
    // 在指定点绘制
    [image drawAtPoint:CGPointMake(10, 560)];
    // 会拉伸
    [image drawInRect:CGRectMake(60, 560, 50, 50)];
    // 平铺
    [image drawAsPatternInRect:CGRectMake(120, 560, 50, 50)];
}

#pragma mark 添加水印 CGRectMake(190, 560, 80, 80)
- (void)drawWaterMarkForImageWithContext:(CGContextRef)context
{
    // 1. 获得图像相关的上下文
    // 获得图像上下文的时候，需要指定上下文大小
    UIGraphicsBeginImageContext(CGSizeMake(80, 80));
    
    // 2. 绘制图像
    UIImage *image = [UIImage imageNamed:@"icon"];
    [image drawInRect:CGRectMake(0, 0, 100, 100)];
    
    // 3. 写水印文字
    NSString *text = @"水印文字";
    UIColor *color = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.5];
    [color set];
    
    [text drawInRect:CGRectMake(0, 0, 80, 80) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    
    // 从图像上下文中获得当前绘制的结果，并生成图像
    UIImage *result =  UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    
    [result drawInRect:CGRectMake(190, 560, 80, 80)];
}

#pragma mark - 整体context操作
- (void)drawOperateWithContext:(CGContextRef)context
{
    // 取出上下文
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 备份上下文
    CGContextSaveGState(context);
    
    // 对上下文做一个平移操作
    CGContextTranslateCTM(context, 100, 100);
    // 对坐标系进行旋转
    CGContextRotateCTM(context, M_PI_4);
    // 对坐标系进行缩放
    CGContextScaleCTM(context, 0.5, 0.5);
    
    // 恢复上下文
    CGContextRestoreGState(context);
}

@end



























