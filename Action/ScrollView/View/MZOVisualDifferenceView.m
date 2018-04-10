//
//  MZOVisualDifferenceView.m
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/8.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import "MZOVisualDifferenceView.h"

@implementation MZOVisualDifferenceView

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(self.contentX, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - Method Private
- (void)setupUI
{
    _contentX = 0;
    self.clipsToBounds = YES;
    [self addSubview:self.imageView];
}

#pragma mark - Custom Accessors
- (void)setContentX:(CGFloat)contentX
{
    _contentX = contentX;
    _imageView.frame = CGRectMake(contentX, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - Lazy Load
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }
    return _imageView;
}

@end
