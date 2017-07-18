//
//  CAAnimation+CGPathCategory.m
//  111
//
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "CGPathCategory.h"
#import "GGChartGeometry.h"

void GGPathAddGGAxis(CGMutablePathRef ref, GGAxis axis)
{
    CGPathMoveToPoint(ref, NULL, axis.line.start.x, axis.line.start.y);
    CGPathAddLineToPoint(ref, NULL, axis.line.end.x, axis.line.end.y);
    
    CGFloat len = GGLengthLine(axis.line);
    NSInteger count = abs((int)(len / axis.sep)) + 1;
    
    for (int i = 0; i < count; i++) {
        
        CGPoint axis_pt = GGMoveStart(axis.line, axis.sep * i);
        CGPoint over_pt = GGPerpendicularMake(axis.line, axis_pt, axis.over);
        
        CGPathMoveToPoint(ref, NULL, axis_pt.x, axis_pt.y);
        CGPathAddLineToPoint(ref, NULL, over_pt.x, over_pt.y);
    }
}

void GGPathAddLine(CGMutablePathRef ref, GGLine line)
{
    CGPathMoveToPoint(ref, NULL, line.start.x, line.start.y);
    CGPathAddLineToPoint(ref, NULL, line.end.x, line.end.y);
}

void GGPathAddCGRect(CGMutablePathRef ref, CGRect rect)
{
    GGLine top = GGTopLineRect(rect);
    GGLine bottom = GGBottomLineRect(rect);
    GGLine left = GGLeftLineRect(rect);
    GGLine right = GGRightLineRect(rect);
    
    GGPathAddLine(ref, GGTopLineRect(rect));
    CGPathAddLineToPoint(ref, NULL, right.end.x, right.end.y);
    CGPathAddLineToPoint(ref, NULL, top.end.x, top.end.y);
    CGPathAddLineToPoint(ref, NULL, top.start.x, top.start.y);
    CGPathAddLineToPoint(ref, NULL, left.end.x, left.end.y);
    CGPathAddLineToPoint(ref, NULL, bottom.end.x, bottom.end.y);
    CGPathAddLineToPoint(ref, NULL, top.end.x, top.end.y);
}

CG_EXTERN void GGpathAddCGRects(CGMutablePathRef ref, CGRect * rects, size_t size)
{
    for (NSInteger i = 0; i < size; i++) {
        
        GGPathAddCGRect(ref, rects[i]);
    }
}

CG_EXTERN void GGPathAddCircle(CGMutablePathRef ref, GGCircle circle)
{
    CGPathAddEllipseInRect(ref, NULL, CGRectMake(circle.center.x - circle.radius, circle.center.y - circle.radius, circle.radius * 2, circle.radius * 2));
}

CG_EXTERN void GGPathAddCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, size_t count)
{
    for (int i = 0; i < count; i++) {
        GGCircle circle = GGCirclePointMake(center[i], radius);
        GGPathAddCircle(ref, circle);
    }
}


CG_EXTERN void GGPathAddRangeCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, int from, int to)
{
    for (int i = from; i < to; i++) {
        GGCircle circle = GGCirclePointMake(center[i], radius);
        GGPathAddCircle(ref, circle);
    }
}

CG_EXTERN void GGPathAddSector(CGMutablePathRef ref, GGSector sector)
{
    CGPathMoveToPoint(ref, NULL, sector.center.x, sector.center.y);
    CGPathAddArc(ref, NULL, sector.center.x, sector.center.y, sector.radius, sector.start, sector.end, false);
    CGPathAddArcToPoint(ref, NULL, sector.center.x, sector.center.y, sector.center.x, sector.center.y, 100);
}

/**
 * 绘制网格
 */
CG_EXTERN void GGPathAddGrid(CGMutablePathRef ref, GGGrid grid)
{
    CGFloat x = grid.rect.origin.x;
    CGFloat y = grid.rect.origin.y;
    
    NSInteger h_count = grid.y_dis == 0 ? 0 : CGRectGetHeight(grid.rect) / grid.y_dis + 1;    ///< 横线个数
    NSInteger v_count = grid.x_dis == 0 ? 0 : CGRectGetWidth(grid.rect) / grid.x_dis + 1;     ///< 纵线个数
    
    for (int i = 1; i < h_count; i++) {
        
        CGPoint start = CGPointMake(x, y + grid.y_dis * i);
        CGPoint end = CGPointMake(CGRectGetMaxX(grid.rect), y + grid.y_dis * i);
        
        CGPathMoveToPoint(ref, NULL, start.x, start.y);
        CGPathAddLineToPoint(ref, NULL, end.x, end.y);
    }
    
    for (int i = 1; i < v_count; i++) {
        
        CGPoint start = CGPointMake(x + grid.x_dis * i, y);
        CGPoint end = CGPointMake(x + grid.x_dis * i, CGRectGetMaxY(grid.rect));
        
        CGPathMoveToPoint(ref, NULL, start.x, start.y);
        CGPathAddLineToPoint(ref, NULL, end.x, end.y);
    }
    
    CGPathAddRect(ref, NULL, grid.rect);
}

