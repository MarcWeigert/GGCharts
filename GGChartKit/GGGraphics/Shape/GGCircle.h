//
//  GGCircle.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 圆结构体
 */
struct GGCircle {
    CGPoint center;     ///< 中心点
    CGFloat radius;     ///< 半径
};
typedef struct GGCircle GGCircle;

/**
 * 构造函数
 */
CG_INLINE GGCircle
GGCirclePointMake(CGPoint center, CGFloat radius)
{
    GGCircle circle;
    circle.center = center;
    circle.radius = radius;
    return circle;
}

#pragma mark - CGPath

/**
 * 绘制圆
 *
 * @param ref 路径
 * @param circle 结构体
 */
CG_EXTERN void GGPathAddCircle(CGMutablePathRef ref, GGCircle circle);

/**
 * 绘制圆
 *
 * @param ref 路径
 * @param center 圆中心点指针
 * @param radius 圆半径
 * @param count 指针长度
 */
CG_EXTERN void GGPathAddCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, size_t count);

/**
 * 绘制圆
 *
 * @param ref 路径
 * @param center 圆中心点指针
 * @param radius 圆半径
 * @param from 区间
 * @param to 区间
 */
CG_EXTERN void GGPathAddRangeCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, int from, int to);


#pragma mark - CGPath Animations

/**
 * 圆划水动画
 *
 * @param points 圆中心点指针
 * @param radius 圆半径
 * @param size 指针长度
 * @param showIndex 显示索引
 */
CG_EXTERN NSArray * GGPathCirclesStrokeAnimationsPath(CGPoint * points, CGFloat radius, size_t size, NSArray * showIndex);

/**
 * 某一y轴每个远点逐一伸展动画
 *
 * @param points 圆中心点指针
 * @param radius 圆半径
 * @param size 指针长度
 * @param y 坐标值
 */
CG_EXTERN NSArray * GGPathCirclesStretchAnimation(CGPoint * points, CGFloat radius, size_t size, CGFloat y);

/**
 * 某一y轴伸展动画
 *
 * @param points 圆中心点指针
 * @param radius 圆半径
 * @param size 指针长度
 * @param y 坐标值
 * @param showIndex 显示索引
 */
CG_EXTERN NSArray * GGPathCirclesUpspringAnimation(CGPoint * points, CGFloat radius, size_t size, CGFloat y, NSSet <NSNumber *> * showIndex);

/**
 * 圆划水动画
 *
 * @param points 圆中心点指针
 * @param radius 圆半径
 * @param size 指针长度
 * @param showIndex 显示索引
 */
CG_EXTERN NSArray * GGPathCirclesStrokeAnimation(CGPoint * points, CGFloat radius, size_t size, NSArray * showIndex);

/**
 * NSValue 扩展
 */
@interface NSValue (GGValueGGCircleExtensions)

GGValueMethod(GGCircle);

@end

NS_ASSUME_NONNULL_END
