//
//  VisualDifferenceBrowseVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/8.
//  Copyright © 2018年 myzerone. All rights reserved.
//

/*
 rightView.contentX = 需要移动距离长度 - 移动百分比 * 需要移动距离长度 ; leftView.contentX 和这个类似。

 需要移动距离长度 =  SCROLLVIEW_WIDTH - AnimationOffset；
 移动百分比 = 拖拽距离 /  一页宽度即屏幕宽度
 拖拽距离 =   (偏移量X - leftView横坐标)；
 偏移量X = scrollView.contentOffset.x；
 leftIndex = 偏移量X/SCROLLVIEW_WIDTH；
 leftView横坐标 = leftIndex * SCROLLVIEW_WIDTH
 */

#define BaseTag 100
/**
 动画偏移量 是指rightView相对于leftView的偏移量
 */
#define AnimationOffset 100

#import "VisualDifferenceBrowseVC.h"
#import "MZOVisualDifferenceView.h"

@interface VisualDifferenceBrowseVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation VisualDifferenceBrowseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    [self.scrollView setFrame:CGRectMake(0, 100, width, width)];
    [self.scrollView setContentSize:CGSizeMake(width * 4, width)];
    for (int i = 0; i < 4 ; i++) {
        MZOVisualDifferenceView * view = [[MZOVisualDifferenceView alloc] initWithFrame:CGRectMake(i * width, 0, width, width)];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        view.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [self.scrollView addSubview:view];
        view.tag = BaseTag + i;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    NSInteger leftIndex = x/width;
    //    NSLog(@"%ld",leftIndex);
    
    //这里的left和right是区分拖动中可见的两个视图
    MZOVisualDifferenceView *leftView = [scrollView viewWithTag:(leftIndex + BaseTag)];
    MZOVisualDifferenceView *rightView = [scrollView viewWithTag:(leftIndex + 1 + BaseTag)];
    
    rightView.contentX = -(width - AnimationOffset) + (x - (leftIndex * width))/width * (width - AnimationOffset);
    leftView.contentX = ((width - AnimationOffset) + (x - ((leftIndex + 1) * width))/width * (width - AnimationOffset));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Load
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
