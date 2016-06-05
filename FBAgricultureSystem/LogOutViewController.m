//
//  LogOutViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/6/5.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "LogOutViewController.h"

@interface LogOutViewController ()

@end

@implementation LogOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasLogined"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
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

@end
