//
//  ScatterView.m
//  iOSNoteList
//
//  Created by LuPengDa on 14-11-21.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import "ScatterChartView.h"

#import "TouchView.h"

#import "CorePlot-CocoaTouch.h"

@interface ScatterChartView ()<CPTScatterPlotDelegate,CPTScatterPlotDelegate,CPTAxisDelegate,CPTPlotSpaceDelegate,TouchViewDelegate>{
    CPTGraphHostingView *_hostView;     ///< 宿主view
    
    CPTScatterPlot *_beginPlot;         ///< 滑动折线 开始的折线
    CPTScatterPlot *_middlePlot;        ///< 滑动折线 中部的折线
    CPTScatterPlot *_endPlot;           ///< 滑动折线 结尾的折线
    
    NSNumber *_beginIndex;              ///< 滑动折线 开始X坐标
    NSNumber *_endIndex;                ///< 滑动折线 结束X坐标
    
    NSArray *_coordinatesX;             ///< x轴的坐标名称
}

/**
 *  获取最靠近坐标点的X坐标
 *
 *  @param point 坐标点
 *
 *  @return x的坐标点
 */
- (NSInteger)getXCoordinateFromPoint:(CGPoint)point;

@end
@implementation ScatterChartView

- (instancetype)initWithFrame:(CGRect)frame
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
        
        [self createDraggedPlot];       //  创建滑动折线
    }
}

