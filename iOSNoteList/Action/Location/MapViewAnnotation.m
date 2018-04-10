//
//  MapViewAnnotation.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/19.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subTitle:(NSString *)subTitle
{
    if (self = [super init]) {
        _coordinate = coordinate;
        _title = title;
        _subTitle = subTitle;
    }
    return self;
}

@end
