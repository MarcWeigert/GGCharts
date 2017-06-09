//
//  AnnularChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"
#import "PieChartData.h"

@interface AnnularChart : BaseChart

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) NSArray <PieChartData *> * aryPieChart;

@end
