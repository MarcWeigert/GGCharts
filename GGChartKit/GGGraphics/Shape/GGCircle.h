//
//  GGCircle.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

struct GGCircle {
    CGPoint center;
    CGFloat radius;
};
typedef struct GGCircle GGCircle;

CG_INLINE GGCircle
GGCirclePointMake(CGPoint center, CGFloat radius)
{
    GGCircle circle;
    circle.center = center;
    circle.radius = radius;
    return circle;
}

CG_EXTERN void GGPathAddCircle(CGMutablePathRef ref, GGCircle circle);

CG_EXTERN void GGPathAddCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, size_t count);

CG_EXTERN void GGPathAddRangeCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, int from, int to);

CG_EXTERN NSArray * GGPathCirclesStrokeAnimationsPath(CGPoint * points, CGFloat radius, size_t size, NSArray * showIndex);

CG_EXTERN NSArray * GGPathCirclesStretchAnimation(CGPoint * points, CGFloat radius, size_t size, CGFloat y);

CG_EXTERN NSArray * GGPathCirclesUpspringAnimation(CGPoint * points, CGFloat radius, size_t size, CGFloat y, NSSet <NSNumber *> * showIndex);

CG_EXTERN NSArray * GGPathCirclesStrokeAnimation(CGPoint * points, CGFloat radius, size_t size, NSArray * showIndex);
