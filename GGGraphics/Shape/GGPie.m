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

@implementation NSValue (GGValueRadiusRangeExtensions)

GGValueMethodImplementation(GGRadiusRange);

@end

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
    return GetLessFloat(pie.transform + pie.arc, M_PI);
}

/**
 * 获取最小弧度, 小于M_PI
 */
CGFloat GGPieGetMinArc(GGPie pie)
{
    return GetLessFloat(pie.arc, M_PI);
}

#pragma mark - CGPath

/**
 * 绘制扇形
 */
void GGPathAddPie(CGMutablePathRef ref, GGPie pie)
{
    CGFloat start = pie.transform;
    CGFloat end = pie.transform + pie.arc;

    CGFloat minRadius = pie.radiusRange.inRadius;
    CGFloat maxRadius = pie.radiusRange.outRadius;

    CGPathAddArc(ref, NULL, pie.center.x, pie.center.y, minRadius, start, end, false);
    CGPathAddArc(ref, NULL, pie.center.x, pie.center.y, maxRadius, end, start, true);
    
    CGPathCloseSubpath(ref);
}

#pragma mark - NSValue

@implementation NSValue (GGValuePieExtensions)

GGValueMethodImplementation(GGPie);

@end

NS_ASSUME_NONNULL_END