/**
 * 绘制k线形
 * @param ref 路径元素
 * @param kShape k线形态
 */
CG_EXTERN void GGPathAddKShape(CGMutablePathRef ref, GGKShape kShape)
{
    CGPathMoveToPoint(ref, NULL, kShape.top.x, kShape.top.y);
    CGPathAddLineToPoint(ref, NULL, kShape.top.x, kShape.rect.origin.y);
    CGPathAddRect(ref, NULL, kShape.rect);
    CGPathMoveToPoint(ref, NULL, kShape.end.x, CGRectGetMaxY(kShape.rect));
    CGPathAddLineToPoint(ref, NULL, kShape.end.x, kShape.end.y);
}

/**
 * 绘制多边形
 */
CG_EXTERN void GGPathAddGGSide(CGMutablePathRef ref, GGSide side, CGFloat radian)
{
    CGPathMoveToPoint(ref, NULL, side.center.x, side.center.y - side.radius);
    
    for (NSInteger i = 1; i <= side.side; i++) {
        
        NSInteger x = side.center.x - side.radius * sin(2 * M_PI * i / side.side + radian);
        NSInteger y = side.center.y - side.radius * cos(2 * M_PI * i / side.side + radian);
        
        CGPathAddLineToPoint(ref, NULL, x, y);
    }
    
    CGPathAddLineToPoint(ref, NULL, side.center.x, side.center.y - side.radius);
}

/**
 * 绘制折线
 */
CG_EXTERN void GGPathAddRangePoints(CGMutablePathRef ref, CGPoint * points, NSRange range)
{
    BOOL isMovePoint = YES;
    
    NSUInteger size = NSMaxRange(range);
    
    for (NSInteger i = range.location; i < size; i++) {
        
        CGPoint point = points[i];
        
        if (CGPointEqualToPoint(point, CGPointMake(FLT_MIN, FLT_MIN))) {
            
            isMovePoint = YES;
            
            continue;
        }
        
        if (isMovePoint) {
            
            isMovePoint = NO;
            
            CGPathMoveToPoint(ref, NULL, point.x, point.y);
        }
        else {
            
            CGPathAddLineToPoint(ref, NULL, point.x, point.y);
        }
    }
}

/**
 * 绘制折线
 */
CG_EXTERN void GGPathAddPoints(CGMutablePathRef ref, CGPoint * points, size_t size)
{
    GGPathAddRangePoints(ref, points, NSMakeRange(0, size));
}

/**
 * 绘制k线形
 * @param ref 路径元素
 * @param kShape k线形态
 */
CG_EXTERN void GGPathAddKShapes(CGMutablePathRef ref, GGKShape * kShapes, size_t size)
{
    for (int i = 0; i < size; i++) {
        
        GGPathAddKShape(ref, kShapes[i]);
    }
}

CG_EXTERN NSArray * GGPathAnimationSectorEject(GGSector sector, long frame, CGFloat outSide)
{
    long out_frame = frame * .8f;
    long in_frame = frame *.2f;
    CGFloat frame_radius = (sector.radius + outSide) / out_frame;
    CGFloat in_frame_radius = outSide / in_frame;
    
    NSMutableArray * ary = [NSMutableArray array];
    
    for (long i = 0; i < out_frame; i++) {
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGSector frame_sec = GGSectorCenterMake(sector.center, sector.start, sector.end, 0 + frame_radius * i);
        GGPathAddSector(ref, frame_sec);
        [ary addObject:(__bridge id)ref];
        CFRelease(ref);
    }
    
    for (long i = 0; i < in_frame; i++) {
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGSector frame_sec = GGSectorCenterMake(sector.center, sector.start, sector.end, (sector.radius + 10) - in_frame_radius * i);
        GGPathAddSector(ref, frame_sec);
        [ary addObject:(__bridge id)ref];
        CFRelease(ref);
    }
    
    return [NSArray arrayWithArray:ary];
}

CG_EXTERN NSArray * GGPathAnimationArrayFor(GGSector sector, long frame)
{
    CGFloat arc = sector.start - sector.end;
    CGFloat frame_arc = arc / frame;
    NSMutableArray * ary = [NSMutableArray array];
    
    for (long i = 0; i < frame; i++) {
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGSector frame_sec = GGSectorCenterMake(sector.center, sector.start, sector.start - i * frame_arc, sector.radius);
        GGPathAddSector(ref, frame_sec);
        [ary addObject:(__bridge id)ref];
        CFRelease(ref);
    }
    
    return [NSArray arrayWithArray:ary];
}

