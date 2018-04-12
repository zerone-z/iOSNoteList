//
//  BarView.m
//  iOSNoteList
//
//  Created by LuPengDa on 14-12-2.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import "BarChartView.h"

#import "CorePlot-CocoaTouch.h"

@interface BarChartView ()<CPTBarPlotDataSource,CPTBarPlotDelegate>{
    CPTGraphHostingView *_hostView;     ///< 宿主View
    
    NSArray *_coordinatesX;             ///< X轴坐标
}

@end

@implementation BarChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coordinatesX = @[@"第一次",@"第二次",@"第三次",@"第四次",@"第五次",@"第六次",@"第七次",@"第八次",@"第九次",@"第十次"];
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
        [self createAxis];              //  创建坐标
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
        graph.title = @"标题：柱状图";
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
            CPTMutablePlotRange *xRange = [CPTMutablePlotRange plotRangeWithLocation:@(-1) length:@(_coordinatesX.count + 3)];
            // 横轴显示的收缩／扩大范围 1：不改变  <1:收缩范围  >1:扩大范围
            [xRange expandRangeByFactor:@(1)];
            
            plotSpace.xRange = xRange;
        }
        
        // 纵轴
        {
            CPTMutablePlotRange *yRange = [CPTMutablePlotRange plotRangeWithLocation:@(-1) length:@(11)];
            [yRange expandRangeByFactor:@(1)];
            
            plotSpace.yRange = yRange;
        }
    }
    
    // 绘图空间的最大显示空间，滚动范围
    {
        CPTMutablePlotRange *xGlobalRange = [CPTMutablePlotRange plotRangeWithLocation:@(-2) length:@(_coordinatesX.count + 5)];
        
        CPTMutablePlotRange *yGlobalRange = [CPTMutablePlotRange plotRangeWithLocation:@(-2) length:@(16)];
        
        plotSpace.globalXRange = xGlobalRange;
        plotSpace.globalYRange = yGlobalRange;
    }
}

