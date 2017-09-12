//
//  GGLineChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineDataSet.h"
#import "BaseLineBarChart.h"

@interface LineChart : BaseLineBarChart

/**
 * 折线配置类
 */
@property (nonatomic, strong) LineDataSet * lineDataSet;

/**
 * 渲染折线图
 */
- (void)drawLineChart;

/**
 * 开始动画
 */
- (void)startAnimation:(NSTimeInterval)duration;

@end
