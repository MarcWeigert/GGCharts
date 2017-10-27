//
//  GGAxis.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 轴结构体
 */
struct GGAxis {
    GGLine line;        ///< 基准线
    CGFloat over;       ///< 轴分割线长度
    CGFloat sep;        ///< 轴分割距离
};
typedef struct GGAxis GGAxis;

/**
 * 构造函数
 */
CG_INLINE GGAxis
GGAxisMake(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat over, CGFloat sep) {
    GGAxis axis;
    axis.line = GGLineMake(x1, y1, x2, y2);
    axis.over = over;
    axis.sep = sep;
    return axis;
}

/**
 * 构造函数
 */
CG_INLINE GGAxis
GGAxisLineMake(GGLine line, CGFloat over, CGFloat sep) {
    GGAxis axis;
    axis.line = line;
    axis.over = over;
    axis.sep = sep;
    return axis;
}

/**
 * 绘制轴
 *
 * @param ref 路径结构
 * @param axis 绘制结构体
 */
CG_EXTERN void GGPathAddGGAxis(CGMutablePathRef ref, GGAxis axis);

/**
 * NSValue 扩展
 */
@interface NSValue (GGValueGGAxisExtensions)

GGValueMethod(GGAxis);

@end

NS_ASSUME_NONNULL_END
