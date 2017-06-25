//
//  MassChartData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MassChartData.h"

@implementation MassChartData

+ (void)masDataAry:(NSArray <MassChartData *> *)masAry max:(CGFloat *)max min:(CGFloat *)min
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [masAry enumerateObjectsUsingBlock:^(MassChartData * obj, NSUInteger idx, BOOL * stop) {
        
        chartMax = obj.value > chartMax ? obj.value : chartMax;
        chartMin = obj.value < chartMin ? obj.value : chartMin;
    }];
    
    *max = chartMax;
    *min = chartMin;
}

@end
