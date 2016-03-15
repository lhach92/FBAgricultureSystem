//
//  RequestViewController.h
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/3/15.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestViewController : UIViewController

@end

@interface RequestInfo : NSObject

@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productCount;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *person;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *telephone;

@end