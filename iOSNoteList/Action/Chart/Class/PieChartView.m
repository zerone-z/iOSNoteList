//
//  PieChartView.m
//  iOSNoteList
//
//  Created by LuPengDa on 14-12-3.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import "PieChartView.h"

#import "CorePlot-CocoaTouch.h"

@interface PieChartView ()<CPTPieChartDataSource, CPTPieChartDelegate>{
    CPTGraphHostingView *_hostView;
    
    NSArray *_sliceFills;
    
    NSInteger _indexOfSelectedSlice;
    
    CGPoint _previousPoint;
}

@end

@implementation PieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sliceFills = @[[CPTColor greenColor],
                        [CPTColor lightGrayColor],
                        [CPTColor cyanColor],
                        [CPTColor yellowColor],
                        [CPTColor magentaColor],
                        [CPTColor purpleColor]];
    }
    return self;
}

#pragma mark - 加载图表
- (void)loadView
{
    if (!_hostView) {
        //按照当前顺序开始绘制图表
        [self createHostView];          //  创建HostView
        [self createGraph];             //  创建图表，用于显示的画布
        [self createPlotSpace];         //  创建绘图空间
        [self createPlots];             //  创建平面图，折线图
        [self createLegend];            //  创建图例
    }
}

#pragma mark 创建宿主HostView
- (void)createHostView
{
    //  图形要放在CPTGraphHostingView宿主中，因为UIView无法加载CPTGraph
    _hostView = [[CPTGraphHostingView alloc] initWithFrame:self.bounds];
    //  默认值：NO，设置未YES可以减少GPU的使用，但是渲染图形的时候会变慢
    _hostView.collapsesLayers = NO;
    //  允许啮合缩放 默认值：YES
    _hostView.allowPinchScaling = YES;
    //  背景色 默认值：clearColor
    _hostView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_hostView];
    
    // 手势添加
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSlice:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSlice:)];
//    tapGesture.delegate = self;
//    tapGesture.delaysTouchesEnded = NO;
    [_hostView addGestureRecognizer:panGesture];
    [_hostView addGestureRecognizer:tapGesture];
}

#pragma mark 创建图表，用于显示的画布
- (void)createGraph
{
    // 基于xy轴的图表创建
    CPTXYGraph *graph=[[CPTXYGraph alloc] initWithFrame:_hostView.bounds];
    // 使宿主视图的hostedGraph与CPTGraph关联
    _hostView.hostedGraph = graph;
    
    // 设置主题，类似于皮肤
    {
        //CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
        //[graph applyTheme:theme];
    }
    
    // 标题设置
    {
        graph.title = @"标题：饼图";
        // 标题对齐于图框的位置，可以用CPTRectAnchor枚举类型，指定标题向图框的4角、4边（中点）对齐标题位置 默认值：CPTRectAnchorTop（顶部居中）
        graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
        // 标题对齐时的偏移距离（相对于titlePlotAreaFrameAnchor的偏移距离）默认值：CGPointZero
        graph.titleDisplacement = CGPointZero;
        // 标题文本样式 默认值：nil
        CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
        textStyle.fontSize = CPTFloat(25);
        textStyle.textAlignment = CPTTextAlignmentLeft;
        graph.titleTextStyle = textStyle;
    }
    
    // CPGGraph内边距，默认值：20.0f
    {
        graph.paddingLeft = CPTFloat(0);
        graph.paddingTop = CPTFloat(0);
        graph.paddingRight = CPTFloat(0);
        graph.paddingBottom = CPTFloat(0);
    }
    
    // CPTPlotAreaFrame绘图区域设置
    {
        // 内边距设置，默认值：0.0f
        graph.plotAreaFrame.paddingLeft = CPTFloat(0);
        graph.plotAreaFrame.paddingTop = CPTFloat(0);
        graph.plotAreaFrame.paddingRight = CPTFloat(0);
        graph.plotAreaFrame.paddingBottom = CPTFloat(0);
        // 边框样式设置 默认值：nil
        graph.plotAreaFrame.borderLineStyle=nil;
    }
    
    // 饼图不需要显示坐标轴
    graph.axisSet = nil;
}

