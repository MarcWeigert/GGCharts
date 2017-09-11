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
    
    return atan2(y, x);
}

CG_INLINE double
GGYCircular(GGLine line)
{
    CGFloat x = line.end.x - line.start.x;
    CGFloat y = line.end.y - line.start.y;
    
    return atan2(x, y);
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

CG_INLINE GGLine
GGLineMoveStart(GGLine line, CGFloat move)
{
    CGPoint start = GGMoveStart(line, move);
    return GGPointLineMake(start, line.end);
}

CG_INLINE GGLine
GGLineMoveEnd(GGLine line, CGFloat move)
{
    CGPoint end = GGMoveEnd(line, move);
    return GGPointLineMake(line.start, end);
}

CG_INLINE CGFloat
GGLengthLine(GGLine line)
{
    CGFloat w = line.start.x - line.end.x;
    CGFloat h = line.start.y - line.end.y;
    return sqrtf(h * h + w * w);
}

CG_INLINE CGFloat
GGLineGetWidth(GGLine line)
{
    return fabs(line.end.x - line.start.x);
}

CG_INLINE CGPoint
GGCenterPoint(GGLine line)
{
    return CGPointMake(line.start.x + GGLineGetWidth(line) / 2, line.start.y);
}

CG_INLINE GGLine
GGTopLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

CG_INLINE GGLine
GGLeftLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

CG_INLINE GGLine
GGBottomLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

CG_INLINE GGLine
GGRightLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

CG_INLINE GGLine
GGLineRectForX(CGRect rect, CGFloat x)
{
    x = x > CGRectGetMaxX(rect) ? CGRectGetMaxX(rect) : x;
    x = x < CGRectGetMinX(rect) ? CGRectGetMinX(rect) : x;
    
    return GGLineMake(x, CGRectGetMinY(rect), x, CGRectGetMaxY(rect));
}

CG_INLINE GGLine
GGLineRectForY(CGRect rect, CGFloat y)
{
    y = y > CGRectGetMaxY(rect) ? CGRectGetMaxY(rect) : y;
    y = y < CGRectGetMinY(rect) ? CGRectGetMinY(rect) : y;
    
    return GGLineMake(CGRectGetMinX(rect), y, CGRectGetMaxX(rect), y);
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
    GGLine line;
    CGFloat side;
};
typedef struct GGArrow GGArrow;

CG_INLINE GGArrow
GGArrowLineMake(GGLine line, CGFloat side) {
    GGArrow arrow;
    arrow.line = line;
    arrow.side = side;
    return arrow;
}

CG_INLINE GGArrow
GGArrowMake(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat side) {
    
    return GGArrowLineMake(GGLineMake(x1, y1, x2, y2), side);
}

#pragma mark - 网格

struct GGGrid
{
    CGRect rect;
    CGFloat y_dis;     ///< y 轴分割
    CGFloat x_dis;     ///< x 轴分割
};
typedef struct GGGrid GGGrid;

CG_INLINE GGGrid
GGGridMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height, CGFloat y_dis, CGFloat x_dis) {
    GGGrid grid;
    grid.rect = CGRectMake(x, y, width, height);
    grid.y_dis = y_dis;
    grid.x_dis = x_dis;
    return grid;
}

CG_INLINE GGGrid
GGGridRectMake(CGRect rect, CGFloat y_dis, CGFloat x_dis) {
    GGGrid grid;
    grid.rect = rect;
    grid.y_dis = y_dis;
    grid.x_dis = x_dis;
    return grid;
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

#pragma mark - K线形态

struct GGKShape {
    CGPoint top;
    CGRect rect;
    CGPoint end;
};
typedef struct GGKShape GGKShape;

CG_INLINE GGKShape
GGKShapeRectMake(CGPoint top, CGRect rect, CGPoint end)
{
    GGKShape kShape;
    kShape.top = top;
    kShape.rect = rect;
    kShape.end = end;
    return kShape;
}

#pragma mark - 区域

CG_INLINE CGRect
GGLineDownRectMake(CGPoint start, CGPoint end, CGFloat width)
{
    CGPoint ben = start.y > end.y ? end : start;
    CGRect rect;
    rect.origin = CGPointMake(ben.x - width / 2, ben.y);
    rect.size = CGSizeMake(width, fabs(start.y - end.y));
    return rect;
}

CG_INLINE CGRect
GGLineSideRect(CGPoint start, CGPoint end, CGFloat width)
{
    CGRect rect;
    rect.origin = CGPointMake(start.x - width / 2, start.y);
    rect.size = CGSizeMake(width, start.y - end.y);
    return rect;
}

#pragma mark - 圆

struct GGCircle {
    CGPoint center;
    CGFloat radius;
};
typedef struct GGCircle GGCircle;

CG_INLINE GGCircle
GGCirclePointMake(CGPoint center, CGFloat radius)
{
    GGCircle circle;
    circle.center = center;
    circle.radius = radius;
    return circle;
}

#pragma mark - 弧度线

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

#pragma mark - 范围

struct GGSizeRange
{
    CGFloat max;
    CGFloat min;
};
typedef struct GGSizeRange GGSizeRange;

CG_INLINE GGSizeRange
GGSizeRangeMake(CGFloat max, CGFloat min)
{
    GGSizeRange range;
    range.max = max;
    range.min = min;
    
    return range;
}

CG_INLINE BOOL
GGSizeRangeEqual(GGSizeRange size_range1, GGSizeRange size_range2)
{
    return size_range1.max == size_range2.max && size_range1.min == size_range2.min;
}
