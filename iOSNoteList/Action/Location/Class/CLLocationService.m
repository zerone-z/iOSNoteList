//
//  CLLocationService.m
//  BCMSystem
//
//  Created by LuPengDa on 15/5/8.
//  Copyright (c) 2015年 mobisoft. All rights reserved.
//

#import "CLLocationService.h"

#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"

@interface CLLocationService () <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
}

@end

@implementation CLLocationService

+ (instancetype)sharedLocationService
{
    static dispatch_once_t onceLS;
    static CLLocationService *_sharedLocationService = nil;
    
    dispatch_once(&onceLS, ^{
        _sharedLocationService = [[CLLocationService alloc] init];
    });
    
    return _sharedLocationService;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
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
        // 启动位置更新
        [_locationManager startUpdatingLocation];
    } else {
        [self callBackWithSuccess:NO message:nil];
    }
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - Method Private
- (void)callBackWithSuccess:(BOOL)success message:(NSString *)message
{
    if (!success) {
        if (![CLLocationManager locationServicesEnabled]) {
            message = @"没有打开定位服务";
        }else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            message = @"没有使用定位服务的权限";
        }
    }else {
        self.locationAddress = message;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@(success).stringValue message:self.locationAddress delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
    if ([self.delegate respondsToSelector:@selector(locationService:didUpdateLocationMessage:success:)]) {
        [self.delegate locationService:self didUpdateLocationMessage:message success:success];
    }
    if (self.didUpdateLocationMessage) {
        self.didUpdateLocationMessage(success, message);
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSMutableString *string = [NSMutableString string];
    for (CLLocation *location in locations) {
        [string appendFormat:@"\n%lf,%lf",location.coordinate.longitude,location.coordinate.latitude];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"经纬度" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
    CLLocation *location = [locations firstObject];
    
    //得到newLocation
    CLLocation *loc = [locations objectAtIndex:0];
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
        location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    
    // 获取地址
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks,
                                       NSError *error)
     {
         NSMutableString *address=[NSMutableString string];
         CLPlacemark *placemark=[placemarks objectAtIndex:0];
         //         if (placemark.country!=nil) {
         //             [address appendString:placemark.country];
         //         }
         if (placemark.administrativeArea!=nil) {
             [address appendFormat:@"%@",placemark.administrativeArea];
         }
         if (placemark.subAdministrativeArea!=nil) {
             [address appendFormat:@"%@",placemark.subAdministrativeArea];
         }
         if (placemark.locality!=nil) {
             [address appendFormat:@"%@",placemark.locality];
         }
         if (placemark.subLocality!=nil) {
             [address appendFormat:@"%@",placemark.subLocality];
         }
         if (placemark.thoroughfare!=nil) {
             [address appendFormat:@"%@",placemark.thoroughfare];
         }
         if (placemark.subThoroughfare!=nil) {
             [address appendFormat:@"%@",placemark.subThoroughfare];
         }
         [self callBackWithSuccess:YES message:address];
     }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [_locationManager startUpdatingLocation];
    }else {
        [self callBackWithSuccess:NO message:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [_locationManager startUpdatingLocation];
}

@end
