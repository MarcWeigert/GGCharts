//
//  GGPieChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineBarChart.h"
#import "PieDataSet.h"

@interface GGPieChart : BaseLineBarChart

/**
 * 扇形图配置类
 */
@property (nonatomic, strong) PieDataSet * pieDataSet;

/**
 * 绘制扇形图表
 */
- (void)drawPieChart;

@end
