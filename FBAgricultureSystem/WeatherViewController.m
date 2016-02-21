//
//  WeatherViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherInfoManager.h"
#import "MBProgressHUD.h"

@interface WeatherViewController ()<WeatherInfoManagerDelegate>
{
    WeatherInfoManager *_weatherInfoManager;
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -WeatherInfoManagerDelegate

- (void)didGetWeatherInfo:(NSArray *)weatherInfo withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (!error) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:weatherInfo];
        for (WeatherInfo *info in weatherInfo) {
            NSLog(@"\n温度：%@，天气：%@",info.temperature, info.weatherDesp);
        }
        if (_dataArray.count > 0) {
            WeatherInfo *info = [_dataArray firstObject];
            self.temperatureLabel.text = info.temperature;
        }
    }
}

@end
