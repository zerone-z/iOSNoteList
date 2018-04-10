//
//  XJAssetsGroupViewController.h
//  iOSNoteList
//
//  Created by LuPengDa on 14-1-17.
//  Copyright (c) 2014年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJAssetSelectionDelegate.h"
@class ALAssetsLibrary;

@interface XJAssetsGroupViewController : UITableViewController
@property(nonatomic,weak) id<XJAssetSelectionDelegate> parent;

@end
