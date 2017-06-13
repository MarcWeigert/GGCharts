//
//  NTPieChart.h
//  HSCharts
//
//  Created by _ | Durex on 2017/6/10.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"
#import "PieChartData.h"

@interface NTPieChart : BaseChart

@property (nonatomic, assign) CGFloat annularWidth;
@property (nonatomic, assign) CGFloat annularRadius;
@property (nonatomic, strong) NSArray <PieChartData *> *annularAry;

- (void)strockChart;

- (void)addAnimationWithDuration:(NSTimeInterval)duration;

@end
