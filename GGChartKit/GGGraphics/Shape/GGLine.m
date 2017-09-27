//
//  GGLine.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGLine.h"

NS_ASSUME_NONNULL_BEGIN

void GGPathAddLine(CGMutablePathRef ref, GGLine line)
{
    CGPathMoveToPoint(ref, NULL, line.start.x, line.start.y);
    CGPathAddLineToPoint(ref, NULL, line.end.x, line.end.y);
}

/**
 * 绘制折线
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
 */
void GGPathAddPoints(CGMutablePathRef ref, CGPoint * points, size_t size)
{
    GGPathAddRangePoints(ref, points, NSMakeRange(0, size));
}

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

NS_ASSUME_NONNULL_END
