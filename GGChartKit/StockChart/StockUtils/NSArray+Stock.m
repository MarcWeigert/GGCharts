//
//  NSArray+Stock.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NSArray+Stock.h"

@implementation NSArray (Stock)

/**
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getMax:(CGFloat *)max min:(CGFloat *)min selGetter:(SEL)getter base:(CGFloat)base
{
    if (!self.count) { NSLog(@"array is empty"); return; }
    
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {

        IMP imp = [obj methodForSelector:getter];
        CGFloat (*objGetter)(id obj, SEL getter) = (void *)imp;
        CGFloat objNumber = objGetter(obj, getter);
        
        chartMax = objNumber > chartMax ? objNumber : chartMax;
        chartMin = objNumber < chartMin ? objNumber : chartMin;
    }];
    
    CGFloat baseScaler = fabs(chartMax - chartMin) * base;
        
    *max = chartMax += baseScaler;
    *min = chartMin -= baseScaler;
}

@end
