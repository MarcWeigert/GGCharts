//
//  GGPie.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define radiansToDegrees(x) (180.0 * x / M_PI)   ///< 弧度转角度

#define degreesToRadians(x) (x / 180.f * M_PI)   ///< 角度转弧度

#pragma mark - GGRadiusRange

struct GGRadiusRange
{
    CGFloat inRadius;
    CGFloat outRadius;
};
typedef struct GGRadiusRange GGRadiusRange;

/**
 * GGRadiusRange {0, 0}
 */
CG_EXTERN const GGRadiusRange GGRadiusRangeZero;

/**
 * 初始化
 */
CG_INLINE GGRadiusRange
GGRadiusRangeMake(CGFloat inRadius, CGFloat outRadius)
{
    GGRadiusRange radiusRange;
    radiusRange.inRadius = inRadius;
    radiusRange.outRadius = outRadius;
    return radiusRange;
}

/**
 * 获取间距
 */
CG_INLINE CGFloat
GGRadiusRangeGetRadius(GGRadiusRange radiusRange)
{
    return fabs(radiusRange.inRadius - radiusRange.outRadius);
}

/**
 * 长度是否在区间内
 */
CG_INLINE bool
GGRadiusContainsLength(CGFloat length, GGRadiusRange radiusRange)
{
    return (length >= radiusRange.inRadius && length <= radiusRange.outRadius);
}

#pragma mark - GGValueRadiusRangeExtensions

@interface NSValue (GGValueRadiusRangeExtensions)

GGValueMethod(GGRadiusRange);

@end

#pragma mark - GGPie

struct GGPie
{
    CGPoint center;
    GGRadiusRange radiusRange;
    CGFloat arc;
    CGFloat transform;
};
typedef struct GGPie GGPie;

/**
 * GGPie {0, 0, 0, 0, 0, 0}
 */
CG_EXTERN const GGPie GGPieZero;

/**
 * 字符串转换
 */
FOUNDATION_EXPORT NSString * NSStringFromPie(GGPie pie);

/**
 * 初始化
 */
CG_INLINE GGPie
GGPieMake(CGFloat x, CGFloat y, CGFloat inRadius, CGFloat outRadius, CGFloat arc, CGFloat transform)
{
    GGPie pie;
    pie.center = CGPointMake(x, y);
    pie.radiusRange = GGRadiusRangeMake(inRadius, outRadius);
    pie.arc = arc;
    pie.transform = transform;
    return pie;
}

CG_INLINE GGPie
GGPieCenterMake(CGPoint center, CGFloat inRadius, CGFloat outRadius, CGFloat arc, CGFloat transform)
{
    return GGPieMake(center.x, center.y, inRadius, outRadius, arc, transform);
}

CG_INLINE GGPie
GGPieCenterRaiusRangeMake(CGPoint center, GGRadiusRange radiusRange, CGFloat arc, CGFloat transform)
{
    return GGPieMake(center.x, center.y, radiusRange.inRadius, radiusRange.outRadius, arc, transform);
}

/**
 * 判断结构体是否为空
 */
CG_INLINE bool
GGPieIsEmpty(GGPie pie)
{
    return pie.arc == 0 &&
    pie.transform == 0 &&
    CGPointEqualToPoint(CGPointZero, pie.center) &&
    pie.radiusRange.inRadius == 0 &&
    pie.radiusRange.outRadius == 0;
}

/**
 * 获取 M_PI * 2 内弧度
 */
CG_INLINE CGFloat
GGArcConvert(CGFloat arc)
{
    while (arc > M_PI * 2) {
        
        arc -= M_PI * 2;
    }
    
    return arc;
}

/**
 * 判断弧度是否在pie区间
 */
