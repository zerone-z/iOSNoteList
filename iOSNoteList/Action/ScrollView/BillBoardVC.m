//
//  BillBoardVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/8.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import "BillBoardVC.h"
#import "MZOCycleBillBoardView.h"

@interface BillBoardVC ()<MZOCycleBillboardViewDelegate>

@property (strong, nonatomic) MZOCycleBillBoardView *billBoardView;

@end

@implementation BillBoardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.billBoardView];
    [self.billBoardView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if (@available(iOS 11, *)) {
        NSLayoutConstraint *top = [self.billBoardView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:0];
        NSLayoutConstraint *left = [self.billBoardView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor constant:0];
        NSLayoutConstraint *right = [self.billBoardView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.billBoardView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:250];
        [self.view addConstraints:@[top, left, right, height]];
    } else {
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.billBoardView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.billBoardView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.billBoardView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.billBoardView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:250];
        [self.view addConstraints:@[top, left, right, height]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MZOCycleBillboardViewDelegate

- (NSInteger)numberInCycleBillBoardView:(MZOCycleBillBoardView *)cycleBillBoardView {
    return 4;
}

- (void)cycleBillBoardView:(MZOCycleBillBoardView *)cycleBillBoardView willDisplayBillBoardCell:(MZOCycleBillBoardCell *)billBoardCell atIndex:(NSInteger)index
{
    [billBoardCell.imageView setImage:[UIImage imageNamed:@(index).stringValue]];
}

#pragma mark - Lazy Load
- (MZOCycleBillBoardView *)billBoardView
{
    if (!_billBoardView) {
        _billBoardView = [MZOCycleBillBoardView new];
        [_billBoardView setDelegate:self];
    }
    return _billBoardView;
}

@end
