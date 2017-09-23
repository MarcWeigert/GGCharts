//
//  GGPolygon.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGPolygon.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 绘制多边形
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

NS_ASSUME_NONNULL_END
