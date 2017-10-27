//
//  BarDataSet.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarDataSet.h"
#import "BarCanvasAbstract.h"

@interface BarDataSet () <BarCanvasAbstract>

@end

@implementation BarDataSet

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _midLineColor = [UIColor grayColor];
    }
    
    return self;
}

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel
{
    [super configLineAndAxisModel];
    
    // 柱状图数据配置
    [self configAxisWithArray:self.barAry];
    [self configLineScalerWithArray:self.barAry];
    
    // 填充定标器
    for (BarData * obj in self.barAry) {
        
        [obj.lineBarScaler updateScaler];
    }
}

@end