#pragma mark 创建宿主HostView
- (void)createHostView
{
    //  图形要放在CPTGraphHostingView宿主中，因为UIView无法加载CPTGraph
    _hostView = [[CPTGraphHostingView alloc] initWithFrame:self.bounds];
    //  默认值：NO，设置为YES可以减少GPU的使用，但是渲染图形的时候会变慢
    _hostView.collapsesLayers = NO;
    //  允许捏合缩放 默认值：YES
    _hostView.allowPinchScaling = NO;
    //  背景色 默认值：clearColor
    _hostView.backgroundColor = [UIColor whiteColor];
    
    // 添加到View中
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
        graph.title = @"标题：曲线图";
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
    // 委托事件
    plotSpace.delegate = self;
    
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
            CPTMutablePlotRange *xRange = [CPTMutablePlotRange plotRangeWithLocation:@(-1) length:@(_coordinatesX.count + 1)];
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
        xAxis.visibleRange=[CPTPlotRange plotRangeWithLocation:@(0) length:@(_coordinatesX.count - 1)];
        
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
            NSMutableSet *majorTickLocations =[NSMutableSet setWithCapacity:_coordinatesX.count];
            for (int i= 0 ;i< _coordinatesX.count ;i++) {
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
            NSMutableSet *minorTickLocations =[NSMutableSet setWithCapacity:(_coordinatesX.count - 1) * minorTicksPerInterval];
            for (int i= 0 ;i< _coordinatesX.count - 1;i++) {
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
            for ( int i= 0 ;i< _coordinatesX.count ;i++) {
                CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:_coordinatesX[i] textStyle:axisLabelTextStyle];
                // 刻度线的位置
                newLabel.tickLocation = @(i);
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
        
        // 背景色
        yAxis.alternatingBandFills = @[[CPTColor colorWithComponentRed:0.910 green:0.933 blue:0.969 alpha:1.000],
                                       [CPTColor colorWithComponentRed:0.910 green:0.933 blue:0.969 alpha:1.000]];
        
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
            // 显示数字标签的量度间隔（在原主刻度的倍数上才会显示刻度线）
            yAxis.majorIntervalLength = @(3);
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

#pragma mark 创建平面图，折线图
- (void)createPlots
{
    // 创建折线图
    CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] init];
    
    // 添加图形到绘图空间
    [_hostView.hostedGraph addPlot:scatterPlot];
    
    // 标识,根据此@ref identifier来区分不同的plot,也是图例显示名称,
    scatterPlot.identifier = @"scatter";
    
    // 设定数据源，需应用CPTScatterPlotDelegate协议
    scatterPlot.dataSource = self;
    
    // 委托事件
    scatterPlot.delegate = self;
    
    // 线性显示方式设置 默认值：CPTScatterPlotInterpolationLinear（折线图）
    // CPTScatterPlotInterpolationCurved（曲线图）
    // CPTScatterPlotInterpolationStepped／CPTScatterPlotInterpolationHistogram（直方图）
    scatterPlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    // 数据标签设置，如果想用自定义的标签，则需要数据源方法：dataLabelForPlot:recordIndex:
    {
        // 偏移量设置
        scatterPlot.labelOffset = 15;
        // 数据标签样式
        CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
        labelTextStyle.color = [CPTColor magentaColor];
        scatterPlot.labelTextStyle = labelTextStyle;
    }
    
    // 线条样式设置
    {
        CPTMutableLineStyle * scatterLineStyle = [[ CPTMutableLineStyle alloc ] init];
        scatterLineStyle.lineColor = [CPTColor blackColor];
        scatterLineStyle.lineWidth = 3;
        // 破折线
        scatterLineStyle.dashPattern = @[@(10.0),@(5.0)];
        
        // 如果设置为nil则为散点图
        scatterPlot.dataLineStyle = scatterLineStyle;
    }
    
    // 添加拐点
    {
        // 符号类型：椭圆
        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        // 符号大小
        plotSymbol.size = CPTSizeMake(8.0f, 8.f);
        // 符号填充色
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
        // 边框设置
        CPTMutableLineStyle *symboLineStyle = [[ CPTMutableLineStyle alloc ] init];
        symboLineStyle.lineColor = [CPTColor blackColor];
        symboLineStyle.lineWidth = 3;
        plotSymbol.lineStyle = symboLineStyle;
        
        // 向图形上加入符号
        scatterPlot.plotSymbol = plotSymbol;
        
        // 设置拐点的外沿范围，以用来扩大检测手指的触摸范围
        scatterPlot.plotSymbolMarginForHitDetection = CPTFloat(5);
        
    }
    
    // 创建渐变区
    {
        // 创建一个颜色渐变：从渐变色BeginningColor渐变到色endingColor
        CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:[CPTColor blueColor] endingColor:[CPTColor clearColor]];
        // 渐变角度：-90 度（顺时针旋转）
        areaGradient.angle = -90.0f ;
        // 创建一个颜色填充：以颜色渐变进行填充
        CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
        // 为图形设置渐变区
        scatterPlot.areaFill = areaGradientFill;
        // 渐变区起始值，小于这个值的图形区域不再填充渐变色
        scatterPlot.areaBaseValue = @(0.0);
    }
    
    // 显示动画
    {
        scatterPlot.opacity = 0.0f;
        CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnimation.duration            = 3.0f;
        fadeInAnimation.removedOnCompletion = NO;
        fadeInAnimation.fillMode            = kCAFillModeForwards;
        fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
        [scatterPlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    }
}

#pragma mark 创建图例
- (void)createLegend
{
    // 图例样式设置
    NSMutableArray *plots = [NSMutableArray array];
    for (int i = 0; i < _hostView.hostedGraph.allPlots.count; i++) {
        CPTScatterPlot *scatterPlot = _hostView.hostedGraph.allPlots[i];
        
        CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
        plot.dataLineStyle = scatterPlot.dataLineStyle;
        plot.plotSymbol = scatterPlot.plotSymbol;
        plot.identifier = @"曲线图";
        [plots addObject:plot];
    }
    // 图例初始化
    CPTLegend *legend = [CPTLegend legendWithPlots:_hostView.hostedGraph.allPlots];
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

#pragma mark 创建滑动折线
- (void)createDraggedPlot
{
    // 创建可以滑动的View覆盖在hostView上
    TouchView *touchView = [[TouchView alloc] initWithFrame:_hostView.bounds];
    touchView.delegate = self;
    [_hostView addSubview:touchView];
    
    // 手指选择
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineWidth = 5.0;
    lineStyle.lineColor = [CPTColor orangeColor];
    
    // 拐点设置
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor orangeColor]];
    plotSymbol.lineStyle = lineStyle;
    plotSymbol.size = CGSizeMake(10.0f, 10.0f);
    
    //，触摸屏幕会有橙色的线可以滑动 第一次触摸屏幕出现的线是touchPlot 第二次是secondTouchPlot
    //出现两条线的时候设置highlightTouchPlot会有填充的一块。具体的可以在真机上试试，再结合代码。
    //添加折线图到图表
    
    // 触摸一个时 出现折线
    _beginPlot = [[CPTScatterPlot alloc] init];
    _beginPlot.identifier = @"begin";
    _beginPlot.dataLineStyle = lineStyle;
    _beginPlot.dataSource = self;
    _beginPlot.plotSymbol = plotSymbol;
    [_hostView.hostedGraph addPlot:_beginPlot];
    
    // 触摸两个时，中部出现的折线
    _middlePlot = [[CPTScatterPlot alloc] init];
    _middlePlot.identifier = @"middle";
    _middlePlot.dataLineStyle = lineStyle;
    _middlePlot.dataSource = self;
    _middlePlot.plotSymbol = plotSymbol;
    _middlePlot.interpolation = CPTScatterPlotInterpolationCurved;
    [_hostView.hostedGraph addPlot:_middlePlot];
    
    // 渐变色
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:[CPTColor redColor] endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    
    _middlePlot.areaFill = areaGradientFill;
    _middlePlot.areaBaseValue = @(0.0);
    
     // 触摸两个时，结尾出现的折线
    _endPlot = [[CPTScatterPlot alloc] init];
    _endPlot.identifier = @"end";
    _endPlot.dataLineStyle = lineStyle;
    _endPlot.dataSource = self;
    _endPlot.plotSymbol = plotSymbol;
    [_hostView.hostedGraph addPlot:_endPlot];
}

