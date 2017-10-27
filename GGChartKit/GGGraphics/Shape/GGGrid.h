//
//  GGGrid.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 网格结构体
 */
struct GGGrid
{
    CGRect rect;
    CGFloat y_dis;     ///< y 轴分割
    CGFloat x_dis;     ///< x 轴分割
};
typedef struct GGGrid GGGrid;

/**
 * 构造函数
 */
CG_INLINE GGGrid
GGGridMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height, CGFloat y_dis, CGFloat x_dis) {
    GGGrid grid;
    grid.rect = CGRectMake(x, y, width, height);
    grid.y_dis = y_dis;
    grid.x_dis = x_dis;
    return grid;
}

/**
 * 构造函数
 */
CG_INLINE GGGrid
GGGridRectMake(CGRect rect, CGFloat y_dis, CGFloat x_dis) {
    GGGrid grid;
    grid.rect = rect;
    grid.y_dis = y_dis;
    grid.x_dis = x_dis;
    return grid;
}

/**
 * 绘制网格
 */
CG_EXTERN void GGPathAddGrid(CGMutablePathRef ref, GGGrid grid);

/**
 * NSValue 扩展
 */
@interface NSValue (GGValueGGGridExtensions)

GGValueMethod(GGGrid);

@end

NS_ASSUME_NONNULL_END
