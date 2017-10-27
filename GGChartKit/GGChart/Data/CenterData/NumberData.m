//
//  NumberData.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NumberData.h"

@implementation NumberData

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _lableFont = [UIFont systemFontOfSize:9];
        _lableColor = [UIColor blackColor];
        _stringFormat = @"%.2f";
        _stringRatio = GGRatioCenter;
        _stringOffSet = CGSizeZero;
    }
    
    return self;
}

@end