#pragma mark 创建坐标
- (void)createAxis
{
    // 轴线样式
    CPTMutableLineStyle *axisLineStyle = [[CPTMutableLineStyle alloc] init];
    axisLineStyle.lineWidth = CPTFloat(1);
    axisLineStyle.lineColor = [CPTColor blackColor];
    
    // 标题样式
    CPTMutableTextStyle *titelStyle = [CPTMutableTextStyle textStyle];
    titelStyle.color = [CPTColor redColor];
    titelStyle.fontSize = CPTFloat(20);
    
    // 主刻度线样式
    CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineColor = [CPTColor purpleColor];
    
    // 细分刻度线样式
    CPTMutableLineStyle *minorLineStyle = [CPTMutableLineStyle lineStyle];
    minorLineStyle.lineColor = [CPTColor blueColor];
    
    // 轴标签样式
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blueColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = CPTFloat(11);
    
    // 轴标签样式
    CPTMutableTextStyle *axisLabelTextStyle = [[CPTMutableTextStyle alloc] init];
    axisLabelTextStyle.color=[CPTColor greenColor];
    axisLabelTextStyle.fontSize = CPTFloat(17);
    
    // 坐标系
    CPTXYAxisSet *axis = (CPTXYAxisSet *)_hostView.hostedGraph.axisSet;
    
    //X轴设置
    {
        // 获取X轴线
        CPTXYAxis *xAxis = axis.xAxis;
        
        // 轴线设置
        xAxis.axisLineStyle = axisLineStyle;
        
        // 显示的刻度范围 默认值：nil
        xAxis.visibleRange=[CPTPlotRange plotRangeWithLocation:@(0) length:@(_coordinatesX.count + 1)];
        
        // 标题设置
        {
            xAxis.title =@ "X轴";
            // 文本样式
            xAxis.titleTextStyle = titelStyle;
            // 位置 与刻度有关,
            xAxis.titleLocation = @(2);
            // 方向设置
            xAxis.titleDirection = CPTSignNegative;
            // 偏移量,在方向上的偏移量
            xAxis.titleOffset = CPTFloat(25);
        }
        
        // 位置设置
        {
            // 固定坐标 默认值：nil
            //xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:50.0];
            // 坐标原点所在位置，默认值：@(0)（在Y轴的0点位置）
            xAxis.orthogonalPosition = @(0);
        }
        
        // 主刻度线设置
        {
            // X轴大刻度线，线型设置
            xAxis.majorTickLineStyle = majorLineStyle;
            // 刻度线的长度
            xAxis.majorTickLength = CPTFloat(5);
            // 刻度线位置
            NSMutableSet *majorTickLocations =[NSMutableSet setWithCapacity:(_coordinatesX.count + 1)];
            for (int i= 0 ;i< _coordinatesX.count + 1 ;i++) {
                [majorTickLocations addObject:[NSNumber numberWithInt:(i)]];
            }
            xAxis.majorTickLocations = majorTickLocations;
        }
        
        // 细分刻度线设置
        {
            // 刻度线的长度
            xAxis.minorTickLength = CPTFloat(3);
            // 刻度线样式
            xAxis.minorTickLineStyle = minorLineStyle;
            // 刻度线位置
            NSInteger minorTicksPerInterval = 3;
            CGFloat minorIntervalLength = CPTFloat(1) / CPTFloat(minorTicksPerInterval + 1);
            NSMutableSet *minorTickLocations =[NSMutableSet setWithCapacity:(_coordinatesX.count + 1) * minorTicksPerInterval];
            for (int i= 0 ;i< _coordinatesX.count + 1;i++) {
                for (int j = 0; j < minorTicksPerInterval; j++) {
                    [minorTickLocations addObject:[NSNumber numberWithFloat:(i + minorIntervalLength * (j + 1))]];
                }
            }
            xAxis.minorTickLocations = minorTickLocations;
        }
        
        // 网格线设置
        {
            //xAxis.majorGridLineStyle = majorLineStyle;
            //xAxis.minorGridLineStyle = minorLineStyle;
            //xAxis.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(9)];
        }
        
        // 轴标签设置
        {
            //清除默认的方案，使用自定义的轴标签、刻度线；
            xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
            // 轴标签偏移量
            xAxis.labelOffset = 0.f;
            // 轴标签样式
            xAxis.labelTextStyle = axisTextStyle;
            
            // 存放自定义的轴标签
            NSMutableSet *xAxisLabels = [NSMutableSet setWithCapacity:_coordinatesX.count];
            CPTAxisLabel *emptyLabel = [[CPTAxisLabel alloc] initWithText:nil textStyle:axisLabelTextStyle];
            [xAxisLabels addObject:emptyLabel];
            for ( int i= 0 ;i< _coordinatesX.count ;i++) {
                CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:_coordinatesX[i] textStyle:axisLabelTextStyle];
                // 刻度线的位置
                newLabel.tickLocation = @(i + 1);
                newLabel.offset = xAxis.labelOffset + xAxis.majorTickLength;
                newLabel.rotation = M_PI_4;
                [xAxisLabels addObject :newLabel];
            }
            xAxis.axisLabels = xAxisLabels;
        }
    }
    
    //Y轴设置
    {
        // 获取Y轴坐标
        CPTXYAxis *yAxis = axis.yAxis;
        
        // 委托事件
        yAxis.delegate = self;
        
        //轴线样式
        yAxis.axisLineStyle = axisLineStyle;
        
        //显示的刻度
        yAxis.visibleRange = [CPTPlotRange plotRangeWithLocation:@(0.0f) length:@(9)];
        
        // 标题设置
        {
            yAxis.title = @"Y轴";
            // 文本样式
            yAxis.titleTextStyle = titelStyle;
            // 位置 与刻度有关,
            yAxis.titleLocation = @(2.4);
            // 方向设置
            yAxis.titleDirection = CPTSignNegative;
            // 偏移量,在方向上的偏移量
            yAxis.titleOffset = CPTFloat(18);
            // 旋转方向
            yAxis.titleRotation = CPTFloat(M_PI_2);
        }
        
        // 位置设置
        {
            // 获取X轴原点即0点的坐标
            CPTXYAxis *xAxis = axis.xAxis;
            CGPoint zeroPoint = [xAxis viewPointForCoordinateValue:@(0)];
            
            // 固定坐标 默认值：nil
            yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:CPTFloat(zeroPoint.x)];
            
            // 坐标原点所在位置，默认值：CPTDecimalFromInteger(0)（在X轴的0点位置）
            //yAxis.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0);
        }
        
        // 主刻度线设置
        {
            // 显示数字标签的量度间隔
            yAxis.majorIntervalLength = @(1);
            // 刻度线，线型设置
            yAxis.majorTickLineStyle = majorLineStyle;
            // 刻度线的长度
            yAxis.majorTickLength = 6;
        }
        
        // 细分刻度线设置
        {
            // 每一个主刻度范围内显示细分刻度的个数
            yAxis.minorTicksPerInterval = 5;
            // 刻度线的长度
            yAxis.minorTickLength = CPTFloat(3);
            // 刻度线，线型设置
            yAxis.minorTickLineStyle = minorLineStyle;
        }
        
        // 网格线设置 默认不显示
        {
            //yAxis.majorGridLineStyle = majorLineStyle;
            //yAxis.minorGridLineStyle = minorLineStyle;
            //yAxis.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(_coordinatesY.count)];
        }
        
        // 轴标签设置
        {
            // 轴标签偏移量
            yAxis.labelOffset = CPTFloat(5);
            // 轴标签样式
            yAxis.labelTextStyle = axisTextStyle;
            
            // 排除不显示的标签
            NSArray *exclusionRanges = [NSArray arrayWithObjects:
                                        [CPTPlotRange plotRangeWithLocation:@(0.99) length:@(0.02)],
                                        [CPTPlotRange plotRangeWithLocation:@(2.99) length:@(0.02)],
                                        nil];
            yAxis.labelExclusionRanges = exclusionRanges;
            
            // 因为没有清除默认的方案（CPTAxisLabelingPolicyNone）,如果想要自定义轴标签，需实现委托方法
        }
    }
}

