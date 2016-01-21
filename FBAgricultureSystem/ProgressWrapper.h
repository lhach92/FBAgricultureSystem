//
//  ProgressWrapper.h
//  Metown
//
//  Created by user on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

//MBProgressHUD的包装类，便于使用
@interface ProgressWrapper : NSObject <MBProgressHUDDelegate> {
    MBProgressHUD *_progress;
}

@property (nonatomic, strong) MBProgressHUD *progress;
//@property (nonatomic, copy) void(^wantToCancel)();

+ (ProgressWrapper*)sharedProgressWrapper;

- (void)addloadingAnimation:(UIView*)superView;
- (void)addloadingAnimation:(UIView*)superView andTitle:(NSString *)title;
- (void)hide;
- (void)setTitle:(NSString *)title;

@end
