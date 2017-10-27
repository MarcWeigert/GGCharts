//
//  GGPie.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGPie.h"

#define SEC_FRAME       60 * 60

NS_ASSUME_NONNULL_BEGIN

/**
 * GGRadiusRange {0, 0}
 */
GGRadiusRange const GGRadiusRangeZero = {0, 0};

/**
 * GGPie {0, 0, 0, 0, 0, 0}
 */
GGPie const GGPieZero = {0, 0, 0, 0, 0, 0};

@implementation NSValue (GGValueRadiusRangeExtensions)

GGValueMethodImplementation(GGRadiusRange);

@end

/**
 * 字符串转换
 */
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
 * 绘制弧线
 *
 * @param ref 路径
 * @param center 中心点
 * @param radius 弧度
 * @param start 开始弧度
 * @param end 结束弧度
 */
void GGPathAddArc(CGMutablePathRef ref, CGPoint center, CGFloat radius, CGFloat start, CGFloat end)
{
    if (start == end) {
        
        GGPathAddCircle(ref, GGCirclePointMake(center, radius));
    }
    else {
    
        CGPathAddArc(ref, NULL, center.x, center.y, radius, start, end, false);
    }
}

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

/**
 * 获取进度结构体
 *
 * @param fromPie 开始pie结构体
 * @param toPie 结束pie结构体
 * @param progress 进度
 *
 * @return 结构体
 */
CG_EXTERN GGPie PieFromToWithProgress(GGPie from, GGPie to, CGFloat progress)
{
    CGFloat frame_transform = (to.transform - from.transform);
    CGFloat frame_arc = (to.arc - from.arc);
    CGFloat frame_in = (to.radiusRange.inRadius - from.radiusRange.inRadius);
    CGFloat frame_out = (to.radiusRange.outRadius - from.radiusRange.outRadius);
    
    GGPie pie = GGPieCopyWithPie(from);
    pie.transform += frame_transform * progress;
    pie.arc += frame_arc * progress;
    pie.radiusRange = GGRadiusRangeMake(pie.radiusRange.inRadius + frame_in * progress, pie.radiusRange.outRadius + frame_out * progress);

    return pie;
}

/**
 * 扇形图外边线
 *
 * @param ref 路径
 * @param pie 结构体
 * @param line1 第一根线长度
 * @param line2 第二根线长度
 * @param shapeRadius 终点远点半径
 * @param spacing 线间距
 *
 * @return 分割线终点
 */
CG_EXTERN CGPoint GGPathAddPieLine(CGMutablePathRef ref, GGPie pie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing)
{
    CGPoint draw_center = pie.center;
    GGArcLine arcLine = GGArcLineMake(draw_center, pie.transform + pie.arc / 2, line1);
    GGLine line = GGLineWithArcLine(arcLine, false);
    GGLine line_m = GGLineMoveStart(line, pie.radiusRange.outRadius + spacing);
    CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, line2);
    GGCircle circle = GGCirclePointMake(end_pt, shapeRadius);
    
    GGPathAddCircle(ref, circle);
    GGPathAddLine(ref, line_m);
    CGPathMoveToPoint(ref, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref, NULL, end_pt.x, end_pt.y);
    
    return end_pt;
}

/**
 * 扇形图外边线
 *
 * @param pie 结构体
 * @param line1 第一根线长度
 * @param line2 第二根线长度
 * @param shapeRadius 终点远点半径
 * @param spacing 线间距
 *
 * @return 分割线终点
 */
