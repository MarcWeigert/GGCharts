//
//  AxisName.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/14.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "AxisName.h"

@interface AxisName () <NumberAxisNameAbstract>

@end

@implementation AxisName

/** 初始化方法 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _font = [UIFont systemFontOfSize:9];
        _color = [UIColor blackColor];
    }
    
    return self;
}

@end