CG_INLINE bool
GGPieContainsArc(GGPie pie, CGFloat arc)
{
    CGFloat transform = GGArcConvert(pie.transform);
    CGFloat max_arc = GGArcConvert(pie.transform + pie.arc);
    
    if (transform > max_arc) {
    
        transform = transform > M_PI ? -(M_PI * 2 - transform) : transform;
        max_arc = max_arc > M_PI ? -(M_PI * 2 - max_arc) : max_arc;
        arc = arc > M_PI ? -(M_PI * 2 - arc) : arc;
    }
    
    return arc >= transform && arc <= max_arc;
}

/**
 * 判断弧度是否在pie内
 */
CG_INLINE bool
GGPieContainsPoint(CGPoint point, GGPie pie)
{
    GGLine line = GGPointLineMake(pie.center, point);
    
    return GGRadiusContainsLength(GGLengthLine(line), pie.radiusRange) &&
    GGPieContainsArc(pie, GGArcWithLine(line));
}

/**
 * 拷贝
 */
CG_INLINE GGPie
GGPieCopyWithPie(GGPie pie)
{
    return GGPieCenterRaiusRangeMake(pie.center, pie.radiusRange, pie.arc, pie.transform);
}

/**
 * 扇形图分割线与Y轴夹角
 */
CG_INLINE CGFloat
GGPieLineYCircular(GGPie pie)
{
    GGArcLine arcLine = GGArcLineMake(pie.center, pie.transform + pie.arc / 2, pie.radiusRange.outRadius);
    GGLine line = GGLineWithArcLine(arcLine, false);
    
    return GGYCircular(line);
}

/**
 * 获取最大弧度, 小于M_PI
 */
CG_EXTERN CGFloat GGPieGetMaxArc(GGPie pie);

/**
 * 获取最小弧度, 小于M_PI
 */
CG_EXTERN CGFloat GGPieGetMinArc(GGPie pie);

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
CG_EXTERN void GGPathAddArc(CGMutablePathRef ref, CGPoint center, CGFloat radius, CGFloat start, CGFloat end);

/**
 * 绘制扇形
 *
 * @param ref 路径
 * @param pie 结构体
 */
CG_EXTERN void GGPathAddPie(CGMutablePathRef ref, GGPie pie);

/**
 * 获取进度结构体
 *
 * @param fromPie 开始pie结构体
 * @param toPie 结束pie结构体
 * @param progress 进度
 *
 * @return 结构体
 */
CG_EXTERN GGPie PieFromToWithProgress(GGPie from, GGPie to, CGFloat progress);

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
CG_EXTERN CGPoint GGPathAddPieLine(CGMutablePathRef ref, GGPie pie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing);

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
CG_EXTERN CGPoint PieLineEndPoint(GGPie pie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing);

#pragma mark - Animation Pie

/**
 * 生成每一帧扇形图旋转填充动画
 *
 * @param pie 结构体
 * @param duration 时间间距
 */
CG_EXTERN NSArray * RotationAnimaitonWithPie(GGPie pie, NSTimeInterval duration);

/**
 * 生成每一帧扇形弹射动画
 *
 * @param pie 结构体
 * @param duration 时间间距
 */
CG_EXTERN NSArray * EjectAnimationWithPie(GGPie pie, NSTimeInterval duration);

/**
 * 生成变换扇形图动画
 *
 * @param fromPie 开始结构体
 * @param toPie 变换结构体
 * @param duration 动画时间
 */
CG_EXTERN NSArray * GGPieChange(GGPie fromPie, GGPie toPie, NSTimeInterval duration);

#pragma mark - Animation PieLine

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
CG_EXTERN NSArray * GGPieLineStretch(GGPie pie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing);

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
CG_EXTERN NSArray * GGPieLineChange(GGPie fromPie, GGPie toPie, CGFloat line1, CGFloat line2, CGFloat shapeRadius, CGFloat spacing, NSTimeInterval duration);

#pragma mark - GGValuePieExtensions

@interface NSValue (GGValuePieExtensions)

GGValueMethod(GGPie);

@end

NS_ASSUME_NONNULL_END
