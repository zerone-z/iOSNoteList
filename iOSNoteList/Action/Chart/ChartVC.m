//
//  ChartVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/11.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import "ChartVC.h"
#import "ScatterChartView.h"
#import "BarChartView.h"
#import "PieChartView.h"

@interface ChartVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)switchEvent:(UISegmentedControl *)sender;

@end

@implementation ChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Response
- (IBAction)switchEvent:(UISegmentedControl *)sender {
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGRect frame = self.contentView.bounds;
    frame = CGRectMake(CGRectGetMinX(frame) + 10, CGRectGetMinY(frame) + 10, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame) - 20);
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < 10; i++) {
                [dataSource addObject:@(arc4random()%10)];
            }
            ScatterChartView *scatterChart = [[ScatterChartView alloc] initWithFrame:frame];
            scatterChart.dataSource = dataSource;
            [self.contentView addSubview:scatterChart];
            [scatterChart loadView];
        }
            break;
        case 1:
        {
            // 柱状图
            NSMutableArray *dataSource1 = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *dataSource2 = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < 10; i++) {
                [dataSource1 addObject:@(arc4random()%10)];
                [dataSource2 addObject:@(arc4random()%10)];
            }
            BarChartView *barChart = [[BarChartView alloc] initWithFrame:frame];
            barChart.dataSource1 = dataSource1;
            barChart.dataSource2 = dataSource2;
            [self.contentView addSubview:barChart];
            [barChart loadView];
        }
            break;
        default:
        {
            // 饼图
            NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < 6; i++) {
                [dataSource addObject:@(arc4random()%10)];
            }
            for (int i = 0; i < 6; i++) {
                CGFloat scale = [dataSource[i] floatValue] / [[dataSource valueForKeyPath:@"@sum.self"] floatValue];
                [dataSource replaceObjectAtIndex:i withObject:@(scale)];
            }
            
            PieChartView *pieChare = [[PieChartView alloc] initWithFrame:frame];
            pieChare.dataSource = dataSource;
            [self.contentView addSubview:pieChare];
            [pieChare loadView];
        }
            break;
    }
}
@end
