//
//  CategoryOnlyProperty.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/7/22.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Category只读属性赋值
@interface CategoryOnlyProperty : NSObject

@property (strong, nonatomic) NSString *property;

@end


@interface CategoryOnlyProperty (Extend)

@property (strong, readonly, nonatomic) NSString *readOnlyProperty;

@end
