//
//  XJLocationService.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/19.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

/**
 *
 *  在info.plist中设置key值，有：
 *  NSLocationWhenInUseUsageDescription
 *  NSLocationAlwaysUsageDescription
 *  UIApplicationOpenSettingsURLString，它存储了一个 URL 用来打开当前应用在 Settings.app 对应的页面
 *  [UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
 *
 **/

#import "XJLocationService.h"
#import "WGS84TOGCJ02.h"

@interface XJLocationService () <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}

@end

@implementation XJLocationService

+ (instancetype)sharedLocationService
{
    static dispatch_once_t onceRun;
    static XJLocationService *_sharedLocationService = nil;
    
    dispatch_once(&onceRun, ^{
        _sharedLocationService = [[XJLocationService alloc] init];
    });
    
    return _sharedLocationService;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        // 属性表示取得定位的精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        // 更新位置的距离，假如超过设定值则进行定位更新，否则不更新.kCLDistanceFilterNone表示不设置距离过滤，即随时更新地理位置
        _locationManager.distanceFilter = kCLDistanceFilterNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 &&
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
            BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            if (hasWhenInUseKey) {
                [_locationManager requestWhenInUseAuthorization];
            }else if (hasAlwaysKey) {
                [_locationManager requestAlwaysAuthorization];
            } else {
                
            }
        }
#endif
    }
    return self;
}

#pragma mark - Method Public
- (void)startUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        // 开启定位功能
        [_locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation
{
    // 停止定位
    [_locationManager stopUpdatingLocation];
}

#pragma mark - Method Private
- (void)callBlackForLocationWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(locationService:didUpdateLocation:error:)]) {
        [self.delegate locationService:self didUpdateLocation:self.location error:error];
    }
    if (self.didUpdateLocation) {
        self.didUpdateLocation(nil, self.location);
    }
}

- (void)callBlackForGeocodeLocationWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(locationService:didUpdateLocation:reverseGeocodeLocation:error:)]) {
        [self.delegate locationService:self didUpdateLocation:self.location reverseGeocodeLocation:self.geocodeLocation error:error];
    }
    if (self.didReverseGeocodeLocation) {
        self.didReverseGeocodeLocation(error, self.location, self.geocodeLocation);
    }
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    /**
     CLLocation属性说明：
     altitude	海拔高度
     coordinate	经纬度
     course     行驶方向
     horizontalAccuracy	水平方向的精确度
     Speed      行驶速度
     timestamp	时间戳
     verticalAccuracy	垂直方向的精确度
     **/
    
    //得到newLocation
    CLLocation *location = locations.firstObject;
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
        location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    self.location = location;
    [self callBlackForLocationWithError:nil];
    
    // 获取地址
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSMutableString *address=[NSMutableString string];
        
        CLPlacemark *placemark=[placemarks objectAtIndex:0];
        if (placemark.country) {
            [address appendString:placemark.country];
        }
        if (placemark.administrativeArea) {
            [address appendFormat:@"%@",placemark.administrativeArea];
        }
        if (placemark.subAdministrativeArea) {
            [address appendFormat:@"%@",placemark.subAdministrativeArea];
        }
        if (placemark.locality) {
            [address appendFormat:@"%@",placemark.locality];
        }
        if (placemark.subLocality) {
            [address appendFormat:@"%@",placemark.subLocality];
        }
        if (placemark.thoroughfare) {
            [address appendFormat:@"%@",placemark.thoroughfare];
        }
        if (placemark.subThoroughfare) {
            [address appendFormat:@"%@",placemark.subThoroughfare];
        }
        self.geocodeLocation = address;
        [self callBlackForGeocodeLocationWithError:error];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [_locationManager startUpdatingLocation];
    }else {
        [self callBlackForLocationWithError:error];
        [self callBlackForGeocodeLocationWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [_locationManager startUpdatingLocation];
}

@end
