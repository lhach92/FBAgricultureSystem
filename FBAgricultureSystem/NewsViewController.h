//
//  NewsViewController.h
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/13.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController

@end

@interface NewsInfo : NSObject

@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsDescription;
@property (nonatomic, copy) NSString *newsImageUrlString;

@end
