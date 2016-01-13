//
//  ViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/13.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSInteger random = arc4random() % 2;
//    if (0 == random) {
//        [self performSegueWithIdentifier:@"seguePresentLogin" sender:self];
//    } else {
        [self performSegueWithIdentifier:@"seguePushToRoot" sender:self];
//    }
    NSLog(@"%@", self.navigationController.viewControllers);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