#pragma mark - object‘s method
#pragma mark 获取最靠近坐标点的X坐标
- (NSInteger)getXCoordinateFromPoint:(CGPoint)point
{
    // 获取在绘制区域中的坐标点
    CGPoint pointOfPlotArea = [_hostView.hostedGraph convertPoint:point toLayer:_hostView.hostedGraph.plotAreaFrame.plotArea];
    // 根据坐标数定义数据坐标点 如XY轴为：2
    NSDecimal dataCoordinates[_hostView.hostedGraph.defaultPlotSpace.numberOfCoordinates];
    // 把绘制坐标转换为数据坐标
    [_hostView.hostedGraph.defaultPlotSpace plotPoint:dataCoordinates numberOfCoordinates:_hostView.hostedGraph.defaultPlotSpace.numberOfCoordinates forPlotAreaViewPoint:pointOfPlotArea];
    
    // 获取X轴的数据坐标点
    NSDecimal xCoordinate = dataCoordinates[CPTCoordinateX];
    // 四舍五入
    NSDecimalRound(&xCoordinate, &xCoordinate, 0, NSRoundPlain);
    // 转换数据类型
    NSInteger xData = [[NSDecimalNumber decimalNumberWithDecimal:xCoordinate] integerValue];
    
    // 限制最大值最小值
    if (xData < 0) {
        xData = 0;
    }else if (xData >= self.dataSource.count) {
        xData = self.dataSource.count - 1;
    }
    
    return xData;
}

#pragma mark - CPTPlotDatasource
#pragma mark 询问有多少个数据
- (NSUInteger) numberOfRecordsForPlot:(CPTPlot *)plot {
    NSUInteger count=0;
    if ([plot.identifier isEqual:@"begin"]) {
        count = 3;
    }else if ([plot.identifier isEqual:@"end"]){
        count = 3;
    }else {
        count = self.dataSource.count;
    }
    return count;
}

#pragma mark 询问一个个数据值 fieldEnum:一个轴类型，是一个枚举  idx：坐标轴索引
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSNumber *num = nil;
    if(fieldEnum == CPTScatterPlotFieldY){    //询问在Y轴上的值
        if ([plot.identifier isEqual:@"begin"]) {
            switch (idx) {
                case 0:
                    num = @(0);
                    break;
                case 2:
                    num = @(9);
                    break;
                default:
                    num = self.dataSource[_beginIndex.integerValue];
                    break;
            }
        }else if ([plot.identifier isEqual:@"end"]){
            switch (idx) {
                case 0:
                    num = @(0);
                    break;
                case 2:
                    num = @(9);
                    break;
                default:
                    num = self.dataSource[_endIndex.integerValue];
                    break;
            }
        }else if ([plot.identifier isEqual:@"middle"]){
            if (_beginIndex && _endIndex && _beginIndex.integerValue <= idx && _endIndex.integerValue >= idx) {
                num = self.dataSource[idx];
            }
        }else {
            num = self.dataSource[idx];
        }
    }else if (fieldEnum == CPTScatterPlotFieldX){                                    //询问在X轴上的值
        if ([plot.identifier isEqual:@"begin"]) {
            num = _beginIndex;
        }else if ([plot.identifier isEqual:@"end"]){
            num = _endIndex;
        }else if ([plot.identifier isEqual:@"middle"]){
            if (_beginIndex && _endIndex && _beginIndex.integerValue <= idx && _endIndex.integerValue >= idx) {
                num = @(idx);
            }
        }else {
            num = @(idx);
        }
    }
    return num;
}

