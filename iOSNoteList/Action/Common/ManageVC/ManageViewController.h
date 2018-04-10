//
//  ManageViewController.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/28.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageViewController : UIViewController

@end

@interface UIViewController (Associative)

@property (nonatomic, weak) ManageViewController *manageVC;

@end
