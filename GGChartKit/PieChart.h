//
//  PieChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"
#import "PieChartData.h"

@interface PieChart : BaseChart

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) NSArray <PieChartData *> *sectorAry;

- (void)strockChart;

- (void)addAnimationWithDuration:(NSTimeInterval)duration;

@end
