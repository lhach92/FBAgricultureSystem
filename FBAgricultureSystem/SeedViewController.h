//
//  SeedViewController.h
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/19.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunicator.h"

@interface SeedViewController : UIViewController
{
    ServerCommunicator *_serverCommunicator;
}

- (void)initServerCommunicator;
- (void)getSeedList;

@end
