//
//  GGKShape.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGKShape.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 绘制k线形
 *
 * @param ref 路径元素
 * @param kShape k线形态
 */
CG_EXTERN void GGPathAddKShape(CGMutablePathRef ref, GGKShape kShape)
{
    CGPathMoveToPoint(ref, NULL, kShape.top.x, kShape.top.y);
    CGPathAddLineToPoint(ref, NULL, kShape.top.x, kShape.rect.origin.y);
    CGPathAddRect(ref, NULL, kShape.rect);
    CGPathMoveToPoint(ref, NULL, kShape.end.x, CGRectGetMaxY(kShape.rect));
    CGPathAddLineToPoint(ref, NULL, kShape.end.x, kShape.end.y);
}

/**
 * 绘制k线形
 *
 * @param ref 路径元素
 * @param kShape k线形态
 */
CG_EXTERN void GGPathAddKShapes(CGMutablePathRef ref, GGKShape * kShapes, size_t size)
{
    for (int i = 0; i < size; i++) {
        
        GGPathAddKShape(ref, kShapes[i]);
    }
}

/**
 * NSValue 扩展
 */
@implementation NSValue (GGValueGGKShapeExtensions)

GGValueMethodImplementation(GGKShape);

@end

NS_ASSUME_NONNULL_END
