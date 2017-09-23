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
 *
 * @param ref 路径
 * @param pie 结构体
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

#pragma mark - Animation

/**
 * 生成每一帧扇形图旋转填充动画
 *
 * @param pie 结构体
 * @param duration 时间间距
 */
NSArray * RotationAnimaitonWithPie(GGPie pie, NSTimeInterval duration)
{
    NSMutableArray * array = [NSMutableArray array];
    
    NSInteger frame = duration * 60 * 60;
    CGFloat frame_arc = pie.arc / frame;
    
    for (NSInteger i = 0; i < frame; i++) {
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPie frame_pie = GGPieCopyWithPie(pie);
        frame_pie.arc = frame_arc * i;
        GGPathAddPie(ref, frame_pie);
        [array addObject:(__bridge id)ref];
        CFRelease(ref);
    }
    
    return [NSArray arrayWithArray:array];
}

/**
 * 生成每一帧扇形弹射动画
 *
 * @param pie 结构体
 * @param duration 时间间距
 */
NSArray * EjectAnimationWithPie(GGPie pie, NSTimeInterval duration)
{
    NSMutableArray * array = [NSMutableArray array];
    
    CGFloat radius_ratio = .2f;
    
    CGFloat frame = duration * 60 * 60;
    CGFloat out_frame = frame * (1.0f - radius_ratio);
    CGFloat in_frame = frame * radius_ratio;
    
    CGFloat outSide = (pie.radiusRange.outRadius - pie.radiusRange.inRadius) * radius_ratio;
    CGFloat full_radius = (pie.radiusRange.outRadius - pie.radiusRange.inRadius + outSide);
    CGFloat frame_radius = full_radius / out_frame;
    CGFloat in_frame_radius = outSide / in_frame;
    
    for (long i = 0; i < out_frame; i++) {
    
        CGMutablePathRef ref = CGPathCreateMutable();
        pie.radiusRange.outRadius = pie.radiusRange.inRadius + frame_radius * i;
        GGPathAddPie(ref, pie);
        [array addObject:(__bridge id)ref];
        CFRelease(ref);
    }
    
    for (long i = 0; i < in_frame; i++) {
    
        CGMutablePathRef ref = CGPathCreateMutable();
        pie.radiusRange.outRadius = pie.radiusRange.inRadius + full_radius - (in_frame_radius * i);
        GGPathAddPie(ref, pie);
        [array addObject:(__bridge id)ref];
        CFRelease(ref);
    }
    
    return array;
}

#pragma mark - NSValue

@implementation NSValue (GGValuePieExtensions)

GGValueMethodImplementation(GGPie);

@end

NS_ASSUME_NONNULL_END
