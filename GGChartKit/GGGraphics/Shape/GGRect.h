//
//  GGRect.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 构造CGRect
 *
 * @param start 起点
 * @param end 终点
 * @param width 宽度
 */
CG_INLINE CGRect
GGLineDownRectMake(CGPoint start, CGPoint end, CGFloat width)
{
    CGPoint ben = start.y > end.y ? end : start;
    CGRect rect;
    rect.origin = CGPointMake(ben.x - width / 2, ben.y);
    rect.size = CGSizeMake(width, fabs(start.y - end.y));
    return rect;
}

#pragma mark - CGPath

/**
 * 绘制Rect
 *
 * @param ref 路径绘制类
 * @param rect 结构体
 */
CG_EXTERN void GGPathAddCGRect(CGMutablePathRef ref, CGRect rect);

/**
 * 绘制Rect
 *
 * @param ref 路径绘制类
 * @param rect 结构体指针
 * @param size 结构体大小
 */
CG_EXTERN void GGPathAddCGRects(CGMutablePathRef ref, CGRect * rects, size_t size);

#pragma mark - CGPath Animation

/**
 * 构造CGPath动画, 效果从某一y轴展开
 *
 * @param rects 结构体指针
 * @param size 结构体大小
 * @param y 指定y坐标
 */
CG_EXTERN NSArray * GGPathRectsStretchAnimation(CGRect * rects, size_t size, CGFloat y);

NS_ASSUME_NONNULL_END
