//
//  XJLocationService.h
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/19.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class XJLocationService;

@protocol XJLocationServiceDelegate <NSObject>

@optional
- (void)locationService:(XJLocationService *)locationService didUpdateLocation:(CLLocation *)location error:(NSError *)error;

- (void)locationService:(XJLocationService *)locationService didUpdateLocation:(CLLocation *)location reverseGeocodeLocation:(NSString *)geocodeLocation error:(NSError *)error;

@end

@interface XJLocationService : NSObject

+ (instancetype)sharedLocationService;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@property (nonatomic, assign) id<XJLocationServiceDelegate> delegate;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *geocodeLocation;

@property (nonatomic, copy) void (^didUpdateLocation)(NSError *error, CLLocation *location);
@property (nonatomic, copy) void (^didReverseGeocodeLocation)(NSError *error, CLLocation *location, NSString *geocodeLocation);

@end
