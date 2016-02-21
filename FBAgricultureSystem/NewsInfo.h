//
//  NewsInfo.h
//  FBAgricultureSystem
//
//  Created by LvHuan on 16/2/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject

@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsDate;
@property (nonatomic, copy) NSString *newsDescription;
@property (nonatomic, copy) NSString *newsImageUrlString;

@end
