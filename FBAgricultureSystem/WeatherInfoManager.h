//
//  WeatherInfoManager.h
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherInfoManagerDelegate <NSObject>

@optional
- (void)didGetWeatherInfo:(NSArray *)weatherInfo withError:(NSError *)error;

@end

@interface WeatherInfoManager : NSObject

@property (nonatomic, weak) id<WeatherInfoManagerDelegate> delegate;

- (void)getWeatherByLocation;

@end

@interface WeatherInfo : NSObject

@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *minTemperature;
@property (nonatomic, copy) NSString *maxTemperature;
@property (nonatomic, copy) NSString *weatherDesp;

@end