#pragma mark 添加数据标签
- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    if ([plot.identifier isEqual:@"scatter"]) {
        // 数据标签样式
        CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
        labelTextStyle.color = [CPTColor magentaColor];
        
        // 定义一个 TextLayer
        CPTTextLayer *newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d",[self.dataSource[idx] integerValue]] style:labelTextStyle];
        
        return newLayer;
    }else {
        return nil;
    }
}

#pragma mark - CPTScatterPlotDelegate
#pragma mark 选择拐点时弹出注释
- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(UIEvent *)event
{
    // 移除注释
    CPTPlotArea *plotArea = _hostView.hostedGraph.plotAreaFrame.plotArea;
    [plotArea removeAllAnnotations];
    
    // 创建拐点注释，plotSpace：绘图空间 anchorPlotPoint：坐标点
    CPTPlotSpaceAnnotation *symbolTextAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:_hostView.hostedGraph.defaultPlotSpace anchorPlotPoint:@[@(idx),self.dataSource[idx]]];
    
    // 文本样式
    CPTMutableTextStyle *annotationTextStyle = [CPTMutableTextStyle textStyle];
    annotationTextStyle.color = [CPTColor greenColor];
    annotationTextStyle.fontSize = 17.0f;
    annotationTextStyle.fontName = @"Helvetica-Bold";
    // 显示的字符串
    NSString *randomValue = [NSString stringWithFormat:@"折线图\n随即值：%@ \n", [self.dataSource[idx] stringValue]];
    // 注释内容
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:randomValue style:annotationTextStyle];
    // 添加注释内容
    symbolTextAnnotation.contentLayer = textLayer;
    
    // 注释位置
    symbolTextAnnotation.displacement = CGPointMake(CPTFloat(0), CPTFloat(20));
    
    // 把拐点注释添加到绘图区域中
    [plotArea addAnnotation:symbolTextAnnotation];
}

#pragma mark - CPTAxisDelegate
#pragma mark 是否使用系统的轴标签样式 并可改变标签样式 可用于任何标签方案(labelingPolicy)
- (BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    // 大于等于5的样式
    CPTMutableTextStyle * greateThanAndEqualFiveStyle = [[CPTMutableTextStyle alloc] init];
    greateThanAndEqualFiveStyle.color = [CPTColor greenColor];
    
    // 小于等于5的样式
    CPTMutableTextStyle * lessThanFiveStyle = [[CPTMutableTextStyle alloc] init];
    lessThanFiveStyle.color = [CPTColor blueColor];
    
    // 数字格式化
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.positiveFormat = @"#";
    
    // 标签设置
    NSMutableSet * newLabels = [NSMutableSet setWithCapacity:locations.count];
    for (NSNumber *tickLocation in locations) {
        CPTTextStyle *labelTextStyle;
        if ([tickLocation isGreaterThanOrEqualTo:@(5)]) {
            labelTextStyle = greateThanAndEqualFiveStyle;
        }
        else {
            labelTextStyle = lessThanFiveStyle;
        }
        
        NSString *labelString = [numberFormatter stringForObjectValue:tickLocation];
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:labelString textStyle:labelTextStyle];
        // 刻度线的位置
        newLabel.tickLocation = tickLocation;
        newLabel.offset = axis.labelOffset + axis.majorTickLength;
        
        [newLabels addObject:newLabel];
    }
    
    axis.axisLabels = newLabels;
    
    // 返回NO，使用上面的设置更新标签，返回YES，使用系统的标签
    return NO;
}

#pragma mark - CPTPlotSpaceDelegate

#pragma mark 替换移动坐标
- (CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)proposedDisplacementVector
{
//    NSLog(@"\n============willDisplaceBy==========\n");
//    NSLog(@"原始的将要移动的坐标:%@", NSStringFromCGPoint(proposedDisplacementVector));
//    
    return proposedDisplacementVector;
}

