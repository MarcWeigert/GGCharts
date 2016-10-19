//
//  DrawMath.h
//  FiveView
//
//  Created by _ | Durex on 16/4/15.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CGGeometry.h>

#define radiansToDegrees(x) (180.0 * x / M_PI)   ///< 弧度转角度

#define degreesToRadians(x) (x / 180.f * M_PI)   ///< 角度转弧度

#define OFFSET_X(A, B)  CGPointMake(A.x + B, A.y)

#define OFFSET_Y(A, B)  CGPointMake(A.x, A.y + B)

typedef CGFloat(^FltFunc)(CGFloat val);  ///< 计算出当前价格的点

typedef CGFloat(^FitFunc)(NSInteger index);

/**
 * 线之间夹角
 * center 两线起点
 * start 开始线终点
 * end 终点线终点
 */
CGFloat angleBetweenLines(CGPoint center, CGPoint start, CGPoint end);

/**
 * 根据起点, 直径, 角度返回终点(水平为0度)
 * point 起点
 * angle 角度
 * radius 直径
 * clockwise NO 顺时针
 */
CGPoint angleWithZero(CGPoint point, CGFloat angle, CGFloat radius,  BOOL clockwise);

/**
 * 判断两向量夹角是否大于180°, 大于180°返回真, 否则返回假
 */
BOOL signByCrossProduct(CGPoint cen, CGPoint first, CGPoint second);

/**
 * 判断是否在点是否在圆内
 */
BOOL isInEllipse(CGPoint cen, CGFloat radius, CGPoint point);

/**
 * 水平线夹角
 * clockwise NO 顺时针
 */
CGFloat angleHor(CGPoint cen, CGPoint point, BOOL clockwise);

/**
 * 是否在一个扇形区域内
 */
BOOL isInArc(CGPoint cen, CGPoint point, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise);

/**
 * 判断是否在点是否在圆内
 */
BOOL isInEllipse(CGPoint cen, CGFloat radius, CGPoint point);

/**
 * 是否在一个环形区域内
 */
BOOL isInRingArc(CGPoint cen, CGPoint point, CGFloat radius, CGFloat inner, CGFloat startAngle, CGFloat endAngle, BOOL clockwise);

/**
 * 是否在西半圆（顺时针）
 */
BOOL isWest(CGFloat angle);

/**
 * 最小位数字符串
 * 4500 返回 1000, 0.45 返回 0.1
 */
float fMinDigits(float num);

/**
 * 根据最大最小生成分段
 */
NSArray *makeBaseAry(float max, float min);

/** 
 * 一组点得中心点数组 
 */
NSArray *centerPoints(NSArray<NSValue *> *points);

/** 
 * 找到数组中最大数 
 */
float getMax(NSArray<NSNumber *> *array);

/** 
 * 找到数组中最小值 
 */
float getMin(NSArray<NSNumber *> *array);

/**  */
float getAryMin(NSArray <NSArray <NSNumber *> *> *array);

/**  */
float getAryMax(NSArray <NSArray <NSNumber *> *> *array);

/**
 * 二维数组累加, 正数和正数累加, 负数和负数累加
 * 正数:
 * @[@1, @1, @1]    @[@1, @1, @1]
 * @[@1, @1, @1] -> @[@2, @2, @2]
 * @[@1, @1, @1]    @[@3, @3, @3]
 * 负数:
 * @[@-1, @-1, @-1]      @[@-1, @-1, @-1]
 * @[@1,  @1,  @1]    -> @[@1, @1, @1]
 * @[@1,  @1,  @1]       @[@2, @2, @2]
 */
NSArray *aryAddup(NSArray <NSArray <NSNumber *> *> *aryData);

/** 
 * 通过最大最小值返回一个blcok 
 */
FltFunc funcAreaInvert(float max, float min, float distance);

/**
 * 偏移量 
 */
FitFunc funcLineOffset(NSInteger split, CGFloat distance);

/** 偏移x */
CGPoint offSetx(CGPoint point, float offSet);

/** 偏移y */
CGPoint offSety(CGPoint point, float offSet);

/** 数组求和 */
CGFloat addToIndex(NSArray *array, NSInteger index);

//
CGPoint cop_w_x(NSArray<NSValue *> *points, CGPoint point);
