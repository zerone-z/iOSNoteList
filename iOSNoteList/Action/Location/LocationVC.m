//
//  LocationVC.m
//  iOSNoteList
//
//  Created by LuPengDa on 15/5/19.
//  Copyright (c) 2015年 myzerone. All rights reserved.
//

#import "LocationVC.h"
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"
#import "WGS84TOGCJ02.h"
#import "XJLocationService.h"

@interface LocationVC () <MKMapViewDelegate> {
    MKMapView *_locationView;
}

@end

@implementation LocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
        }
    }
#endif
    _locationView = [[MKMapView alloc] initWithFrame:self.mapView.bounds];
    [self.mapView addSubview:_locationView];
    _locationView.delegate = self;
    _locationView.mapType = MKMapTypeStandard;
    _locationView.userTrackingMode = MKUserTrackingModeFollow;
    _locationView.showsUserLocation = YES;
    
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap:)];
    [_locationView addGestureRecognizer:tapMap];
    
    
    LocationVC *__weak locationVC = self;
    [[XJLocationService sharedLocationService] setDidReverseGeocodeLocation:^(NSError *error, CLLocation *location, NSString *gecode) {
        locationVC.longitude.text = [@(location.coordinate.longitude) stringValue];
        locationVC.latitude.text = [@(location.coordinate.latitude) stringValue];
        locationVC.geocodeLocation.text = gecode;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Method Private
- (void)tapMap:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:_locationView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [_locationView convertPoint:touchPoint toCoordinateFromView:_locationView];//这里touchMapCoordinate就是该点的经纬度了
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self setAnnotitionWithLocation:location];
}

- (void)setAnnotitionWithLocation:(CLLocation *)location
{
    CLLocation *chineseLocation = location;
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[chineseLocation coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
        chineseLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:chineseLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSMutableString *address=[NSMutableString string];
        CLPlacemark *placemark=[placemarks objectAtIndex:0];
        if (placemark.country!=nil) {
            [address appendString:placemark.country];
        }
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
        //         NSLog(@"name:%@\n\
        //               country:%@\n\
        //               postalCode:%@\n\
        //               ISOcountryCode:%@\n\
        //               ocean:%@\n\
        //               inlandWater:%@\n\
        //               administrativeArea:%@\n\
        //               subAdministrativeArea:%@\n\
        //               locality:%@\n\
        //               subLocality:%@\n\
        //               thoroughfare:%@\n\
        //               subThoroughfare:%@\n",
        //               placemark.name,
        //               placemark.country,
        //               placemark.postalCode,
        //               placemark.ISOcountryCode,
        //               placemark.ocean,
        //               placemark.inlandWater,
        //               placemark.administrativeArea,
        //               placemark.subAdministrativeArea,
        //               placemark.locality,
        //               placemark.subLocality,
        //               placemark.thoroughfare,
        //               placemark.subThoroughfare);
        
        NSString *longitudeAndLatitude = [NSString stringWithFormat:@"经度：%lf\n纬度：%lf", location.coordinate.longitude, location.coordinate.latitude];
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithCoordinate:location.coordinate title:address subTitle:longitudeAndLatitude];
        //添加标注
        [self->_locationView removeAnnotations:self->_locationView.annotations];
        [self->_locationView addAnnotation:annotation];
        //放大地图到自身的经纬度位置。
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 250, 250);
        [self->_locationView setRegion:region animated:YES];

    }];
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self setAnnotitionWithLocation:userLocation.location];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"annotation";
    MKAnnotationView *result = nil;
    
    MapViewAnnotation *senderAnnotation = (MapViewAnnotation *)annotation;
    
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:identifier];
        [annotationView setCanShowCallout:YES]; // 显示title和subtitle
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = button;
    
    annotationView.opaque = NO;
    annotationView.animatesDrop = YES;
    annotationView.draggable = YES;
    annotationView.selected = YES;
    annotationView.calloutOffset = CGPointMake(15, 15);
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
    annotationView.leftCalloutAccessoryView = imageView;
    
    result = annotationView;
    return result;
}

@end
