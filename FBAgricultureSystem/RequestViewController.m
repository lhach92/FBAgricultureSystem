//
//  RequestViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/3/15.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "RequestViewController.h"
#import "RequestTableViewCell.h"

@interface RequestViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

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
        cell.countLabel.text = [NSString stringWithFormat:@"X%@", info.productName];
        cell.cityLabel.text = info.city;
        cell.personLabel.text = info.person;
        cell.dateLabel.text = info.date;
        cell.teleLabel.text = info.telephone;
    }
    
    return cell;
}

@end
