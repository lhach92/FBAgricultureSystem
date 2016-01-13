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

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"农业资讯";
    _dataArray = [NSMutableArray array];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://img.alicdn.com/tps/TB1dUNMLpXXXXXGXFXXXXXXXXXX-520-280.jpg"]];
    [self createFakeData];
    
    [self.tableView reloadData];
}

- (void)createFakeData
{
    [_dataArray removeAllObjects];
    
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
    
    for (int i = 0; i < imageUrlArray.count ; i++) {
        NewsInfo *info = [[NewsInfo alloc] init];
        info.newsImageUrlString = imageUrlArray[i];
        info.newsTitle = [NSString stringWithFormat:@"农业资讯标题%d", i + 1];
        info.newsDescription = [NSString stringWithFormat:@"农业资讯详细信息%d,全球化的集结号正式吹响！顶级域名www.Le.com，全新品牌LeEco，蓝红绿灰代表科技、文化与互联网完美融合生态化反，影视内容生态全球战略，X65引领65寸4K电视进入4999时代…打破边界梦想化反的生态力，不断为全球乐迷创造全新体验和更高价值。", i + 1];
        [_dataArray addObject:info];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76.f;
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

@end


@implementation NewsInfo

@end
