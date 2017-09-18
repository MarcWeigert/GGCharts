//
//  LineBarChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/18.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineBarChart.h"
#import "LineBarDataSet.h"

@interface LineBarChart : BaseLineBarChart

/**
 * 折线配置类
 */
@property (nonatomic, strong) LineBarDataSet * lineBarDataSet;

/**
 * 渲染折线柱状图
 */
- (void)drawLineBarChart;

@end
