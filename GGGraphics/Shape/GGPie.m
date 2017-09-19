//
//  GGPie.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGPie.h"

NS_ASSUME_NONNULL_BEGIN

GGRadiusRange const GGRadiusRangeZero = {0, 0};

GGPie const CGPieZero = {0, 0, 0, 0, 0, 0};

NSString * NSStringFromPie(GGPie pie)
{
    return [NSString stringWithFormat:@"center.x = %f, center.y = %f, raidus.in = %f, radius.out = %f, arc : %f, transform : %f",
            pie.center.x, pie.center.y, pie.radiusRange.inRadius, pie.radiusRange.outRadius, pie.arc, pie.transform];
}

/**
 * 小数取余
 */
CGFloat GetLessFloat(CGFloat value, CGFloat unit)
{
    while (value > unit) {
        
        value -= unit;
    }
    
    return value;
}

/**
 * 获取最大弧度, 小于M_PI
 */
CGFloat GGPieGetMaxArc(GGPie pie)
{
    return 0;
}

/**
 * 获取最小弧度, 小于M_PI
 */
CGFloat GGPieGetMinArc(GGPie pie)
{
    return 0;
}

#pragma mark - CGPath

/**
 * 绘制扇形
 */
void GGPathAddPie(CGMutablePathRef ref, GGPie pie)
{
    NSInteger base_x;
    NSInteger base_y;
    
    base_y = (pie.transform > 0 && pie.transform < M_PI) ? 1 : -1;
    base_x = (pie.transform > M_PI / 2 && pie.transform < M_PI * 1.5) ? -1 : 1;
    
    CGFloat start_sin_arc = sinf(pie.transform);
    CGFloat start_cos_arc = cosf(pie.transform);
    CGFloat start_s_x = pie.center.x + pie.radiusRange.inRadius * start_cos_arc * base_x;
    CGFloat start_s_y = pie.center.y + pie.radiusRange.inRadius * start_sin_arc * base_y;
    CGFloat start_e_x = pie.center.x + (pie.radiusRange.inRadius + pie.radiusRange.outRadius) * start_cos_arc * base_x;
    CGFloat start_e_y = pie.center.y + (pie.radiusRange.inRadius + pie.radiusRange.outRadius) * start_sin_arc * base_y;
    
    CGPathAddArc(ref, NULL, pie.center.x, pie.center.y, pie.radiusRange.inRadius, pie.transform, pie.transform + pie.arc, false);
    CGPathAddArc(ref, NULL, pie.center.x, pie.center.y, pie.transform, pie.transform, pie.radiusRange.inRadius + pie.arc, true);
    CGPathAddLineToPoint(ref, NULL, start_e_x, start_e_y);
    CGPathAddLineToPoint(ref, NULL, start_s_x, start_s_y);
}

NS_ASSUME_NONNULL_END
