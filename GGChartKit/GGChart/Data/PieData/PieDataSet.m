//
//  PieDataSet.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieDataSet.h"

@implementation PieDataSet

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect
{
    for (PieData * pieData in self.pieAry) {
        
        pieData.pieScaler.rect = rect;
        pieData.pieScaler.roseRadius = pieData.roseType == RoseRadius;
        [pieData.pieScaler updateScaler];
    }
    
    [self.centerLable updateCenterConfigs:rect];
}

/**
 * 中心点配置类
 */
- (CenterData *)centerLable
{
    if (_centerLable == nil) {
        
        _centerLable = [[CenterData alloc] init];
        [(id <CenterAbstract>)_centerLable setPolygon:GGPolygonMake(0, 0, 0, 0, 0)];
    }
    
    return _centerLable;
}

@end
