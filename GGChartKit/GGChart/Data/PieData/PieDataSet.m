//
//  PieDataSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieDataSet.h"

@implementation PieDataSet

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect
{
    for (GGPieData * pieData in self.pieAry) {
        
        [pieData.pieScaler updateScaler];
    }
}

@end
