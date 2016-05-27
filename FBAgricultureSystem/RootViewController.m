//
//  RootViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/13.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "RootViewController.h"
#import "NewsViewController.h"
#import "SeedViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = [UIColor colorWithRed:0/255.0 green:178/255.0 blue:15/255.0 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBar.hidden = NO;
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

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[NewsViewController class]]) {
        [(NewsViewController *)viewController getNewsArray];
    } else if ([viewController isKindOfClass:[SeedViewController class]]) {
        
    }
}

@end
