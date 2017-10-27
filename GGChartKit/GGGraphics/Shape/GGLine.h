//
//  GGLine.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 直线结构体
 */
struct GGLine {
    CGPoint start;
    CGPoint end;
};
typedef struct GGLine GGLine;

/**
 * 构造直线结构体
 */
CG_INLINE GGLine
GGLineMake(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2)
{
    GGLine line;
    line.start = CGPointMake(x1, y1);
    line.end = CGPointMake(x2, y2);
    return line;
}

/**
 * 构造直线结构体
 */
CG_INLINE GGLine
GGPointLineMake(CGPoint start, CGPoint end)
{
    GGLine line;
    line.start = start;
    line.end = end;
    return line;
}

/**
 * 直线与X轴的弧度
 */
CG_INLINE double
GGXCircular(GGLine line)
{
    CGFloat x = line.end.x - line.start.x;
    CGFloat y = line.end.y - line.start.y;
    
    return atan2(y, x);
}

/**
 * 直线与Y轴的弧度
 */
CG_INLINE double
GGYCircular(GGLine line)
{
    CGFloat x = line.end.x - line.start.x;
    CGFloat y = line.end.y - line.start.y;
    
    return atan2(x, y);
}

/**
 * 直线与X轴弧度, 如果弧度小于0则加 M_PI * 2
 *
 * 用于扇形图
 */
CG_INLINE double
GGArcWithLine(GGLine line)
{
    CGFloat x_arc = GGXCircular(line);
    
    return x_arc < 0 ? M_PI * 2 + x_arc : x_arc;
}

/**
 * 获取基于某一点垂直于直线的点
 *
 * @param line 基准线
 * @param point 任意点
 * @param raidus 距离基准线长度
 *
 * @return 计算后的点
 */
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

/**
 * 顺延直线起点移动一定距离返回该点
 *
 * @param line 折线
 * @param move 移动距离
 * 
 * @return 移动后的点
 */
CG_INLINE CGPoint
GGMoveStart(GGLine line, CGFloat move)
{
    CGFloat x = line.start.x + move * cosf(GGXCircular(line));
    CGFloat y = line.start.y + move * sinf(GGXCircular(line));
    return CGPointMake(x, y);
}

/**
 * 顺延直线终点移动一定距离返回该点
 *
 * @param line 折线
 * @param move 移动距离
 *
 * @return 移动后的点
 */
CG_INLINE CGPoint
GGMoveEnd(GGLine line, CGFloat move)
{
    CGFloat x = line.end.x + move * cosf(GGXCircular(line));
    CGFloat y = line.end.y + move * sinf(GGXCircular(line));
    return CGPointMake(x, y);
}

/**
 * 顺延直线起点移动一定距离返回该线
 *
 * @param line 折线
 * @param move 移动距离
 *
 * @return 计算后的直线
 */
CG_INLINE GGLine
GGLineMoveStart(GGLine line, CGFloat move)
{
    CGPoint start = GGMoveStart(line, move);
    return GGPointLineMake(start, line.end);
}

/**
 * 顺延直线终点移动一定距离返回该线
 *
 * @param line 折线
 * @param move 移动距离
 *
 * @return 计算后的直线
 */
CG_INLINE GGLine
GGLineMoveEnd(GGLine line, CGFloat move)
{
    CGPoint end = GGMoveEnd(line, move);
    return GGPointLineMake(line.start, end);
}

/**
 * 获取直线长度
 */
CG_INLINE CGFloat
GGLengthLine(GGLine line)
{
    CGFloat w = line.start.x - line.end.x;
    CGFloat h = line.start.y - line.end.y;
    return sqrtf(h * h + w * w);
}

/**
 * 获取直线落于X轴长度
 */
CG_INLINE CGFloat
GGLineGetWidth(GGLine line)
{
    return fabs(line.end.x - line.start.x);
}

/**
 * 获取直线中心点坐标
 */
CG_INLINE CGPoint
GGCenterPoint(GGLine line)
{
    return CGPointMake(line.start.x + GGLineGetWidth(line) / 2, line.start.y);
}

/**
 * 获取Rect顶直线
 */
CG_INLINE GGLine
GGTopLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

/**
 * 获取Rect左直线
 */
CG_INLINE GGLine
GGLeftLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

/**
 * 获取Rect底直线
 */
CG_INLINE GGLine
GGBottomLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

/**
 * 获取Rect右直线
 */
CG_INLINE GGLine
GGRightLineRect(CGRect rect)
{
    return GGLineMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

/**
 * 获取Rect中, 垂直于Y轴的直线
 */
CG_INLINE GGLine
GGLineRectForX(CGRect rect, CGFloat x)
{
    x = x > CGRectGetMaxX(rect) ? CGRectGetMaxX(rect) : x;
    x = x < CGRectGetMinX(rect) ? CGRectGetMinX(rect) : x;
    
    return GGLineMake(x, CGRectGetMinY(rect), x, CGRectGetMaxY(rect));
}

/**
 * 获取Rect中, 垂直于X轴的直线
 */
CG_INLINE GGLine
GGLineRectForY(CGRect rect, CGFloat y)
{
    y = y > CGRectGetMaxY(rect) ? CGRectGetMaxY(rect) : y;
    y = y < CGRectGetMinY(rect) ? CGRectGetMinY(rect) : y;
    
    return GGLineMake(CGRectGetMinX(rect), y, CGRectGetMaxX(rect), y);
}

#pragma mark - Path

/**
 * 增加线路径
 *
 * @param ref 路径结构体
 * @param line 直线结构体
 */
CG_EXTERN void GGPathAddLine(CGMutablePathRef ref, GGLine line);

/**
 * 绘制折线
 *
 * @param ref 路径结构体
 * @param points 折线点
 * @param range 区间
 */
CG_EXTERN void GGPathAddRangePoints(CGMutablePathRef ref, CGPoint * points, NSRange range);

/**
 * 绘制折线
 *
 * @param ref 路径结构体
 * @param points 折线点
 * @param size 折线大小
 */
CG_EXTERN void GGPathAddPoints(CGMutablePathRef ref, CGPoint * points, size_t size);


#pragma mark - Path Animations

/**
 * 折线每个点于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
CG_EXTERN NSArray * GGPathLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y);

/**
 * 折线填充每个点于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
CG_EXTERN NSArray * GGPathFillLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y);

/**
 * 折线于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
CG_EXTERN NSArray * GGPathLinesUpspringAnimation(CGPoint * points, size_t size, CGFloat y);

/**
 * 折线填充于某一y坐标展开动画
 *
 * @param points 折线点
 * @param size 折线大小
 * @param y 指定y轴坐标
 *
 * @return 路径动画数组
 */
CG_EXTERN NSArray * GGPathFillLinesUpspringAnimation(CGPoint * points, size_t size, CGFloat y);

/**
 * NSValue 扩展
 */
@interface NSValue (GGValueGGLineExtensions)

GGValueMethod(GGLine);

@end

NS_ASSUME_NONNULL_END
