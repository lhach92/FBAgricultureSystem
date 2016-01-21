//
//  WeatherInfoManager.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "WeatherInfoManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServerCommunicator.h"
#import "StringTools.h"

@interface WeatherInfoManager ()<MKMapViewDelegate, CLLocationManagerDelegate, ServerCommunicatorDelegate>
{
    CLLocationManager *_locationManager;
    ServerCommunicator *_serverCommunicator;
}

@end

@implementation WeatherInfoManager

- (void)getWeatherByLocation {
    [self getUserLocation];
}

- (void)initServerCommunicator {
    if (!_serverCommunicator) {
        _serverCommunicator = [[ServerCommunicator alloc] init];
    }
    _serverCommunicator.delegate = self;
}

- (void)getUserLocation {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
        
    }
    
    [_locationManager stopUpdatingLocation];
    //开始定位
    [_locationManager startUpdatingLocation];
}

- (void)getWeatherByCity:(NSString *)city country:(NSString *)country {
    [self initServerCommunicator];
    [_serverCommunicator getWeatherByCity:city country:country];
}

- (BOOL)isKindOfNSDictionaryClass:(id)obj {
    return [obj isKindOfClass:[NSDictionary class]];
}

- (BOOL)isKindOfNSArrayClass:(id)obj {
    return [obj isKindOfClass:[NSArray class]];
}

- (void)handleDidGetWeatherInfo:(id)obj
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if ([self isKindOfNSDictionaryClass:obj]) {
        NSDictionary *dict = (NSDictionary *)obj;
        NSArray *listArray = dict[@"list"];
        if ([self isKindOfNSArrayClass:listArray] && listArray.count > 0) {
            for (NSDictionary *dailyDict in listArray) {
                if ([self isKindOfNSDictionaryClass:dailyDict]) {
                    NSString *temperature;
                    NSDictionary *temp = dailyDict[@"temp"];
                    if ([self isKindOfNSDictionaryClass:temp]) {
                        temperature = temp[@"day"];
                        if (![temperature isKindOfClass:[NSNull class]]) {
                            temperature = [NSString stringWithFormat:@"%@", temperature];
                            if ([StringTools isNotEmptyString:temperature]) {
                                CGFloat kTemperatureValue = [temperature floatValue];
                                CGFloat cTemperatureValue = kTemperatureValue - 273.15;
                                temperature = [NSString stringWithFormat:@"%fC", cTemperatureValue];
                            }
                        }
                    }
                    
                    NSString *weatherDesp;
                    NSArray *weatherArray = dailyDict[@"weather"];
                    NSDictionary *weatherDict = [weatherArray lastObject];
                    if (weatherDict && [self isKindOfNSDictionaryClass:weatherDict]) {
                        weatherDesp = weatherDict[@"description"];
                        if (![StringTools isNotEmptyString:weatherDesp]) {
                            weatherDesp = nil;
                        }
                    }
                    
                    if (temperature || weatherDesp) {
                        WeatherInfo *wInfo = [[WeatherInfo alloc] init];
                        wInfo.temperature = temperature;
                        wInfo.weatherDesp = weatherDesp;
                        if (wInfo) {
                            [resultArray addObject:wInfo];
                        }
                    }
                }
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(didGetWeatherInfo:withError:)]) {
        [self.delegate didGetWeatherInfo:resultArray withError:nil];
    }
}

#pragma mark -CLLocationManagerDelegate

//定位回调代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];//反向解析，根据及纬度反向解析出地址
    CLLocation *location = [locations objectAtIndex:0];
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark *place = [placemarks lastObject];
                       if (place) {
                           //取出当前位置的坐标
                           NSDictionary *dict = [place addressDictionary];
                           NSString *city = dict[@"City"];
                           NSString *country = dict[@"Country"];
                           [weakSelf getWeatherByCity:city country:country];
                       }
                   }];
    [manager stopUpdatingLocation];
}

#pragma mark - 检测应用是否开启定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
}

#pragma mark -ServerCommunicatorDelegate

- (void)handleRequestFail:(ASIHTTPRequest*)request {
    if ([self.delegate respondsToSelector:@selector(didGetWeatherInfo:withError:)]) {
        [self.delegate didGetWeatherInfo:nil withError:request.error];
    }
}

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    id obj = [_serverCommunicator parseObjectFromRequest:request];
    [self handleDidGetWeatherInfo:obj];
}

@end


@implementation WeatherInfo

@end
