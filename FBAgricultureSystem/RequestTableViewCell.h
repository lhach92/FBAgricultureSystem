//
//  RequestTableViewCell.h
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/3/15.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *teleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
