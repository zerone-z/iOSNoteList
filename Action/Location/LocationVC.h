//
//  LocationVC.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/19.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *geocodeLocation;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@end
