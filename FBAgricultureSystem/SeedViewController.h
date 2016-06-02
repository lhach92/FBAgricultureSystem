//
//  SeedViewController.h
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/19.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"
#import "SeedInfo.h"

@interface SeedViewController : UIViewController
{
    ServerCommunicator *_serverCommunicator;
    NSMutableArray *_dataArray;
}

- (void)initServerCommunicator;
- (void)getSeedList;

@end
