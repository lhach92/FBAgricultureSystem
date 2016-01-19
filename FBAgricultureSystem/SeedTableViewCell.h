//
//  SeedTableViewCell.h
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/19.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *seedImageView;
@property (weak, nonatomic) IBOutlet UIView *seedNameContentView;
@property (weak, nonatomic) IBOutlet UILabel *seedNameLabel;

@end
