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

@interface GGLineChart : BaseLineBarChart

@property (nonatomic, strong) LineDataSet * lineDataSet;

- (void)drawLineChart;

- (void)startAnimation:(NSTimeInterval)duration;

@end
