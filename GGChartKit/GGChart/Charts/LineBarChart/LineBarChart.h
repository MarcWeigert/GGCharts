//
//  LineBarChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/18.
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

/**
 * 动画
 *
 * @param type 动画类型
 * @param duration 动画时间
 */
- (void)startBarAnimationsWithType:(BarAnimationsType)type duration:(NSTimeInterval)duration;


/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startLineAnimationsWithType:(LineAnimationsType)type duration:(NSTimeInterval)duration;

@end
