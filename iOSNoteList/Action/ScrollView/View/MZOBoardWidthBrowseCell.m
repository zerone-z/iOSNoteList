//
//  MZOBoardWidthBrowseCell.m
//  iOSNoteList
//
//  Created by LuPengDa on 2017/7/18.
//  Copyright © 2017年 myzerone. All rights reserved.
//

#import "MZOBoardWidthBrowseCell.h"

@interface MZOBoardWidthBrowseCell() {
    NSLayoutConstraint *_top;
    NSLayoutConstraint *_left;
    NSLayoutConstraint *_right;
    NSLayoutConstraint *_bottom;
}

@end

/// 浏览图片的Cell
@implementation MZOBoardWidthBrowseCell
@synthesize imageView = _imageView;

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

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

- (void)updateConstraints
{
    _top.constant = self.contentInsets.top;
    _bottom.constant = -self.contentInsets.bottom;
    _left.constant = self.contentInsets.left;
    _right.constant = -self.contentInsets.right;
    [super updateConstraints];
}

#pragma mark - Method Private
- (void)setupUI
{
    [self.contentView addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setContentInsets:UIEdgeInsetsZero];
    _top = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:self.contentInsets.top];
    _bottom = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.contentInsets.bottom];
    _left = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.contentInsets.left];
    _right = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-self.contentInsets.right];
    [self.contentView addConstraints:@[_top, _bottom, _left, _right]];
}

#pragma mark - Custom Accessors
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
    }
    return _imageView;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(contentInsets, _contentInsets)) {
        return;
    }
    _contentInsets = contentInsets;
    [self setNeedsUpdateConstraints];
}

@end
