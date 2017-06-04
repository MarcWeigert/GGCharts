//
//  GGChartGeometry.h
//  GGPlatform
//
//  Created by 黄舜 on 17/5/27.
//  Copyright © 2017年 Shanghai Suntime Information technology co., LTD. All rights reserved.
//

#include <CoreGraphics/CGBase.h>
#include <CoreFoundation/CFDictionary.h>
#include <CoreFoundation/CFBase.h>
#include <CoreFoundation/CFAvailability.h>
#include <CoreGraphics/CGGeometry.h>
#include <stdint.h>

enum GGDir {
    C = 0,
    N = 1,
    E = 2,
    W = 3,
    S = 4,
};

#pragma mark - 线

struct GGLine {
    CGPoint start;
    CGPoint end;
};
typedef struct GGLine GGLine;

CG_INLINE GGLine
GGLineMake(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2)
{
    GGLine line;
    line.start = CGPointMake(x1, y1);
    line.end = CGPointMake(x2, y2);
    return line;
}

CG_INLINE GGLine
GGPointLineMake(CGPoint start, CGPoint end)
{
    GGLine line;
    line.start = start;
    line.end = end;
    return line;
}

CG_INLINE double
GGXCircular(GGLine line)
{
    CGFloat x = line.end.x - line.start.x;
    CGFloat y = line.end.y - line.start.y;
    
    return atan(y / x);
}

CG_INLINE double
GGYCircular(GGLine line)
{
    CGFloat x = line.end.x - line.start.x;
    CGFloat y = line.end.y - line.start.y;
    
    return atan(x / y);
}

CG_INLINE CGPoint
GGPerpendicularMake(GGLine line, CGPoint point, CGFloat raidus)
{
    double m_h = raidus * cosf(GGXCircular(line));
    double m_w = raidus * sinf(GGXCircular(line));
    
    CGPoint perpendicular;
    perpendicular.x = point.x - m_w;
    perpendicular.y = point.y + m_h;
    
    return perpendicular;
}

CG_INLINE CGPoint
GGMoveStart(GGLine line, CGFloat move)
{
    CGFloat x = line.start.x + move * cosf(GGXCircular(line));
    CGFloat y = line.start.y + move * sinf(GGXCircular(line));
    return CGPointMake(x, y);
}

CG_INLINE CGPoint
GGMoveEnd(GGLine line, CGFloat move)
{
    CGFloat x = line.end.x + move * cosf(GGXCircular(line));
    CGFloat y = line.end.y + move * sinf(GGXCircular(line));
    return CGPointMake(x, y);
}

CG_INLINE CGFloat
GGLengthLine(GGLine line)
{
    CGFloat w = line.start.x - line.end.x;
    CGFloat h = line.start.y - line.end.y;
    return sqrtf(h * h + w * w);
}

#pragma mark - 轴

struct GGAxis {
    GGLine line;
    CGFloat over;
    CGFloat sep;
};
typedef struct GGAxis GGAxis;

CG_INLINE GGAxis
GGAxisMake(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat over, CGFloat sep) {
    GGAxis axis;
    axis.line = GGLineMake(x1, y1, x2, y2);
    axis.over = over;
    axis.sep = sep;
    return axis;
}

CG_INLINE GGAxis
GGAxisLineMake(GGLine line, CGFloat over, CGFloat sep) {
    GGAxis axis;
    axis.line = line;
    axis.over = over;
    axis.sep = sep;
    return axis;
}

#pragma mark - 箭头

struct GGArrow
{
    CGPoint center;
    CGFloat edge;
    CGFloat m_pi;
};
typedef struct GGArrow GGArrow;

CG_INLINE GGArrow
GGArrowMake(CGFloat x, CGFloat y, CGFloat edge, CGFloat m_pi) {
    GGArrow arrow;
    arrow.center = CGPointMake(x, y);
    arrow.edge = edge;
    arrow.m_pi = m_pi;
    return arrow;
}

CG_INLINE GGArrow
GGArrowCenterMake(CGPoint center, CGFloat edge, CGFloat m_pi) {
    GGArrow arrow;
    arrow.center = center;
    arrow.edge = edge;
    arrow.m_pi = m_pi;
    return arrow;
}

#pragma mark - 网格

struct GGGrid
{
    CGRect rect;
    int horizontal;
    int vertical;
};
typedef struct GGGrid GGGrid;

CG_INLINE GGGrid
GGGridMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height, int h, int v) {
    GGGrid grid;
    grid.rect = CGRectMake(x, y, width, height);
    grid.horizontal = h;
    grid.vertical = v;
    return grid;
}

CG_INLINE GGGrid
GGGridRectMake(CGRect rect, int h, int v) {
    GGGrid grid;
    grid.rect = rect;
    grid.horizontal = h;
    grid.vertical = v;
    return grid;
}

CG_INLINE CGPoint **
GGGridPointAryMake(GGGrid grid)
{
    CGPoint ** point_array = (CGPoint **)malloc(sizeof(CGPoint *) * grid.horizontal);
    
    for (int i = 0; i < grid.horizontal; i++) {
        
        point_array[i] = (CGPoint *)malloc(sizeof(CGPoint) * grid.vertical);
    }
    
    CGFloat x = grid.rect.origin.x;
    CGFloat y = grid.rect.origin.y;
    CGFloat h = grid.rect.size.width / (grid.horizontal - 1);
    CGFloat v = grid.rect.size.height / (grid.vertical - 1);
    
    for (int i = 0; i < grid.vertical; i++) {
        
        for (int j = 0; j < grid.horizontal; j++) {
            
            point_array[i][j] = CGPointMake(x + j * h, y + i * v);
        }
    }
 
    return point_array;
}

#pragma mark - 弧线

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

#pragma mark - 扇形

struct GGSector {
    CGFloat start;
    CGFloat end;
    CGFloat radius;
    CGPoint center;
};
typedef struct GGSector GGSector;

CG_INLINE GGSector
GGSectorMake(CGFloat x, CGFloat y, CGFloat start, CGFloat end, CGFloat radius)
{
    GGSector sector;
    sector.center = CGPointMake(x, y);
    sector.start = start; sector.end = end;
    sector.radius = radius;
    return sector;
}

CG_INLINE GGSector
GGSectorCenterMake(CGPoint center, CGFloat start, CGFloat end, CGFloat radius)
{
    GGSector sector;
    sector.center = center;
    sector.start = start; sector.end = end;
    sector.radius = radius;
    return sector;
}

#pragma mark - 扇形

struct GGAnnular {
    CGFloat start;
    CGFloat end;
    CGFloat spa;
    CGFloat radius;
    CGPoint center;
};
typedef struct GGAnnular GGAnnular;

CG_INLINE GGAnnular
GGAnnularCenterMake(CGPoint center, CGFloat start, CGFloat end, CGFloat radius, CGFloat spa)
{
    GGAnnular annular;
    annular.start = start; annular.end = end;
    annular.radius = radius;
    annular.center = center;
    annular.spa = spa;
    return annular;
};

CG_INLINE GGAnnular
GGAnnularMake(CGFloat x, CGFloat y, CGFloat start, CGFloat end, CGFloat radius, CGFloat spa)
{
    CGPoint center = CGPointMake(x, y);
    
    return GGAnnularCenterMake(center, start, end, radius, spa);
}

#pragma mark - 多边形

struct GGSide {
    CGFloat radius;
    CGPoint center;
    int side;
};
typedef struct GGSide GGSide;

#pragma mark - K线形态

struct GGKShape {
    GGLine line;
    CGRect rect;
};
typedef struct GGKShape GGKShape;
