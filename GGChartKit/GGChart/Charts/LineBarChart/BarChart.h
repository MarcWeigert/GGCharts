//
//  BarChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarDataSet.h"
#import "BaseLineBarChart.h"

@interface BarChart : BaseLineBarChart

/**
 * 折线配置类
 */
@property (nonatomic, strong) BarDataSet * barDataSet;

/**
 * 渲染折线图
 */
- (void)drawBarChart;

/**
 * 开始动画
 */
- (void)startAnimation:(NSTimeInterval)duration;

@end