#pragma mark 是否允许缩放
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint
{
//    NSLog(@"\n============shouldScaleBy==========\n");
//    NSLog(@"缩放比例:%lf", interactionScale);
//    NSLog(@"缩放的中心点:%@", NSStringFromCGPoint(interactionPoint));
    return YES;
}

#pragma mark 缩放绘图空间时调用，设置显示大小
- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
//    NSLog(@"\n============willChangePlotRangeTo==========\n");
//    NSLog(@"坐标类型:%d", coordinate);
//    // CPTPlotRange 有比较方法 containsRange:
//    NSLog(@"原始的坐标空间:location:%@,length:%@", [NSDecimalNumber decimalNumberWithDecimal:newRange.location].stringValue, [NSDecimalNumber decimalNumberWithDecimal:newRange.length].stringValue);
//    
    return newRange;
}

#pragma mark 结束缩放绘图空间时调用
- (void)plotSpace:(CPTPlotSpace *)space didChangePlotRangeForCoordinate:(CPTCoordinate)coordinate
{
//    NSLog(@"\n============didChangePlotRangeForCoordinate==========\n");
//    NSLog(@"坐标类型:%d", coordinate);
}

#pragma mark 开始按下 point是在hostedGraph中的坐标
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    NSLog(@"\n\n\n============shouldHandlePointingDeviceDownEvent==========\n");
    NSLog(@"坐标点：%@", NSStringFromCGPoint(point));
    
    if (event.allTouches.count >= 2) {
        // 第一个指头
        // 获取第一个接触对象
        UITouch *firstTouch = [event.allTouches.allObjects firstObject];
        // 获取在_hostView上的触摸点
        CGPoint firstPoint = [firstTouch locationInView:_hostView];
        // 转换为在hostGraph上的坐标点
        firstPoint = [_hostView.layer convertPoint:firstPoint toLayer:_hostView.hostedGraph];
        // 获取靠近坐标点的X坐标
        NSInteger firstXCoordinate = [self getXCoordinateFromPoint:firstPoint];
        
        // 第二个指头
        // 获取第二个接触对象
        UITouch *lastTouch = [event.allTouches.allObjects lastObject];
        // 获取在_hostView上的触摸点
        CGPoint lastPoint = [lastTouch locationInView:_hostView];
        // 转换为在hostGraph上的坐标点
        lastPoint = [_hostView.hostedGraph convertPoint:lastPoint fromLayer:_hostView.layer];
        // 获取靠近坐标点的X坐标
        NSInteger lastXCoordinate = [self getXCoordinateFromPoint:lastPoint];
        
        // 赋值x坐标
        _beginIndex = @(MIN(firstXCoordinate, lastXCoordinate));
        _endIndex = @(MAX(firstXCoordinate, lastXCoordinate));
        
        // 刷新图表
        [_beginPlot reloadData];
        [_middlePlot reloadData];
        [_endPlot reloadData];
    }else {
        // 获取靠近坐标点的X坐标
        NSInteger xCoordinate = [self getXCoordinateFromPoint:point];
        // 赋值x坐标
        _beginIndex = @(xCoordinate);
        
        // 刷新图表
        [_beginPlot reloadData];
    }
    
    return YES;
}

#pragma mark 开始拖动 point是在hostedGraph中的坐标
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    NSLog(@"\n\n\n============shouldHandlePointingDeviceDraggedEvent==========\n");
    NSLog(@"坐标点：%@", NSStringFromCGPoint(point));
    
    if (event.allTouches.count >= 2) {
        // 第一个指头
        // 获取第一个接触对象
        UITouch *firstTouch = [event.allTouches.allObjects firstObject];
        // 获取在_hostView上的触摸点
        CGPoint firstPoint = [firstTouch locationInView:_hostView];
        // 转换为在hostGraph上的坐标点
        firstPoint = [_hostView.layer convertPoint:firstPoint toLayer:_hostView.hostedGraph];
        // 获取靠近坐标点的X坐标
        NSInteger firstXCoordinate = [self getXCoordinateFromPoint:firstPoint];
        
        // 第二个指头
        // 获取第二个接触对象
        UITouch *lastTouch = [event.allTouches.allObjects lastObject];
        // 获取在_hostView上的触摸点
        CGPoint lastPoint = [lastTouch locationInView:_hostView];
        // 转换为在hostGraph上的坐标点
        lastPoint = [_hostView.hostedGraph convertPoint:lastPoint fromLayer:_hostView.layer];
        // 获取靠近坐标点的X坐标
        NSInteger lastXCoordinate = [self getXCoordinateFromPoint:lastPoint];
        
        // 赋值x坐标
        _beginIndex = @(MIN(firstXCoordinate, lastXCoordinate));
        _endIndex = @(MAX(firstXCoordinate, lastXCoordinate));
        
        // 刷新图表
        [_beginPlot reloadData];
        [_middlePlot reloadData];
        [_endPlot reloadData];
    }else {
        // 获取靠近坐标点的X坐标
        NSInteger xCoordinate = [self getXCoordinateFromPoint:point];
        // 赋值x坐标
        _beginIndex = @(xCoordinate);
        
        // 刷新图表
        [_beginPlot reloadData];
    }
    
    return YES;
}