#pragma mark 创建平面图，柱状图
- (void)createPlots
{
    // 第一个柱状图
    {
        // 第一个参数指定渐变色的开始颜色，默认结束颜色为黑色，第二个参数指定是否绘制水平柱子。
        CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
        
        // 添加图形到绘图空间
        [_hostView.hostedGraph addPlot:barPlot];
        
        // 设置数据源 实现CPTBarPlotDataSource委托
        barPlot.dataSource = self;
        
        // 委托事件
        barPlot.delegate = self;
        
        // 标识,根据此@ref identifier来区分不同的plot,也是图例显示名称,
        barPlot.identifier = @"BarPlot1" ;
        
        // 基线值设置
        {
            // NO：@ref baseValue的设置对所有的柱子生效，YES：需要通过数据源设置每一个柱子的@ref baseValue  默认值：NO
            barPlot.barBasesVary = YES;
            // 柱子的基线值 @ref barBasesVary为NO时才会生效，否则需要在数据源中设置枚举为CPTBarPlotFieldBarBase的一个适当的值
            // 柱子都是从此基线值处开始绘制，相当于原点
            barPlot.baseValue = @(1);
        }
        
        // 柱子设置，柱子的实际宽度为@ref barWidth * barWidthScale
        {
            // 宽度计算方式 NO：1主刻度长度＝1宽度  YES：1像素＝1宽度  默认值：NO
            barPlot.barWidthsAreInViewCoordinates = YES;
            // 宽度
            barPlot.barWidth = @(20);
            // 开始绘制的偏移位置，默认为0，表示柱子的中间位置在刻度线上
            barPlot.barOffset = @(-10) ;
            // 尖端的圆角值 用的是像素单位
            barPlot.barCornerRadius = CPTFloat(0);
            // 底部的圆角值，基线值的圆角 用的是像素单位
            barPlot.barBaseCornerRadius = CPTFloat(0);
            // 外框的线型 默认：黑色 宽度1
            barPlot.lineStyle = nil;
            // 填充色
            CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor greenColor] endingColor:[CPTColor clearColor]];
            CPTFill *fill = [CPTFill fillWithGradient:gradient];
            barPlot.fill = fill;
        }
        
        // 数据标签设置，如果想用自定义的标签，则需要数据源方法：dataLabelForPlot:recordIndex:
        {
            // 偏移量设置
            barPlot.labelOffset = 15;
            // 数据标签样式
            CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
            labelTextStyle.color = [CPTColor magentaColor];
            barPlot.labelTextStyle = labelTextStyle;
        }
        
        // 添加动画
        barPlot.opacity = 0.f;
        
        // 动画
        CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnimation.duration            = 3.0f;
        fadeInAnimation.removedOnCompletion = NO;
        fadeInAnimation.fillMode            = kCAFillModeForwards;
        fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
        [barPlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
        
    }
    
    // 第2个柱状图
    {
        // 第一个参数指定渐变色的开始颜色，默认结束颜色为黑色，第二个参数指定是否绘制水平柱子。
        CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        
        // 添加图形到绘图空间
        [_hostView.hostedGraph addPlot:barPlot];
        
        // 设置数据源 实现CPTBarPlotDataSource委托
        barPlot.dataSource = self;
        
        // 标识,根据此@ref identifier来区分不同的plot,也是图例显示名称,
        barPlot.identifier = @"BarPlot2" ;
        
        // 基线值设置
        {
            // NO：@ref baseValue的设置对所有的柱子生效，YES：需要通过数据源设置每一个柱子的@ref baseValue  默认值：NO
            barPlot.barBasesVary = NO;
            // 柱子的基线值 @ref barBasesVary为NO时才会生效，否则需要在数据源中设置枚举为CPTBarPlotFieldBarBase的一个适当的值
            // 大于这个值以上的点，柱子只从这个点开始画。小于此值的点，则是反向绘制的，即从基线值向下画，一直画到到数据点。
            barPlot.baseValue = @(0);
        }
        
        // 柱子设置
        {
            // 宽度计算方式 NO：1主刻度长度＝1宽度  YES：1像素＝1宽度  默认值：NO
            barPlot.barWidthsAreInViewCoordinates = NO;
            // 宽度
            barPlot.barWidth = @(0.4);
            // 开始绘制的偏移位置
            barPlot.barOffset = @(0.2) ;
            // 尖端的圆角值 用的是像素单位
            barPlot.barCornerRadius = CPTFloat(0);
            // 底部的圆角值，基线值的圆角 用的是像素单位
            barPlot.barBaseCornerRadius = CPTFloat(0);
            // 外框的线型 默认：黑色 宽度1
            barPlot.lineStyle = nil;
            // 填充色
            CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor blueColor] endingColor:[CPTColor clearColor]];
            CPTFill *fill = [CPTFill fillWithGradient:gradient];
            barPlot.fill = fill;
        }
        
        // 数据标签设置，如果想用自定义的标签，则需要数据源方法：dataLabelForPlot:recordIndex:
        {
            // 偏移量设置
            barPlot.labelOffset = 15;
            // 数据标签样式
            CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
            labelTextStyle.color = [CPTColor magentaColor];
            barPlot.labelTextStyle = labelTextStyle;
        }
        
        
        // 添加动画
        {
            // 锚点设置
            CPTXYAxisSet *axis = (CPTXYAxisSet *)_hostView.hostedGraph.axisSet;
            CGPoint point = [axis.yAxis viewPointForCoordinateValue:@(0)];
            CGFloat y = point.y/CGRectGetHeight(_hostView.frame);
            barPlot.anchorPoint = CGPointMake(0.5, y);
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
            [anim setDuration:2.0f];
            anim.toValue = [NSNumber numberWithFloat:1.0f];
            anim.fromValue = [NSNumber numberWithFloat:0.0f];
            anim.removedOnCompletion = NO;
            anim.delegate = self;
            anim.fillMode = kCAFillModeForwards;
            [barPlot addAnimation:anim forKey:@"grow"];
        }
    }
}

