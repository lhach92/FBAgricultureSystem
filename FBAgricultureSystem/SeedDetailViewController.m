//
//  SeedDetailViewController.m
//  FBAgricultureSystem
//
//  Created by LvHuan on 16/3/15.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "SeedDetailViewController.h"
#import "ServerCommunicator.h"
#import "SeedInfo.h"
#import "UIImageView+WebCache.h"

@interface SeedDetailViewController ()<ServerCommunicatorDelegate>
{
    ServerCommunicator *_serverCommunicator;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *seedImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end

@implementation SeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _serverCommunicator = [[ServerCommunicator alloc] init];
    [_serverCommunicator prepare:self loadingInView:self.view];
    [_serverCommunicator getSeedDetailById:self.seedId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -ServerCommunicatorDelegate

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    id obj = [_serverCommunicator parseObjectFromRequest:request];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)obj;
        SeedInfo *info = [[SeedInfo alloc] init];
        info.seedId = dict[@"id"];
        info.seedName = dict[@"seed"];
        info.seedContent = dict[@"content"];
        info.seedImageUrlString = dict[@"photo"];
        
        _textView.text = info.seedContent;
        _textView.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = info.seedName;
        [_seedImageView sd_setImageWithURL:[NSURL URLWithString:info.seedImageUrlString]];
        [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:info.seedImageUrlString]];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectView.frame = _backgroundImageView.bounds;
        [_backgroundImageView addSubview:effectView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