#pragma mark 松开 point是在hostedGraph中的坐标
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point
{
    NSLog(@"\n\n\n============shouldHandlePointingDeviceUpEvent==========\n");
    NSLog(@"坐标点：%@", NSStringFromCGPoint(point));
    
    for (CPTScatterPlot *plot in space.graph.allPlots) {
        NSLog(@"%@",plot.identifier);
        NSLog(@"%lu",(unsigned long)[plot indexOfVisiblePointClosestToPlotAreaPoint:point]);
    }
    
    _beginIndex = nil;
    _endIndex = nil;
    
    [_beginPlot reloadData];
    [_middlePlot reloadData];
    [_endPlot reloadData];
    
    return YES;
}

#pragma mark 取消，如：来电时产生的取消事件
-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceCancelledEvent:(CPTNativeEvent *)event
{
    NSLog(@"\n\n\n============shouldHandlePointingDeviceCancelledEvent==========\n");
    
    _beginIndex = nil;
    _endIndex = nil;
    
    [_beginPlot reloadData];
    [_middlePlot reloadData];
    [_endPlot reloadData];
    
    return YES;
}

#pragma mark - touchViewDelegate
- (void)touchViewBegan:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point;
    
    if (touches.count == 1) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:0];
        point = [touch locationInView:_hostView];
        
        point = [_hostView.layer convertPoint:point toLayer:_hostView.hostedGraph];
    }
    if (touches.count >= 2) {
        UITouch *touch = (UITouch *)[[touches allObjects] lastObject];
        point = [touch locationInView:_hostView];
        
        point = [_hostView.hostedGraph convertPoint:point fromLayer:_hostView.layer];
    }
    
    [self plotSpace:_hostView.hostedGraph.defaultPlotSpace shouldHandlePointingDeviceDownEvent:event atPoint:point];
}

- (void)touchViewMoved:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point;
    
    if (touches.count == 1) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:0];
        point = [touch locationInView:_hostView];
        
        point = [_hostView.layer convertPoint:point toLayer:_hostView.hostedGraph];
    }
    if (touches.count >= 2) {
        UITouch *touch = (UITouch *)[[touches allObjects] lastObject];
        point = [touch locationInView:_hostView];
        
        point = [_hostView.hostedGraph convertPoint:point fromLayer:_hostView.layer];
    }
    
    [self plotSpace:_hostView.hostedGraph.defaultPlotSpace shouldHandlePointingDeviceDraggedEvent:event atPoint:point];
}

- (void)touchViewEnded:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point;
    
    if (touches.count == 1) {
        UITouch *touch = (UITouch *)[[touches allObjects] objectAtIndex:0];
        point = [touch locationInView:_hostView];
        
        point = [_hostView.layer convertPoint:point toLayer:_hostView.hostedGraph];
    }
    if (touches.count >= 2) {
        UITouch *touch = (UITouch *)[[touches allObjects] lastObject];
        point = [touch locationInView:_hostView];
        
        point = [_hostView.hostedGraph convertPoint:point fromLayer:_hostView.layer];
    }
    
    [self plotSpace:_hostView.hostedGraph.defaultPlotSpace shouldHandlePointingDeviceUpEvent:event atPoint:point];
}

- (void)touchViewCanceled:(TouchView *)touchView touches:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self plotSpace:_hostView.hostedGraph.defaultPlotSpace shouldHandlePointingDeviceCancelledEvent:event];
}

@end
