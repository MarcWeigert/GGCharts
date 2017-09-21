//
//  GGPolygon.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGLine.h"

NS_ASSUME_NONNULL_BEGIN

struct GGPolygon {
    CGFloat radius;
    CGPoint center;
    NSInteger side;
    CGFloat radian;
};
typedef struct GGPolygon GGPolygon;

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

CG_INLINE GGPolygon
GGPolygonCopy(GGPolygon polygon)
{
    return GGPolygonMake(polygon.radius, polygon.center.x, polygon.center.y, polygon.side, polygon.radian);
}

CG_INLINE GGLine
GGPolygonGetLine(GGPolygon polygon, NSInteger index)
{
    CGFloat x = polygon.center.x - polygon.radius * sin(2 * M_PI * index / polygon.side + polygon.radian);
    CGFloat y = polygon.center.y - polygon.radius * cos(2 * M_PI * index / polygon.side + polygon.radian);
    
    return GGPointLineMake(polygon.center, CGPointMake(x, y));
}

NS_ASSUME_NONNULL_END
