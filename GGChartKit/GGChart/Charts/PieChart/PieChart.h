//
//  PieChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//


#import "BaseLineBarChart.h"
#import "PieDataSet.h"

@interface PieChart : BaseLineBarChart

/**
 * 扇形图配置类
 */
@property (nonatomic, strong) PieDataSet * pieDataSet;

/**
 * 绘制扇形图表
 */
- (void)drawPieChart;

/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(PieAnimationType)pieAnimationType duration:(NSTimeInterval)duration;


@end
