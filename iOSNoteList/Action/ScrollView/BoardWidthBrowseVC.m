//
//  BoardWidthBrowseVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/8.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#define kImageSpacing 20 // 图片间隔

#import "BoardWidthBrowseVC.h"
#import "MZOBoardWidthBrowseCell.h"

@interface BoardWidthBrowseVC ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *browseCollectionView;
// 当前显示的索引
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation BoardWidthBrowseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.browseCollectionView];
    self.browseCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 11, *)) {
        NSLayoutConstraint *top = [self.browseCollectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0];
        NSLayoutConstraint *bottom = [self.browseCollectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0];
        NSLayoutConstraint *left = [self.browseCollectionView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor constant:0];
        NSLayoutConstraint *right = [self.browseCollectionView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor constant:kImageSpacing];
        [self.view addConstraints:@[top, left, right, bottom]];
    } else {
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.browseCollectionView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.browseCollectionView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.browseCollectionView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.browseCollectionView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self.view addConstraints:@[top, left, right, bottom]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MZOBoardWidthBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MZOBoardWidthBrowseCell reuseIdentifier] forIndexPath:indexPath];
    [cell setContentInsets:UIEdgeInsetsMake(0, 0, 0, kImageSpacing)];
    [cell.imageView setImage:[UIImage imageNamed:@(indexPath.row).stringValue]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 非交互滚动，直接返回
    if (!scrollView.dragging && !scrollView.tracking && !scrollView.decelerating) {
        return;
    }
}

#pragma mark - Lazy Load
- (UICollectionView *)browseCollectionView
{
    if (!_browseCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _browseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_browseCollectionView setBackgroundColor:[UIColor clearColor]];
        [_browseCollectionView setAlwaysBounceHorizontal:YES];
        [_browseCollectionView setPagingEnabled:YES];
        
        [_browseCollectionView registerClass:[MZOBoardWidthBrowseCell class] forCellWithReuseIdentifier:[MZOBoardWidthBrowseCell reuseIdentifier]];
        
        [_browseCollectionView setDataSource:self];
        [_browseCollectionView setDelegate:self];
    }
    return _browseCollectionView;
}

@end
