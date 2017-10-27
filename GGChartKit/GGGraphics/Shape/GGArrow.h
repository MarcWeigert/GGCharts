//
//  GGArrow.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 箭头
 */
struct GGArrow
{
    GGLine line;
    CGFloat side;
};
typedef struct GGArrow GGArrow;

/**
 * 构造函数
 */
CG_INLINE GGArrow
GGArrowLineMake(GGLine line, CGFloat side) {
    GGArrow arrow;
    arrow.line = line;
    arrow.side = side;
    return arrow;
}

/**
 * 构造函数
 */
CG_INLINE GGArrow
GGArrowMake(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat side) {
    
    return GGArrowLineMake(GGLineMake(x1, y1, x2, y2), side);
}

/**
 * 绘制粗箭头
 * 
 * @param ref 路径结构体
 * @param arrow 箭头结构体
 * @param barWidth 粗结构体
 */
CG_EXTERN void GGPathAddArrow(CGMutablePathRef ref, GGArrow arrow, CGFloat barWidth);

/**
 * NSValue 扩展
 */
@interface NSValue (GGValueGGArrowExtensions)

GGValueMethod(GGArrow);

@end

NS_ASSUME_NONNULL_END
