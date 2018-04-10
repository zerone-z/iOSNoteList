//
//  MZOCycleBillBoardView.h
//  iOSNoteList
//
//  Created by LuPengDa on 2018/4/8.
//  Copyright © 2018年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MZOCycleBillBoardView;
@class MZOCycleBillBoardCell;

@protocol MZOCycleBillboardViewDelegate<NSObject>

@required
- (NSInteger)numberInCycleBillBoardView:(MZOCycleBillBoardView *)cycleBillBoardView;
- (void)cycleBillBoardView:(MZOCycleBillBoardView *)cycleBillBoardView willDisplayBillBoardCell:(MZOCycleBillBoardCell *)billBoardCell atIndex:(NSInteger)index;

@optional
- (void)cycleBillBoardView:(MZOCycleBillBoardView *)cycleBillBoardView didSelectItemAtIndex:(NSInteger)index;

@end

/// 广告位Cell
@interface MZOCycleBillBoardCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

@property (readonly, strong, nonatomic) UIImageView *imageView;

@end

/// 轮播广告View
@interface MZOCycleBillBoardView : UIView

@property (weak, nonatomic) id<MZOCycleBillboardViewDelegate> delegate;

- (void)reloadData;

@end
