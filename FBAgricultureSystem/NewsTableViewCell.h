//
//  NewsTableViewCell.h
//  FBAgricultureSystem
//
//  Created by 张富彬 on 16/1/14.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *despLabel;

@end
