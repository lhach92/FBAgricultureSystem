//
//  RecommendSeedViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/5/27.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "RecommendSeedViewController.h"
#import "SeedTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ServerCommunicator.h"
#import "SeedDetailViewController.h"
#import "SeedInfo.h"
#import "SRRefreshView.h"

@interface RecommendSeedViewController ()<UITableViewDelegate, UITableViewDataSource, SRRefreshDelegate>
{
    SeedInfo *_currentSeedInfo;
    ServerCommunicator *_serverCommunicator;
    NSMutableArray *_dataArray;
    
    SRRefreshView *_refreshView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecommendSeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self createFakeDatas];
    self.title = @"推荐种子";
    [self initVariables];
    [self getSeedList];
}

- (void)initVariables {
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)initServerCommunicator {
    if (!_serverCommunicator) {
        _serverCommunicator = [[ServerCommunicator alloc] init];
    } else {
        [_serverCommunicator clearEnvironment];
    }
}

- (void)getSeedList {
    [self initServerCommunicator];
    [_serverCommunicator prepare:self loadingInView:self.view];
    [_serverCommunicator getRecommendSeedList];
}

- (void)createFakeDatas
{
    _dataArray = [[NSMutableArray alloc] init];
    //假数据
    NSArray *imageUrlArray = @[ @"http://img12.360buyimg.com/vclist/jfs/t1945/112/2010878649/2702/c70662b0/5695f080N4b9ea755.jpg",
                                @"http://img12.360buyimg.com/vclist/jfs/t2350/306/1350571264/7696/f309044c/5695af1eNb80b64b0.jpg",
                                @"http://img11.360buyimg.com/vclist/jfs/t2332/12/2048117041/8452/d3bc4f1c/5695b6d6N6dec9548.jpg",
                                @"http://img13.360buyimg.com/vclist/jfs/t2422/363/2014474207/19111/3341d4fc/5695e10fNa6cc59c5.jpg",
                                @"http://img13.360buyimg.com/vclist/jfs/t2092/244/2018202356/11635/1c93f47d/5695ad2bN9fb65d14.jpg",
                                @"http://img12.360buyimg.com/vclist/jfs/t2302/155/1289427390/9649/14cc158d/5693ca96N9e903040.jpg",
                                @"http://img11.360buyimg.com/vclist/jfs/t1849/84/1994422501/8966/b1d506ed/5693cca5N198439b1.jpg",
                                @"http://img30.360buyimg.com/da/jfs/t2137/231/1840980774/19328/237c62b4/56820486N6698cf30.jpg",
                                @"http://img11.360buyimg.com/da/jfs/t1942/76/1978922882/14935/e9e01c70/569463d4N66d3d0f0.jpg",
                                @"http://img13.360buyimg.com/da/jfs/t2518/308/1099569962/13124/4ed0549d/568cdfa8Nf925e27b.jpg",
                                @"http://img13.360buyimg.com/vclist/jfs/t2497/166/2096042502/12864/2d7736c2/5695b56aNc2bcff69.jpg",
                                @"http://img13.360buyimg.com/vclist/jfs/t2086/211/2041130845/12561/98dbed0b/56927bc3N899dd2f5.jpg",
                                @"http://img12.360buyimg.com/vclist/jfs/t1891/33/1965727906/11230/b0d0874e/5695a6c3Nfd33f89b.jpg",
                                @"http://img30.360buyimg.com/da/jfs/t1894/47/1965476666/15284/2c7e6b5f/5695bdadN55618905.jpg",
                                @"http://img12.360buyimg.com/vclist/jfs/t2083/27/1887306331/13136/408b64ab/568f8328N1da9a8f1.jpg",
                                @"http://img12.360buyimg.com/vclist/jfs/t2461/191/2009511092/7529/5048b8ea/5696073dNdd52f267.jpg",
                                @"http://img13.360buyimg.com/vclist/jfs/t2419/119/1996809929/14443/c122213e/5695a228Nba77ca6f.jpg",
                                @"http://img13.360buyimg.com/vclist/jfs/t2131/260/1976159462/11779/49d77809/5693c887Nf92b0580.jpg",
                                @"http://img13.360buyimg.com/vclist/jfs/t1900/236/2069020648/11476/9913b5b0/5693d542N7c6e7356.jpg",
                                @"http://img12.360buyimg.com/vclist/jfs/t2257/195/2080517259/8865/c85d3dbf/5693d55bNfb7472d5.jpg"];
    for (int i = 0; i < imageUrlArray.count; i++) {
        NSString *url = imageUrlArray[i];
        SeedInfo *info = [[SeedInfo alloc] init];
        info.seedName = [NSString stringWithFormat:@"%d号", i];
        info.seedImageUrlString = url;
        [_dataArray addObject:info];
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView reloadData];
}

- (void)createRefreshView {
    if (!_refreshView) {
        _refreshView = [[SRRefreshView alloc] initWithFrame:CGRectMake(0, -100, CGRectGetWidth(_tableView.frame), 100)];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SeedDetailViewController *vc = segue.destinationViewController;
    vc.hidesBottomBarWhenPushed = YES;
    vc.seedId = _currentSeedInfo.seedId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"seedCellId";
    SeedTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SeedTableViewCell" owner:nil options:nil] lastObject];
    }
    if (indexPath.row < _dataArray.count) {
        SeedInfo *info = _dataArray[indexPath.row];
        cell.seedNameLabel.text = info.seedName;
        [cell.seedImageView sd_setImageWithURL:[NSURL URLWithString:info.seedImageUrlString]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _dataArray.count) {
        _currentSeedInfo = _dataArray[indexPath.row];
    }
    [self performSegueWithIdentifier:@"goToDetailSeedVC" sender:nil];
}

#pragma mark - ServerCommunicatorDelegate

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    id obj = [_serverCommunicator parseObjectFromRequest:request];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)obj;
        [_dataArray removeAllObjects];
        for (NSDictionary *dict in array) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                SeedInfo *info = [[SeedInfo alloc] init];
                info.seedId = dict[@"id"];
                info.seedName = dict[@"seed"];
                info.seedImageUrlString = dict[@"photo"];
                [_dataArray addObject:info];
            }
        }
    }
    [self createRefreshView];
    [_tableView reloadData];
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
    [self getSeedList];
    [_refreshView endRefresh];
}

@end
