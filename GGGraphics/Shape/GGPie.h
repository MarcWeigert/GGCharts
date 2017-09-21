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

CG_EXTERN const GGRadiusRange GGRadiusRangeZero;

CG_INLINE GGRadiusRange
GGRadiusRangeMake(CGFloat inRadius, CGFloat outRadius)
{
    GGRadiusRange radiusRange;
    radiusRange.inRadius = inRadius;
    radiusRange.outRadius = outRadius;
    return radiusRange;
}

CG_INLINE CGFloat
GGRadiusRangeGetRadius(GGRadiusRange radiusRange)
{
    return fabs(radiusRange.inRadius - radiusRange.outRadius);
}

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

CG_EXTERN const GGPie CGPieZero;

FOUNDATION_EXPORT NSString * NSStringFromPie(GGPie pie);

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
 */
CG_EXTERN void GGPathAddPie(CGMutablePathRef ref, GGPie pie);

#pragma mark - NSValue

@interface NSValue (GGValuePieExtensions)

GGValueMethod(GGPie);

@end

NS_ASSUME_NONNULL_END
