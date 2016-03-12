//
//  NewsViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/13.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "NewsViewController.h"
#import "UIImageView+WebCache.h"
#import "NewsTableViewCell.h"
#import "ServerCommunicator.h"
#import "NewsDetailViewController.h"
#import "NewsInfo.h"
#import "SRRefreshView.h"







@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate, ServerCommunicatorDelegate, SRRefreshDelegate>
{
    NSMutableArray *_dataArray;
    ServerCommunicator *_serverCommunicator;
    NewsInfo *_currentNewsInfo;
    SRRefreshView *_refreshView;
}

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农业资讯";
    
    [self initData];
    [self initUI];
    [self getNewsArray];
}

- (void)initUI {
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://img.alicdn.com/tps/TB1dUNMLpXXXXXGXFXXXXXXXXXX-520-280.jpg"]];
    [self createRefreshView];
}

- (void)initData {
    _dataArray = [NSMutableArray array];
}

- (void)initServerCommunicator {
    if (!_serverCommunicator) {
        _serverCommunicator = [[ServerCommunicator alloc] init];
        _serverCommunicator.delegate = self;
    }
}

- (void)getNewsArray {
    [self initServerCommunicator];
    [_serverCommunicator getNewsList];
}

- (void)createRefreshView {
    if (!_refreshView) {
        _refreshView = [[SRRefreshView alloc] init];
        _refreshView.delegate = self;
        _refreshView.upInset = 0;
        _refreshView.slime.bodyColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
        _refreshView.slime.skinColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
        _refreshView.slime.lineWith = 1;
        _refreshView.slime.shadowBlur = 4;
        _refreshView.slime.shadowColor = [UIColor clearColor];
    }
    [_tableView addSubview:_refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    NewsDetailViewController *vc = segue.destinationViewController;
    vc.newsId = _currentNewsInfo.newsId;
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"newsCellId";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.newsImageView.image = nil;
    if (indexPath.row < _dataArray.count) {
        NewsInfo *info = _dataArray[indexPath.row];
        
        cell.titleLabel.text = info.newsTitle;
        cell.despLabel.text = info.newsDescription;
        [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:info.newsImageUrlString]];
    }
    return cell;
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _dataArray.count) {
        _currentNewsInfo = _dataArray[indexPath.row];
    }
    [self performSegueWithIdentifier:@"goToDetailNewsVC" sender:nil];
}

#pragma mark -ServerCommunicatorDelegate

- (void)handleRequestFail:(ASIHTTPRequest*)request {
    NSLog(@"请求失败!");
}

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    id obj = [_serverCommunicator parseObjectFromRequest:request];
    if ([obj isKindOfClass:[NSArray class]]) {
        [_dataArray removeAllObjects];
        NSArray *array = (NSArray *)obj;
        for (NSDictionary *dict in array) {
            NewsInfo *info = [[NewsInfo alloc] init];
            info.newsId = dict[@"id"];
            info.newsTitle = dict[@"title"];
            info.newsDescription = dict[@"content"];
            [_dataArray addObject:info];
        }
        [_tableView reloadData];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshView scrollViewDidEndDraging];
}

#pragma mark - SRRefreshDelegate

- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView {
    [self getNewsArray];
    [_refreshView endRefresh];
}

@end
