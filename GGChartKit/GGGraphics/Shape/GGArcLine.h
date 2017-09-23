//
//  GGArcLine.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

struct GGArcLine
{
    CGPoint center;
    CGFloat arc;
    CGFloat leg;
};
typedef struct GGArcLine GGArcLine;

CG_INLINE GGArcLine
GGArcLineMake(CGPoint center, CGFloat arc, CGFloat leg)
{
    GGArcLine arc_line;
    arc_line.center = center;
    arc_line.arc = arc;
    arc_line.leg = leg;
    return arc_line;
}

CG_INLINE GGLine
GGLineWithArcLine(GGArcLine arcLine, bool clockwise)
{
    int base = clockwise ? -1 : 1;
    
    CGFloat end_x = arcLine.center.x + cosf(arcLine.arc) * arcLine.leg * base;
    CGFloat end_y = arcLine.center.y + sinf(arcLine.arc) * arcLine.leg * base;
    
    return GGPointLineMake(arcLine.center, CGPointMake(end_x, end_y));
}

CG_INLINE CGPoint
GGGetLineEndPointArcMoveX(GGLine line, CGFloat move)
{
    CGFloat arc = GGYCircular(line);
    NSInteger base = arc > 0 ? 1 : -1;
    return CGPointMake(move * base + line.end.x, line.end.y);
}
