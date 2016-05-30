//
//  RecommendSeedViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/5/27.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "RecommendSeedViewController.h"

@interface RecommendSeedViewController ()

@end

@implementation RecommendSeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)getSeedList {
    [self initServerCommunicator];
    [_serverCommunicator prepare:self loadingInView:self.view];
    [_serverCommunicator getRecommendSeedList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
