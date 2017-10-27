//
//  GGLine.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGLine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 增加线路径
 *
 * @param ref 路径结构体
 * @param line 直线结构体
 */
void GGPathAddLine(CGMutablePathRef ref, GGLine line)
{
    CGPathMoveToPoint(ref, NULL, line.start.x, line.start.y);
    CGPathAddLineToPoint(ref, NULL, line.end.x, line.end.y);
}

/**
 * 绘制折线
 *
 * @param ref 路径结构体
 * @param points 折线点
 * @param range 区间
 */
void GGPathAddRangePoints(CGMutablePathRef ref, CGPoint * points, NSRange range)
{
    BOOL isMovePoint = YES;
    
    NSUInteger size = NSMaxRange(range);
    
    for (NSInteger i = range.location; i < size; i++) {
        
        CGPoint point = points[i];
        
        if (CGPointEqualToPoint(point, CGPointMake(FLT_MIN, FLT_MIN))) {
            
            isMovePoint = YES;
            
            continue;
        }
        
        if (isMovePoint) {
            
            isMovePoint = NO;
            
            CGPathMoveToPoint(ref, NULL, point.x, point.y);
        }
        else {
            
            CGPathAddLineToPoint(ref, NULL, point.x, point.y);
        }
    }
}

/**
 * 绘制折线
 *
 * @param ref 路径结构体
 * @param points 折线点
 * @param size 折线大小
 */
void GGPathAddPoints(CGMutablePathRef ref, CGPoint * points, size_t size)
{
    GGPathAddRangePoints(ref, points, NSMakeRange(0, size));
}

/**
 * 折线每个点于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    for (NSInteger i = 0; i < size; i++) {
        
        CGPoint basePoints[size];
        
        for (NSInteger j = 0; j < size; j++) {
            
            basePoints[j] = CGPointMake(points[j].x, y);
        }
        
        for (NSInteger z = 0; z < i; z++) {
            
            basePoints[z] = CGPointMake(points[z].x, points[z].y);
        }
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathAddLines(ref, NULL, basePoints, size);
        [ary addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, points, size);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}

/**
 * 折线于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathLinesUpspringAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    CGPoint basePoints[size];
    
    for (NSInteger i = 0; i < size; i++) {
        
        basePoints[i] = CGPointMake(points[i].x, y);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, basePoints, size);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, points, size);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}

/**
 * 折线填充每个点于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathFillLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    for (NSInteger i = 0; i < size; i++) {
        
        CGPoint basePoints[size];
        
        for (NSInteger j = 0; j < size; j++) {
            
            basePoints[j] = CGPointMake(points[j].x, y);
        }
        
        for (NSInteger z = 0; z < i; z++) {
            
            basePoints[z] = CGPointMake(points[z].x, points[z].y);
        }
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathAddLines(ref, NULL, basePoints, size);
        CGPathAddLineToPoint(ref, NULL, basePoints[size - 1].x, y);
        CGPathAddLineToPoint(ref, NULL, basePoints[0].x, y);
        [ary addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, points, size);
    CGPathAddLineToPoint(ref, NULL, points[size - 1].x, y);
    CGPathAddLineToPoint(ref, NULL, points[0].x, y);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}

/**
 * 折线填充于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
NSArray * GGPathFillLinesUpspringAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    CGPoint basePoints[size];
    
    for (NSInteger i = 0; i < size; i++) {
        
        basePoints[i] = CGPointMake(points[i].x, y);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, basePoints, size);
    CGPathAddLineToPoint(ref, NULL, basePoints[size - 1].x, y);
    CGPathAddLineToPoint(ref, NULL, basePoints[0].x, y);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, points, size);
    CGPathAddLineToPoint(ref, NULL, points[size - 1].x, y);
    CGPathAddLineToPoint(ref, NULL, points[0].x, y);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}

/**
 * NSValue 扩展
 */
@implementation NSValue (GGValueGGLineExtensions)

GGValueMethodImplementation(GGLine);

@end

NS_ASSUME_NONNULL_END
