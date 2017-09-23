//
//  GGArc.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

struct GGArc {
    CGFloat start;
    CGFloat end;
    CGFloat radius;
    CGPoint center;
};
typedef struct GGArc GGArc;

CG_INLINE GGArc
GGArcMake(CGFloat x, CGFloat y, CGFloat start, CGFloat end, CGFloat radius)
{
    GGArc arc;
    arc.center = CGPointMake(x, y);
    arc.start = start; arc.end = end;
    arc.radius = radius;
    return arc;
}

CG_INLINE GGArc
GGArcCenterMake(CGPoint center, CGFloat start, CGFloat end, CGFloat radius)
{
    GGArc arc;
    arc.start = start; arc.end = end;
    arc.radius = radius;
    arc.center = center;
    return arc;
}
