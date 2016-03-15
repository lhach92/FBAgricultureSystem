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
    self.title = @"天气";
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

#pragma mark -UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"weatherCellId";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 49, CGRectGetWidth(self.view.frame), 1)];
        view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5];
        [cell addSubview:view];
    }
    
    if (indexPath.row < _dataArray.count) {
        WeatherInfo *info = _dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@℃", info.temperature];
        cell.textLabel.font = [UIFont systemFontOfSize:22];
        cell.detailTextLabel.text = info.weatherDesp;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:19];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
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
        [_tableView reloadData];
    }
}

@end
