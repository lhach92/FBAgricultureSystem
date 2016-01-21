//
//  WeatherViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherInfoManager.h"

@interface WeatherViewController ()<WeatherInfoManagerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    WeatherInfoManager *_weatherInfoManager;
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -WeatherInfoManagerDelegate

- (void)didGetWeatherInfo:(NSArray *)weatherInfo withError:(NSError *)error {
    if (!error) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:weatherInfo];
        for (WeatherInfo *info in weatherInfo) {
            NSLog(@"\n温度：%@，天气：%@",info.temperature, info.weatherDesp);
        }
        [_tableView reloadData];
    }
}

#pragma mark -UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"weatherCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row < _dataArray.count) {
        WeatherInfo *info = _dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@~%@", info.weatherDesp, info.minTemperature, info.maxTemperature];
    }
    return cell;
}

#pragma mark -UITableViewDelegate

@end
