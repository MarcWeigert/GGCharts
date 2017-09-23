//
//  GGKShape.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

struct GGKShape {
    CGPoint top;
    CGRect rect;
    CGPoint end;
};
typedef struct GGKShape GGKShape;

CG_INLINE GGKShape
GGKShapeRectMake(CGPoint top, CGRect rect, CGPoint end)
{
    GGKShape kShape;
    kShape.top = top;
    kShape.rect = rect;
    kShape.end = end;
    return kShape;
}

/**
 * 绘制k线形
 * @param ref 路径元素
 * @param kShape k线形态
 */
CG_EXTERN void GGPathAddKShape(CGMutablePathRef ref, GGKShape kShape);

/**
 * 绘制k线形
 * @param ref 路径元素
 * @param kShape k线形态
 */
CG_EXTERN void GGPathAddKShapes(CGMutablePathRef ref, GGKShape * kShapes, size_t size);