#pragma mark 创建绘图空间
- (void)createPlotSpace
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)_hostView.hostedGraph.defaultPlotSpace;
    // 绘图空间是否允许与用户交互 默认值：NO
    plotSpace.allowsUserInteraction = YES;
    
    //设置移动时的停止动画
    {
        // 这些参数保持默认即可  变化不大
        plotSpace.allowsMomentum = YES;
        plotSpace.momentumAnimationCurve = CPTAnimationCurveCubicIn;
        plotSpace.bounceAnimationCurve = CPTAnimationCurveBackIn;
        plotSpace.momentumAcceleration = 20000.0;
    }
    
    // 可显示大小 一屏内横轴／纵轴的显示范围
    {
        // 横轴
        {
            // location表示坐标的显示起始值，length表示要显示的长度 类似于NSRange
            CPTMutablePlotRange *xRange = [CPTMutablePlotRange plotRangeWithLocation:@(-1) length:@(1)];
            // 横轴显示的收缩／扩大范围 1：不改变  <1:收缩范围  >1:扩大范围
            [xRange expandRangeByFactor:@(1)];
            
            plotSpace.xRange = xRange;
        }
        
        // 纵轴
        {
            CPTMutablePlotRange *yRange = [CPTMutablePlotRange plotRangeWithLocation:@(-1) length:@(1)];
            [yRange expandRangeByFactor:@(1)];
            
            plotSpace.yRange = yRange;
        }
    }
    
    // 绘图空间的最大显示空间，滚动范围
    {
        CPTMutablePlotRange *xGlobalRange = [CPTMutablePlotRange plotRangeWithLocation:@(-2) length:@(2)];
        
        CPTMutablePlotRange *yGlobalRange = [CPTMutablePlotRange plotRangeWithLocation:@(-2) length:@(2)];
        
        plotSpace.globalXRange = xGlobalRange;
        plotSpace.globalYRange = yGlobalRange;
    }
}

#pragma mark 创建平面图，饼图
- (void)createPlots
{
    // 饼图初始化
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    
    // 添加图形到绘图空间
    [_hostView.hostedGraph addPlot:piePlot];
    
    // 标识,根据此@ref identifier来区分不同的plot
    piePlot.identifier = @"PieChart";
    
    // 指定饼图的数据源。数据源必须实现 CPTPieDataSource 委托
    piePlot.dataSource = self;
    
    // 指定饼图的事件委托。委托必须实现 CPTPieChartDelegate 中定义的方法
    piePlot.delegate = self;
    
    // 饼图设置
    {
        // 饼图的半径
        piePlot.pieRadius = CPTFloat(200);
        // 内部圆
        piePlot.pieInnerRadius = CPTFloat(10);
        // 开始绘制的位置，第1片扇形的起始角度，默认是PI/2
        piePlot.startAngle = 0;
        // 绘制的方向：正时针、反时针
        piePlot.sliceDirection = CPTPieDirectionClockwise;
        // 边线的样式
        piePlot.borderLineStyle= nil;
        // 饼图的重心（旋转时以此为中心）坐标（x,y），以相对于饼图直径的比例表示（0－1）之间。默认和圆心重叠（0.5,0.5）
        piePlot.centerAnchor = CGPointMake(0.5, 0.5);
        
        // 覆盖色
        //CPTGradient *gradient = [[CPTGradient alloc]init];
        // 剃度效果
        //gradient.gradientType = CPTGradientTypeRadial;
        // 设置颜色变换的颜色和位置
        //gradient = [gradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.1] atPosition:0.9];
        //gradient = [gradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.5] atPosition:0.5];
        //gradient = [gradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.3] atPosition:0.9];
        //piePlot.overlayFill = [CPTFill fillWithGradient:gradient];
    }
    
    // 扇形上的标签文字设置
    {
        // 是否顺着扇形的方向
        piePlot.labelRotationRelativeToRadius = YES;
        // 偏移量
        piePlot.labelOffset = -(piePlot.pieRadius - piePlot.pieInnerRadius) * 0.6;
    }
    
    // 添加动画
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 3.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeForwards;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    piePlot.opacity = 0.f;
    [piePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
}

#pragma mark 创建图例
- (void)createLegend
{
    // 图例初始化
    CPTLegend *legend = [CPTLegend legendWithGraph:_hostView.hostedGraph];
    // 图例的列数。有时图例太多，单列显示太长，可分为多列显示
    legend.numberOfColumns = 1;
    // 图例外框的线条样式
    legend.borderLineStyle = nil;
    // 图例的填充属性，CPTFill 类型
    legend.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    // 图例中每个样本的大小
    legend.swatchSize = CGSizeMake(40, 10);
    // 图例中每个样本的文本样式
    CPTMutableTextStyle *titleTextStyle = [CPTMutableTextStyle textStyle];
    titleTextStyle.color = [CPTColor blackColor];
    titleTextStyle.fontName = @"Helvetica-Bold";
    titleTextStyle.fontSize = 13;
    legend.textStyle = titleTextStyle;
    
    // 把图例于图表关联起来
    _hostView.hostedGraph.legend = legend;
    // 图例对齐于图框的位置，可以用 CPTRectAnchor 枚举类型，指定图例向图框的4角、4边（中点）对齐，默认值：CPTRectAnchorBottom（底部居中）
    _hostView.hostedGraph.legendAnchor = CPTRectAnchorTopRight;
    // 图例对齐时的偏移距离（相对于legendAnchor的偏移距离），默认值：CGPointZeor
    _hostView.hostedGraph.legendDisplacement = CGPointMake(-10, 0);
}

#pragma mark - CPTPieChartDataSource
#pragma mark 询问有多少个扇形
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.dataSource.count;
}

