//
//  StringTools.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/21.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "StringTools.h"

@implementation StringTools

+ (BOOL)isNotEmptyString:(NSString *)string
{
    return ([string isKindOfClass:[NSString class]] && string.length > 0);
}

@end
