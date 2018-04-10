//
//  MZOBoardWidthBrowseCell.h
//  iOSNoteList
//
//  Created by LuPengDa on 2017/7/18.
//  Copyright © 2017年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 浏览图片的Cell
@interface MZOBoardWidthBrowseCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

@property (readonly, strong, nonatomic) UIImageView *imageView;

@property (assign, nonatomic) UIEdgeInsets contentInsets;

@end
