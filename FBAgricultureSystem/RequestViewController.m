//
//  RequestViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/3/15.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "RequestViewController.h"
#import "RequestTableViewCell.h"
#import "ServerCommunicator.h"

@interface RequestViewController ()<UITableViewDataSource, UITableViewDelegate, ServerCommunicatorDelegate>
{
    NSMutableArray *_dataArray;
    ServerCommunicator *_serverCommunicator;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"需求";
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.7];
    
    _serverCommunicator = [[ServerCommunicator alloc] init];
    [_serverCommunicator prepare:self loadingInView:self.view];
    [_serverCommunicator getRequestList];
    
    _dataArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"requestCellId";
    RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RequestTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < _dataArray.count) {
        RequestInfo *info = _dataArray[indexPath.row];
        cell.nameLabel.text = info.productName;
        cell.countLabel.text = [NSString stringWithFormat:@"X%@", info.productCount];
        cell.cityLabel.text = info.city;
        cell.personLabel.text = info.person;
        cell.dateLabel.text = info.date;
        cell.teleLabel.text = info.telephone;
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.1];
        }
    }
    
    return cell;
}

#pragma mark -ServerCommunicatorDelegate

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    id obj = [_serverCommunicator parseObjectFromRequest:request];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)obj;
        for (NSDictionary *dict in array) {
            RequestInfo *info = [[RequestInfo alloc] init];
            info.productName = dict[@"product"];
            info.person = dict[@"person"];
            info.telephone = [NSString stringWithFormat:@"%@", dict[@"phone"]];
            info.date = [NSString stringWithFormat:@"%@", dict[@"dateString"]];
            info.productCount = dict[@"count"];
            info.city = dict[@"city"];
            
            [_dataArray addObject:info];
        }
    }
    [_tableView reloadData];
}

@end


@implementation RequestInfo

@end