#pragma mark 创建图例
- (void)createLegend
{
    // 图例样式设置
    NSMutableArray *plots = [NSMutableArray array];
    for (int i = 0; i < _hostView.hostedGraph.allPlots.count; i++) {
        CPTBarPlot *barPlot = _hostView.hostedGraph.allPlots[i];
        
        CPTBarPlot *plot = [[CPTBarPlot alloc] init];
        plot.fill = barPlot.fill;
        plot.lineStyle = barPlot.lineStyle;
        plot.identifier = [NSString stringWithFormat:@"柱状图%d", (i + 1)];
        [plots addObject:plot];
    }
    // 图例初始化 只有把plots 替换为 _hostView.hostedGraph.allPlots 数据源方法的设置图例名称才会生效
    CPTLegend *legend = [CPTLegend legendWithPlots:plots];
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

#pragma mark - CPTPlotDataSource
#pragma mark 询问有多少个数据
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger count = 0;
    if ([plot.identifier isEqual:@"BarPlot1"]) {
        count = self.dataSource1.count;
    }else {
        count = self.dataSource2.count;
    }
    
    return count;
}

#pragma mark 询问一个个数据值 fieldEnum:一个轴类型，是一个枚举  idx：坐标轴索引
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSNumber *num = nil;
    
    if ([plot.identifier isEqual:@"BarPlot1"]) {
        switch (fieldEnum) {
            case CPTBarPlotFieldBarLocation:            // 柱子所处位置 如果是垂直柱子，即为x轴的位置
            {
                num = @(idx + 1);
            }
                break;
            case CPTBarPlotFieldBarTip:                 // 柱子尖端位置（柱子的长度） 如果是垂直柱子，即为y轴的位置
            {
                num = self.dataSource1[idx];
            }
                break;
            case CPTBarPlotFieldBarBase:                // 柱子的基线值 只有@ref barBasesVary = YES 时才会用到该枚举
            {
                num = @(0);
            }
                break;
            default:
                break;
        }
    }else if ([plot.identifier isEqual:@"BarPlot2"]){
        switch (fieldEnum) {
            case CPTBarPlotFieldBarLocation:            // 柱子所处位置 如果是垂直柱子，即为x轴的位置
            {
                num = @(idx + 1);
            }
                break;
            case CPTBarPlotFieldBarTip:                 // 柱子末端位置（柱子的长度） 如果是垂直柱子，即为y轴的位置
            {
                num = self.dataSource2[idx];
            }
                break;
            case CPTBarPlotFieldBarBase:                // 柱子的基线值 只有@ref barBasesVary = YES 时才会用到该枚举
            {
                
            }
                break;
            default:
                break;
        }
    }
    return num;
}

