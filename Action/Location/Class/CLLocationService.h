//
//  CLLocationService.h
//  BCMSystem
//
//  Created by LuPengDa on 15/5/8.
//  Copyright (c) 2015年 mobisoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^didUpdateLocationMessage)(BOOL success, NSString *message);

@class CLLocationService;

@protocol CLlocationServiceDelegate <NSObject>

@optional
- (void)locationService:(CLLocationService *)locationService didUpdateLocationMessage:(NSString *)message success:(BOOL)success;

@end

@interface CLLocationService : NSObject

+ (instancetype)sharedLocationService;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@property (nonatomic, assign) id<CLlocationServiceDelegate> delegate;

@property (nonatomic, copy) void (^didUpdateLocationMessage)(BOOL success, NSString *message);

@property (nonatomic, strong) NSString *locationAddress;

@end
