//
//  NewsDetailViewController.m
//  FBAgricultureSystem
//
//  Created by LvHuan on 16/2/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ServerCommunicator.h"
#import "NewsInfo.h"

@interface NewsDetailViewController ()<ServerCommunicatorDelegate>
{
    ServerCommunicator *_serverCommunicator;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchNewsInfo];
}

- (void)fetchNewsInfo {
    [self initServerCommunicator];
    [_serverCommunicator prepare:self loadingInView:self.view];
    [_serverCommunicator getNewsDetailById:self.newsId];
}

- (void)initServerCommunicator {
    if (!_serverCommunicator) {
        _serverCommunicator = [[ServerCommunicator alloc] init];
        _serverCommunicator.delegate = self;
    }
}

- (void)handleHasGotNewsInfo:(NewsInfo *)newsInfo {
    self.titleLabel.text = newsInfo.newsTitle;
    self.dateLabel.text = newsInfo.newsDate;
    self.newsTextView.text = newsInfo.newsDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -ServerCommunicatorDelegate

- (void)handleRequestFail:(ASIHTTPRequest*)request {
    
}

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    id obj = [_serverCommunicator parseObjectFromRequest:request];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)obj;
        NewsInfo *newsInfo = [[NewsInfo alloc] init];
        newsInfo.newsTitle = dict[@"title"];
        newsInfo.newsDescription = dict[@"content"];
        newsInfo.newsDate = [NSString stringWithFormat:@"%@", dict[@"date"]];
        [self handleHasGotNewsInfo:newsInfo];
    }
}

@end
