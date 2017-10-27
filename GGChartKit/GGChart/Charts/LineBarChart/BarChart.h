//
//  BarChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/12.
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
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(BarAnimationsType)type duration:(NSTimeInterval)duration;

@end