#pragma mark 询问扇形的数据值
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSNumber *num = self.dataSource[idx];
    return num;
}

#pragma mark 扇形颜色
- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    CPTFill *color = [CPTFill fillWithColor:_sliceFills[idx]];
    return color;
}

#pragma mark 扇形名称
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"饼图-%d",(int)(idx + 1)]];
    
    CPTMutableTextStyle *textStyle =[label.textStyle mutableCopy];
    textStyle.color = [CPTColor blackColor];
    textStyle.fontSize = CPTFloat(17);
    
    label.textStyle = textStyle;
    
    return label;
}

#pragma mark 剥离扇形
- (CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    return idx == 2 ? 10 : 0;
}

#pragma mark 图例名称 返回nil则该索引下的图例不显示
- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    NSString *legendTitle = [NSString stringWithFormat:@"饼图-%d",(int)(idx + 1)];
    return legendTitle;
}

#pragma mark - CPTPieChartDelegate
#pragma mark 选中扇形的操作
- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(UIEvent *)event
{
    _indexOfSelectedSlice = idx;
}

#pragma mark - GestureRecognizer
#pragma mark 拖动手势
- (void)panSlice:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            _previousPoint = [sender locationInView:_hostView];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            // 转动角度计算
            CGFloat previousAngle = [self angleOfPieChartFromPoint:_previousPoint];
            CGPoint currentPoint = [sender locationInView:_hostView];
            CGFloat currentAngle = [self angleOfPieChartFromPoint:currentPoint];
            
            // 获取饼图
            CPTPieChart *piePlot = (CPTPieChart *)[_hostView.hostedGraph plotWithIdentifier:@"PieChart"];
            // 起始弧度设置
            piePlot.startAngle += (currentAngle - previousAngle);
            
            _previousPoint = currentPoint;
            
            // 计算0弧度下的扇形索引
            _indexOfSelectedSlice = [piePlot pieSliceIndexAtAngle:0];
        }
            break;
        default:
        {
            // 获取饼图
            CPTPieChart *piePlot = (CPTPieChart *)[_hostView.hostedGraph plotWithIdentifier:@"PieChart"];
            // 获取该索引下扇形的中间的弧度
            CGFloat medianAngle = [piePlot medianAngleForPieSliceIndex:_indexOfSelectedSlice];
            // 起始弧度设置
            piePlot.startAngle -= medianAngle;
        }
            break;
    }
}

#pragma mark 轻拍手势
- (void)tapSlice:(UITapGestureRecognizer *)sender
{
    // 获取饼图
    CPTPieChart *piePlot = (CPTPieChart *)[_hostView.hostedGraph plotWithIdentifier:@"PieChart"];
    // 获取该索引下扇形的中间的弧度
    CGFloat medianAngle = [piePlot medianAngleForPieSliceIndex:_indexOfSelectedSlice];
    
    // 动画设置
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"startAngle"];
    rotation.removedOnCompletion = YES;
    rotation.toValue             = [NSNumber numberWithDouble:(piePlot.startAngle - medianAngle)];
    rotation.duration            = 1.0;
    rotation.fillMode            = kCAFillModeForwards;
    rotation.delegate            = self;
    [piePlot addAnimation:rotation forKey:@"startAnglexxx"];
}

#pragma mark - method
#pragma mark 计算坐标点相对与饼图重心的弧度
- (CGFloat)angleOfPieChartFromPoint:(CGPoint)point
{
    CPTPieChart *piePlot = (CPTPieChart *)[_hostView.hostedGraph plotWithIdentifier:@"PieChart"];
    // 饼图重心坐标
    CGFloat centerX = piePlot.centerAnchor.x * CGRectGetWidth(_hostView.bounds);
    CGFloat centerY = piePlot.centerAnchor.y * CGRectGetHeight(_hostView.bounds);
    
    // 当前坐标点相对于重心的坐标
    CGFloat nextX = point.x - centerX;
    CGFloat nextY = centerY - point.y;
    
    // 求弧度
    CGFloat nextAngle = asinf(nextY/sqrt(nextY * nextY + nextX *nextX));
    
    if (nextX < 0) {
        nextAngle = M_PI - nextAngle;
    }
    return nextAngle;
}

#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CABasicAnimation *rotation = (CABasicAnimation *)anim;
    // 获取饼图
    CPTPieChart *piePlot = (CPTPieChart *)[_hostView.hostedGraph plotWithIdentifier:@"PieChart"];
    // 起始弧度设置
    piePlot.startAngle = [rotation.toValue floatValue];
}

@end
