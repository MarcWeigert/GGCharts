//
//  LineBarDataSet.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineBarDataSet.h"

@interface LineBarDataSet () <LineCanvasAbstract, BarCanvasAbstract>

@end

@implementation LineBarDataSet

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _midLineColor = [UIColor grayColor];
        self.lineBarMode = LineBarDrawParallel;
    }
    
    return self;
}

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel
{
    [super configLineAndAxisModel];
    
    // 配置折线数组
    NSMutableArray * lineBarDataAry = [NSMutableArray array];
    [lineBarDataAry addObjectsFromArray:self.lineAry];
    [lineBarDataAry addObjectsFromArray:self.barAry];
    
    [self configAxisWithArray:lineBarDataAry];
    
    [self configLineScalerWithArray:self.lineAry];
    [self configLineScalerWithArray:self.barAry];
    
    // 填充定标器
    [self.lineAry enumerateObjectsUsingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.lineBarScaler updateScaler];
    }];
    
    [self.barAry enumerateObjectsUsingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.lineBarScaler updateScaler];
    }];
}

@end