CG_EXTERN CGPoint PieLineEndPoint(GGPie pie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing)
{
    CGPoint draw_center = pie.center;
    GGArcLine arcLine = GGArcLineMake(draw_center, pie.transform + pie.arc / 2, line1);
    GGLine line = GGLineWithArcLine(arcLine, false);
    GGLine line_m = GGLineMoveStart(line, pie.radiusRange.outRadius + spacing);
    CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, line2);
    
    return end_pt;
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
    
    NSInteger frame = duration * SEC_FRAME;
    CGFloat frame_arc = pie.arc / frame;
    
    for (NSInteger i = 0; i < frame; i++) {
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPie frame_pie = GGPieCopyWithPie(pie);
        frame_pie.arc = frame_arc * i;
        GGPathAddPie(ref, frame_pie);
        [array addObject:(__bridge id)ref];
        CGPathRelease(ref);
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
    
    CGFloat frame = duration * SEC_FRAME;
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
        CGPathRelease(ref);
    }
    
    for (long i = 0; i < in_frame; i++) {
    
        CGMutablePathRef ref = CGPathCreateMutable();
        pie.radiusRange.outRadius = pie.radiusRange.inRadius + full_radius - (in_frame_radius * i);
        GGPathAddPie(ref, pie);
        [array addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    return array;
}

/**
 * 生成变换扇形图动画
 *
 * @param fromPie 开始结构体
 * @param toPie 变换结构体
 * @param duration 动画时间
 */
NSArray * GGPieChange(GGPie fromPie, GGPie toPie, NSTimeInterval duration)
{
    NSInteger frame = duration * SEC_FRAME;
    NSMutableArray * array = [NSMutableArray array];
    
    CGFloat frame_transform = (toPie.transform - fromPie.transform) / frame;
    CGFloat frame_arc = (toPie.arc - fromPie.arc) / frame;
    CGFloat frame_in = (toPie.radiusRange.inRadius - fromPie.radiusRange.inRadius) / frame;
    CGFloat frame_out = (toPie.radiusRange.outRadius - fromPie.radiusRange.outRadius) / frame;
    
    for (NSInteger i = 0; i < frame; i++) {
        
        fromPie.transform += frame_transform;
        fromPie.arc += frame_arc;
        fromPie.radiusRange.inRadius += frame_in;
        fromPie.radiusRange.outRadius += frame_out;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddPie(ref, fromPie);
        [array addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    return array;
}

/**
 * 扇形图伸展线伸展动画
 * @param pie 结构体
 * @param line1 第一根线长度
 * @param line2 第二根线长度
 * @param shapeRadius 终点远点半径
 * @param spacing 线间距
 *
 * @return 动画数组
 */
CG_EXTERN NSArray * GGPieLineStretch(GGPie pie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing)
{
    CGPoint draw_center = pie.center;
    GGArcLine arcLine = GGArcLineMake(draw_center, pie.transform + pie.arc / 2, line1);
    GGLine line = GGLineWithArcLine(arcLine, false);
    GGLine line_m = GGLineMoveStart(line, pie.radiusRange.outRadius + spacing);
    CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, line2);
    GGCircle circle = GGCirclePointMake(end_pt, shapeRadius);
    
    CGMutablePathRef ref1 = CGPathCreateMutable();
    CGMutablePathRef ref2 = CGPathCreateMutable();
    CGMutablePathRef ref3 = CGPathCreateMutable();
    CGMutablePathRef ref4 = CGPathCreateMutable();
    CGMutablePathRef ref5 = CGPathCreateMutable();
    CGMutablePathRef ref6 = CGPathCreateMutable();
    
    CGPathMoveToPoint(ref1, NULL, line_m.start.x, line_m.start.y);
    CGPathAddLineToPoint(ref1, NULL, line_m.start.x, line_m.start.y);
    
    CGPathMoveToPoint(ref2, NULL, line_m.start.x, line_m.start.y);
    CGPathAddLineToPoint(ref2, NULL, line_m.end.x, line_m.end.y);
    
    GGPathAddLine(ref3, line_m);
    CGPathMoveToPoint(ref3, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref3, NULL, circle.center.x, circle.center.y);
    
    GGPathAddLine(ref4, line_m);
    CGPathMoveToPoint(ref4, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref4, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref4, circle);
    
    GGPathAddLine(ref5, line_m);
    CGPathMoveToPoint(ref5, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref5, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref5, GGCirclePointMake(circle.center, circle.radius + circle.radius * .2f));
    
    GGPathAddLine(ref6, line_m);
    CGPathMoveToPoint(ref6, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref6, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref6, circle);
    
    NSArray * paths = @[(__bridge id)ref1, (__bridge id)ref2, (__bridge id)ref3,
                        (__bridge id)ref4, (__bridge id)ref5, (__bridge id)ref6];
    
    CGPathRelease(ref1);
    CGPathRelease(ref2);
    CGPathRelease(ref3);
    CGPathRelease(ref4);
    CGPathRelease(ref5);
    CGPathRelease(ref6);
    
    return paths;
}

/**
 * 扇形图伸展线伸展动画
 * @param fromPie 开始pie结构体
 * @param toPie 结束pie结构体
 * @param line1 第一根线长度
 * @param line2 第二根线长度
 * @param shapeRadius 终点远点半径
 * @param spacing 线间距
 * @param duration 动画时间
 *
 * @return 动画数组
 */
CG_EXTERN NSArray * GGPieLineChange(GGPie fromPie, GGPie toPie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing, NSTimeInterval duration)
{
    NSInteger frame = duration * SEC_FRAME;
    NSMutableArray * array = [NSMutableArray array];
    
    CGFloat frame_transform = (toPie.transform - fromPie.transform) / frame;
    CGFloat frame_arc = (toPie.arc - fromPie.arc) / frame;
    CGFloat frame_in = (toPie.radiusRange.inRadius - fromPie.radiusRange.inRadius) / frame;
    CGFloat frame_out = (toPie.radiusRange.outRadius - fromPie.radiusRange.outRadius) / frame;
    
    for (NSInteger i = 0; i < frame; i++) {
        
        fromPie.transform += frame_transform;
        fromPie.arc += frame_arc;
        fromPie.radiusRange.inRadius += frame_in;
        fromPie.radiusRange.outRadius += frame_out;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddPieLine(ref, fromPie, line1, line2, shapeRadius, spacing);
        [array addObject:(__bridge id)ref];
        
        CGPathRelease(ref);
    }
    
    return array;
}

#pragma mark - NSValue

@implementation NSValue (GGValuePieExtensions)

GGValueMethodImplementation(GGPie);

@end

NS_ASSUME_NONNULL_END
