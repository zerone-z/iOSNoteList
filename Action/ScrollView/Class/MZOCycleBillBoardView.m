//
//  MZOCycleBillBoardView.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/8.
//  Copyright © 2018年 myzerone. All rights reserved.
//

/*
 * 主要是利用人的视觉差，思路解析：
 获取到一组需要显示的广告栏目组，在该组的最前面添加最后一个广告栏目，在该组的最后面添加第一个广告栏目，构成一个新的广告栏目组。
 然后利用新的栏目组作为数据实现轮播功能。
 在实现的使用，需要做以下处理，以下数据都是在新的广告栏目组的基础上进行操作的：
 1、默认滚动到第二个广告，目的是显示第一个广告
 2、当滚动到最后一张时，自动跳转到第二个广告，不能有动画
 3、当滚动到第一张时，自动跳转到倒数第二个广告，不能有动画
 */

#define kBillBoardDuration 6

#import "MZOCycleBillBoardView.h"

@interface MZOCycleBillBoardView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    dispatch_source_t _timer;
}

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UICollectionView *billBoardCV;

@end

@implementation MZOCycleBillBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)dealloc
{
    [self stopTimer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.pageControl.currentPage == 0) {
        [self reloadData];
    }
}

#pragma mark - Method Public
- (void)reloadData
{
    [self.billBoardCV reloadData];
    [self.pageControl setNumberOfPages:[self billBoardCount]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.billBoardCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self startTimer];
}

#pragma mark - Method Private
- (void)setupUI
{
    [self addSubview:self.billBoardCV];
    [self addSubview:self.pageControl];
    [self.billBoardCV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.billBoardCV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.billBoardCV attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.billBoardCV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.billBoardCV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    [self addConstraints:@[top, right, bottom, left]];
    
    NSLayoutConstraint *horizontalCenter = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *pageBottom = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.8 constant:0];
    [self addConstraints:@[horizontalCenter, pageBottom]];
}

- (NSInteger)billBoardCount
{
    if ([self.delegate respondsToSelector:@selector(numberInCycleBillBoardView:)]) {
        return [self.delegate numberInCycleBillBoardView:self];
    }
    return 0;
}

- (void)startTimer
{
    // 开启计时
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    if ([self billBoardCount] <= 1) {
        return;
    }
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, kBillBoardDuration * NSEC_PER_SEC), kBillBoardDuration * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) wself = self;
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!wself) {
                return;
            }
            __strong typeof(wself) sself = wself;
            if ([sself billBoardCount] <= 1) {
                return;
            }
            NSInteger nextIndex = sself.pageControl.currentPage + 2;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:nextIndex inSection:0];
            [sself.billBoardCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    });
    dispatch_resume(_timer);
}

- (void)stopTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)jumpToLastImage
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self billBoardCount] inSection:0];
    [self.billBoardCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)jumpToFirstImage
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.billBoardCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)jumpWithContentOffset:(CGPoint)contentOffset
{
    //向左滑动时切换imageView
    if (contentOffset.x <= 0) {
        [self jumpToLastImage];
    }
    //向右滑动时切换imageView
    if (contentOffset.x >= ([self billBoardCount] + 1) * CGRectGetWidth(self.billBoardCV.bounds)) {
        [self jumpToFirstImage];
    }
}

#pragma mark - Event Response
- (void)chagedPageEvent:(UIPageControl *)sender
{
    [self stopTimer];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.currentPage inSection:0];
    [self.billBoardCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self startTimer];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self billBoardCount] + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MZOCycleBillBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MZOCycleBillBoardCell reuseIdentifier] forIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(cycleBillBoardView:willDisplayBillBoardCell:atIndex:)]) {
        NSInteger index = indexPath.item - 1;
        if (0 == indexPath.item) {
            index = [self billBoardCount] - 1;
        } else if ([self billBoardCount] + 1 == indexPath.item) {
            index = 0;
        }
        [self.delegate cycleBillBoardView:self willDisplayBillBoardCell:cell atIndex:index];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.billBoardCV.bounds.size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleBillBoardView:didSelectItemAtIndex:)]) {
        NSInteger index = indexPath.item - 1;
        if (0 == indexPath.item) {
            index = [self billBoardCount] - 1;
        } else if ([self billBoardCount] + 1 == indexPath.item) {
            index = 0;
        }
        [self.delegate cycleBillBoardView:self didSelectItemAtIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self jumpWithContentOffset:scrollView.contentOffset];

    NSIndexPath *indexPath = [self.billBoardCV indexPathForItemAtPoint:scrollView.contentOffset];
    [self.pageControl setCurrentPage:indexPath.item - 1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self jumpWithContentOffset:scrollView.contentOffset];

    NSIndexPath *indexPath = [self.billBoardCV indexPathForItemAtPoint:scrollView.contentOffset];
    [self.pageControl setCurrentPage:indexPath.item - 1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

#pragma mark - Lazy Load
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        
        [_pageControl addTarget:self action:@selector(chagedPageEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UICollectionView *)billBoardCV
{
    if (!_billBoardCV) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing:0];
        [flowLayout setMinimumInteritemSpacing:0];
        
        _billBoardCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_billBoardCV setShowsVerticalScrollIndicator:NO];
        [_billBoardCV setShowsHorizontalScrollIndicator:NO];
        [_billBoardCV setPagingEnabled:YES];
        [_billBoardCV setBackgroundColor:[UIColor clearColor]];
        
        [_billBoardCV registerClass:[MZOCycleBillBoardCell class] forCellWithReuseIdentifier:[MZOCycleBillBoardCell reuseIdentifier]];
        
        [_billBoardCV setDataSource:self];
        [_billBoardCV setDelegate:self];
    }
    return _billBoardCV;
}

@end

@implementation MZOCycleBillBoardCell
@synthesize imageView = _imageView;

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - Method Private
- (void)setUp
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.contentView addSubview:self.imageView];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    [self.contentView addConstraints:@[top, right, left, bottom]];
}

#pragma mark - Lazy Load
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        [_imageView setClipsToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imageView;
}

@end
