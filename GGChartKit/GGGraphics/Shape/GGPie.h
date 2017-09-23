//
//  GGPie.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
CG_EXTERN const GGPie CGPieZero;

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
 * 拷贝
 */
CG_INLINE GGPie
GGPieCopyWithPie(GGPie pie)
{
    return GGPieCenterRaiusRangeMake(pie.center, pie.radiusRange, pie.arc, pie.transform);
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
 * 绘制扇形
 *
 * @param ref 路径
 * @param pie 结构体
 */
CG_EXTERN void GGPathAddPie(CGMutablePathRef ref, GGPie pie);

#pragma mark - Animation

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

#pragma mark - GGValuePieExtensions

@interface NSValue (GGValuePieExtensions)

GGValueMethod(GGPie);

@end

NS_ASSUME_NONNULL_END