#pragma mark 添加数据标签
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    if ([plot.identifier isEqual:@"BarPlot1"]) {
        // 数据标签样式
        CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
        labelTextStyle.color = [CPTColor magentaColor];
        
        // 定义一个 TextLayer
        CPTTextLayer *newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d",(int)[self.dataSource1[idx] integerValue]] style:labelTextStyle];
        
        return newLayer;
    }else {
        // 数据标签样式
        CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
        labelTextStyle.color = [CPTColor magentaColor];
        
        // 定义一个 TextLayer
        CPTTextLayer *newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d",(int)[self.dataSource2[idx] integerValue]] style:labelTextStyle];
        
        return newLayer;
    }
}

#pragma mark 设置图例名称 返回每一个柱子的图例名称 返回nil则该索引下的图例不显示
- (NSString *)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx
{
    NSString *legendTitle = nil;
    if ([barPlot.identifier isEqual:@"BarPlot1"]) {
        legendTitle = [NSString stringWithFormat:@"柱状图1-%d",idx];
    }else {
        legendTitle = [NSString stringWithFormat:@"柱状图2-%d",idx];
    }
    return legendTitle;
}

#pragma mark - CPTBarPlotDelegate
#pragma mark 选中某个柱子的操作 添加注释
- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(UIEvent *)event
{
    // 移除注释
    CPTPlotArea *plotArea = _hostView.hostedGraph.plotAreaFrame.plotArea;
    [plotArea removeAllAnnotations];
    
    // 创建注释，plotSpace：绘图空间 anchorPlotPoint：坐标点
    CPTPlotSpaceAnnotation *barTextAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:_hostView.hostedGraph.defaultPlotSpace anchorPlotPoint:@[@(idx + 1),self.dataSource1[idx]]];
    
    // 文本样式
    CPTMutableTextStyle *annotationTextStyle = [CPTMutableTextStyle textStyle];
    annotationTextStyle.color = [CPTColor redColor];
    annotationTextStyle.fontSize = 17.0f;
    annotationTextStyle.fontName = @"Helvetica-Bold";
    // 显示的字符串
    NSString *randomValue = [NSString stringWithFormat:@"柱状图\n随即值：%@ \n", [self.dataSource1[idx] stringValue]];
    // 注释内容
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:randomValue style:annotationTextStyle];
    // 添加注释内容
    barTextAnnotation.contentLayer = textLayer;
    
    // 注释位置
    barTextAnnotation.displacement = CGPointMake(CPTFloat(0), CPTFloat(20));
    
    // 把拐点注释添加到绘图区域中
    [plotArea addAnnotation:barTextAnnotation];
}

@end
