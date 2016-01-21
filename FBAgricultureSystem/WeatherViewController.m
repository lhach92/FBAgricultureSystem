//
//  WeatherViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherInfoManager.h"

@interface WeatherViewController ()<WeatherInfoManagerDelegate>
{
    WeatherInfoManager *_weatherInfoManager;
}
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getWeatherByLocation];
}

- (void)initWeatherInfoManager {
    if (!_weatherInfoManager) {
        _weatherInfoManager = [[WeatherInfoManager alloc] init];
        _weatherInfoManager.delegate = self;
    }
}

- (void)getWeatherByLocation {
    [self initWeatherInfoManager];
    [_weatherInfoManager getWeatherByLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -WeatherInfoManagerDelegate

- (void)didGetWeatherInfo:(NSArray *)weatherInfo withError:(NSError *)error {
    if (!error) {
        for (WeatherInfo *info in weatherInfo) {
            NSLog(@"\n温度：%@，天气：%@",info.temperature, info.weatherDesp);
        }
    }
}

@end
