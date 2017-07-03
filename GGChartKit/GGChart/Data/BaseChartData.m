//
//  BaseChartData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChartData.h"

@implementation BaseChartData

- (void)getMax:(CGFloat *)max min:(CGFloat *)min
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self.dataSet enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        chartMax = obj.floatValue > chartMax ? obj.floatValue : chartMax;
        chartMin = obj.floatValue < chartMin ? obj.floatValue : chartMin;
    }];
    
    *max = chartMax;
    *min = chartMin;
}

+ (void)getChartDataAry:(NSArray *)dataAry max:(CGFloat *)max min:(CGFloat *)min
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [dataAry enumerateObjectsUsingBlock:^(BaseChartData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.dataSet enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
            
            chartMax = obj.floatValue > chartMax ? obj.floatValue : chartMax;
            chartMin = obj.floatValue < chartMin ? obj.floatValue : chartMin;
        }];
    }];
    
    *max = chartMax;
    *min = chartMin;
}

+ (NSInteger)getMaxColum:(NSArray <BaseChartData *> *)array
{
    __block NSInteger maxColum = 0;
    
    [array enumerateObjectsUsingBlock:^(BaseChartData * obj, NSUInteger idx, BOOL * stop) {
        
        maxColum = maxColum < obj.dataSet.count ? obj.dataSet.count : maxColum;
    }];
    
    return maxColum;
}

@end