CG_EXTERN void GGPathAddAnnular(CGMutablePathRef ref, GGAnnular annular)
{
    NSInteger base_x;
    NSInteger base_y;
    
    base_y = (annular.start > 0 && annular.start < M_PI) ? 1 : -1;
    base_x = (annular.start > M_PI / 2 && annular.start < M_PI * 1.5) ? -1 : 1;
    
    CGFloat start_sin_arc = sinf(annular.start);
    CGFloat start_cos_arc = cosf(annular.start);
    CGFloat start_s_x = annular.center.x + annular.radius * start_cos_arc * base_x;
    CGFloat start_s_y = annular.center.y + annular.radius * start_sin_arc * base_y;
    CGFloat start_e_x = annular.center.x + (annular.radius + annular.spa) * start_cos_arc * base_x;
    CGFloat start_e_y = annular.center.y + (annular.radius + annular.spa) * start_sin_arc * base_y;
    
    CGPathAddArc(ref, NULL, annular.center.x, annular.center.y, annular.radius, annular.start, annular.end, false);
    CGPathAddArc(ref, NULL, annular.center.x, annular.center.y, annular.radius + annular.spa, annular.end, annular.start, true);
    CGPathAddLineToPoint(ref, NULL, start_e_x, start_e_y);
    CGPathAddLineToPoint(ref, NULL, start_s_x, start_s_y);
}

CG_EXTERN NSArray * GGPathAnnularAnimationArrayFor(GGAnnular annular, long frame)
{
    CGFloat arc = annular.start - annular.end;
    CGFloat frame_arc = arc / frame;
    NSMutableArray * ary = [NSMutableArray array];
    
    for (long i = 0; i < frame; i++) {
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGAnnular frame_annular = GGAnnularCenterMake(annular.center, annular.start, annular.start - i * frame_arc, annular.radius, annular.spa);
        GGPathAddAnnular(ref, frame_annular);
        [ary addObject:(__bridge id)ref];
        CFRelease(ref);
    }
    
    return [NSArray arrayWithArray:ary];
}

CG_EXTERN NSArray * GGPathRectsStretchAnimation(CGRect * rects, size_t size, CGFloat y)
{
    CGMutablePathRef start = CGPathCreateMutable();
    CGMutablePathRef end = CGPathCreateMutable();
    
    for (int i = 0; i < size; i++) {
        
        CGRect end_rect = rects[i];
        CGRect start_rect = CGRectMake(end_rect.origin.x, y, end_rect.size.width, 0);
        GGPathAddCGRect(start, start_rect);
        GGPathAddCGRect(end, end_rect);
    }
    
    NSArray * ary = @[(__bridge id)start, (__bridge id)end];
    CGPathRelease(start);
    CGPathRelease(end);
    
    return ary;
}

CG_EXTERN NSArray * GGPathLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    for (NSInteger i = 0; i < size; i++) {
        
        CGPoint basePoints[size];
        
        for (NSInteger j = 0; j < size; j++) {
            
            basePoints[j] = CGPointMake(points[j].x, y);
        }
        
        for (NSInteger z = 0; z < i; z++) {
            
            basePoints[z] = CGPointMake(points[z].x, points[z].y);
        }
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathAddLines(ref, NULL, basePoints, size);
        [ary addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, points, size);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}

CG_EXTERN NSArray * GGPathCirclesStretchAnimation(CGPoint * points, CGFloat radius, size_t size, CGFloat y)
{
    NSMutableArray * ary = [NSMutableArray array];
    
    for (NSInteger i = 0; i < size; i++) {
        
        CGPoint basePoints[size];
        
        for (NSInteger j = 0; j < size; j++) {
            
            basePoints[j] = CGPointMake(points[j].x, y);
        }
        
        for (NSInteger z = 0; z < i; z++) {
            
            basePoints[z] = CGPointMake(points[z].x, points[z].y);
        }
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddRangeCircles(ref, basePoints, radius, 0, (int)i);
        GGPathAddRangeCircles(ref, basePoints, 0, (int)i, (int)size);
        [ary addObject:(__bridge id)ref];
        CGPathRelease(ref);
    }
    
    CGMutablePathRef ref = CGPathCreateMutable();
    GGPathAddCircles(ref, points, radius, size);
    [ary addObject:(__bridge id)ref];
    CGPathRelease(ref);
    
    return ary;
}
