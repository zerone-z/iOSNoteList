//
//  XJGifImageView.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/6/1.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJGifImageView : UIView

- (instancetype)initWithFilePath:(NSString *)filePath;

- (instancetype)initWithData:(NSData *)data;

@property (nonatomic, assign) NSTimeInterval animationDuration;

- (void)startAnimating;

- (void)stopAnimating;

- (BOOL)isAnimating;

@end
