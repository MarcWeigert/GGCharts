//
//  GGPolygon.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGLine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 多边形
 */
struct GGPolygon {
    CGFloat radius;
    CGPoint center;
    NSInteger side;
    CGFloat radian;
};
typedef struct GGPolygon GGPolygon;

/**
 * 构造多边形接头体
 */
CG_INLINE GGPolygon
GGPolygonMake(CGFloat radius, CGFloat center_x, CGFloat center_y, NSInteger side, CGFloat radian)
{
    GGPolygon polygon;
    polygon.radius = radius;
    polygon.center = CGPointMake(center_x, center_y);
    polygon.side = side;
    polygon.radian = radian;
    return polygon;
}

/**
 * 结构体复制
 */
CG_INLINE GGPolygon
GGPolygonCopy(GGPolygon polygon)
{
    return GGPolygonMake(polygon.radius, polygon.center.x, polygon.center.y, polygon.side, polygon.radian);
}

/**
 * 获取多边形分割线
 *
 * @param polygon 多边形结构体
 * @param index 多边形第几条边
 */
CG_INLINE GGLine
GGPolygonGetLine(GGPolygon polygon, NSInteger index)
{
    CGFloat x = polygon.center.x - polygon.radius * sin(2 * M_PI * index / polygon.side + polygon.radian);
    CGFloat y = polygon.center.y - polygon.radius * cos(2 * M_PI * index / polygon.side + polygon.radian);
    
    return GGPointLineMake(polygon.center, CGPointMake(x, y));
}

/**
 * 绘制多边形
 *
 * @param ref 路径
 * @param polygon 结构体
 */
CG_EXTERN void GGPathAddGGPolygon(CGMutablePathRef ref, GGPolygon polygon);

/**
 * NSValue 扩展
 */
@interface NSValue (GGValueGGPolygonExtensions)

GGValueMethod(GGPolygon);

@end

NS_ASSUME_NONNULL_END
