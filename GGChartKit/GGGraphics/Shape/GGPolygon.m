//
//  GGPolygon.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGPolygon.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 绘制多边形
 *
 * @param ref 路径
 * @param polygon 结构体
 */
void GGPathAddGGPolygon(CGMutablePathRef ref, GGPolygon polygon)
{
    CGPathMoveToPoint(ref, NULL, polygon.center.x, polygon.center.y - polygon.radius);
    
    for (NSInteger i = 1; i <= polygon.side; i++) {
        
        CGFloat x = polygon.center.x - polygon.radius * sin(2 * M_PI * i / polygon.side + polygon.radian);
        CGFloat y = polygon.center.y - polygon.radius * cos(2 * M_PI * i / polygon.side + polygon.radian);
        
        CGPathAddLineToPoint(ref, NULL, x, y);
    }
    
    CGPathAddLineToPoint(ref, NULL, polygon.center.x, polygon.center.y - polygon.radius);
}

/**
 * NSValue 扩展
 */
@implementation NSValue (GGValueGGPolygonExtensions)

GGValueMethodImplementation(GGPolygon);

@end

NS_ASSUME_NONNULL_END
