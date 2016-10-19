//
//  DrawMath.m
//  FiveView
//
//  Created by _ | Durex on 16/4/15.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "DrawMath.h"
#include <UIKit/UIKit.h>

/**
 * 线之间夹角
 * center 两线起点
 * start 开始线终点
 * end 终点线终点
 */
CGFloat angleBetweenLines(CGPoint center, CGPoint start, CGPoint end)
{
    CGFloat a = start.x - center.x;
    CGFloat b = start.y - center.y;
    CGFloat c = end.x - center.x;
    CGFloat d = end.y - center.y;
    CGFloat rads = acos(((a * c) + (b * d)) / ((sqrt(a * a + b * b)) * (sqrt(c * c + d * d))));
    
    if (signByCrossProduct(center, start, end)) {
        
        return 360.0 - radiansToDegrees(rads);
    }
    else {
        
        return radiansToDegrees(rads);
    }
}

/**
 * 根据起点, 直径, 角度返回终点(水平为0度)
 * point 起点
 * angle 角度
 * radius 直径
 */
CGPoint angleWithZero(CGPoint point, CGFloat angle, CGFloat radius,  BOOL clockwise)
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    if (clockwise) {
        
        x = radius * cosf(angle * M_PI / 180);
        y = radius * sinf(angle * M_PI / 180);
        
    }
    else{
    
        x = radius * cosf((360 - angle) * M_PI / 180);
        y = radius * sinf((360 - angle) * M_PI / 180);
    }
    
    return CGPointMake(point.x + x, point.y - y);

}

/**
 * 判断两向量夹角是否大于180°, 大于180°返回真, 否则返回假
 */
BOOL signByCrossProduct(CGPoint cen, CGPoint first, CGPoint second)
{
    CGFloat dx1 = first.x - cen.x;
    CGFloat dx2 = second.x - cen.x;
    CGFloat dy1 = first.y - cen.y;
    CGFloat dy2 = second.y - cen.y;
    
    if(dx1 * dy2 - dy1 * dx2 > 0) return true;
    
    return false;
}

/**
 * 判断是否在点是否在圆内
 */
BOOL isInEllipse(CGPoint cen, CGFloat radius, CGPoint point)
{
    CGFloat btn = sqrtf(((cen.x - point.x) * (cen.x - point.x) + (cen.y - point.y) * (cen.y - point.y)));
    
    if (btn > radius) return false;
    
    return true;
}

/**
 * 水平线夹角
 */
CGFloat angleHor(CGPoint cen, CGPoint point, BOOL clockwise)
{
    CGPoint start = CGPointMake(cen.x + 10, cen.y);
    CGPoint end = point;
    
    CGFloat a = start.x - cen.x;
    CGFloat b = start.y - cen.y;
    CGFloat c = end.x - cen.x;
    CGFloat d = end.y - cen.y;
    CGFloat rads = acos(((a * c) + (b * d)) / ((sqrt(a * a + b * b)) * (sqrt(c * c + d * d))));
    
    if (clockwise) {
        
        if (signByCrossProduct(cen, start, end)) {
            
            return 360.0 - radiansToDegrees(rads);
        }
        else {
            
            return radiansToDegrees(rads);
        }
    }
    
    else {
        
        if (!signByCrossProduct(cen, start, end)) {
            
            return 360.0 - radiansToDegrees(rads);
        }
        else {
            
            return radiansToDegrees(rads);
        }
    }
}

/**
 * 是否在一个扇形区域内
 */
BOOL isInArc(CGPoint cen, CGPoint point, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise)
{
    if (isInEllipse(cen, radius, point)) {
        
        if (angleHor(cen, point, clockwise) >= startAngle &&
            angleHor(cen, point, clockwise) <= endAngle) {
            
            return true;
        }
    }
    
    return false;
}

/**
 * 是否在一个环形区域内
 */
BOOL isInRingArc(CGPoint cen, CGPoint point, CGFloat radius, CGFloat inner, CGFloat startAngle, CGFloat endAngle, BOOL clockwise)
{
    // 内环角度
    CGFloat innerRadius = radius - inner;
    
    if (isInArc(cen, point, radius, startAngle, endAngle, clockwise) &&
        !isInArc(cen, point, innerRadius, startAngle, endAngle, clockwise)) {
        
        return true;
    }
    
    return false;
}

/**
 * 是否在西半圆
 */
BOOL isWest(CGFloat angle)
{    
    return (angle >= 90) && (angle < 270);
}

/**
 * 最小位数字符串
 * 4500 返回 1000, 0.45 返回 0.1
 */
float fMinDigits(float num)
{
    num = fabsf(num);
    float base = 1.0;
    
    while (num > 10) {
        
        num /= 10;
        base *= 10;
    }
    
    return base;
}

/**
 * 根据最大最小生成分段
 */
NSArray *makeBaseAry(float max, float min)
{
    float beMinJudge = min;
    float base = fMinDigits(fabsf(max) > fabsf(min) ? max : min);
    float poor = (max - min) / base;
    
    if (poor <= 1.2) {
        
        base *= 0.2;
    }
    else if (poor > 1.2 && poor < 2) {
        
        base *= 0.3;
    }
    else if (poor >= 2 && poor < 4) {
        
        base *= 0.5;
    }
    else if (poor >= 9 && poor < 12) {
        
        base *= 2;
    }
    else if (poor >= 12) {
        
        base *= 3;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    float i = 0;
    float spe = 0;
    
    while (fabs(beMinJudge) > i * base) i++;
    
    if (beMinJudge < 0) spe = -base * i;
    
    [array addObject:@(spe)];
    
    while (spe < max) [array addObject:@(spe += base)];
    
    return array;
}

NSArray *centerPoints(NSArray *points)
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < points.count - 1; i++) {
        
        CGPoint cur = [points[i] CGPointValue];
        CGPoint nxt = [points[i + 1] CGPointValue];
        
        CGFloat x = (nxt.x - cur.x) / 2;
        CGFloat y = (nxt.y - cur.y) / 2;
        
        [array addObject:[NSValue valueWithCGPoint:CGPointMake(cur.x + x, cur.y + y)]];
    }
    
    return [NSArray arrayWithArray:array];
}

float getMax(NSArray *array)
{
    float max = FLT_MIN;
    
    for (NSNumber *num in array) {
        
        max = max < num.floatValue ? num.floatValue : max;
    }
    
    return max;
}

float getMin(NSArray *array)
{
    float min = FLT_MAX;
    
    for (NSNumber *num in array) {
        
        min = min > num.floatValue ? num.floatValue : min;
    }
    
    return min;
}

/**  */
float getAryMin(NSArray <NSArray *> *array)
{
    float min = FLT_MAX;
    
    for (NSArray *ary in array) {
        
        float cur_min = getMin(ary);
        
        min = min < cur_min ? min : cur_min;
    }
    
    return min;
}

/**  */
float getAryMax(NSArray <NSArray *> *array)
{
    float max = FLT_MIN;
    
    for (NSArray *ary in array) {
        
        float cur_max = getMax(ary);
        
        max = max > cur_max ? max : cur_max;
    }
    
    return max;
}

/**
 * 二维数据累加
 * @[@1, @1, @1]    @[@1, @1, @1]
 * @[@1, @1, @1] -> @[@2, @2, @2]
 * @[@1, @1, @1]    @[@3, @3, @3]
 */
NSArray *aryAddup(NSArray <NSArray <NSNumber *> *> *aryData)
{
    NSMutableArray *aryAddData = [NSMutableArray array];
    
    [aryAddData addObject:aryData.firstObject];
    
    // 循环简历累加数组
    for (NSInteger i = 1; i < aryData.count; i++) {
        
        NSArray *ary_c = aryData[i];
        NSArray *ary_b = aryAddData.lastObject;
        NSMutableArray *aryAddBefor = [NSMutableArray array];
        
        // 累加数组累加数字已当前数组长度为准
        for (NSInteger j = 0; j < ary_c.count; j++) {
            
            NSInteger f = aryAddData.count - 1;     // find 位置
            CGFloat c = [ary_c[j] floatValue];      // current 当前的数字
            
            // 前一个数组如果越界, 则前一个数字为当前数字的相反数(保证循环继续)
            CGFloat b = j >= ary_b.count ? -c : [ary_b[j] floatValue];
            
            // 数值同方向才可以相加
            while ((b * c) < 0) {   // before 和 current 数字正负为同方向跳出循环
                
                if (f < 0) {    // find 小于0为找到头
                    
                    b = 0;
                }
                else {
                    
                    NSArray *ary_f_b = aryAddData[f];
                    
                    b = j < ary_f_b.count ? [[aryAddData[f] objectAtIndex:j] floatValue] : -c;
                }
                
                f--;    // 非同方向向前寻找
            }
            
            // 将2数值之和叠加放入本次循环数组
            [aryAddBefor addObject:@(c + b)];
        }
        
        [aryAddData addObject:[NSArray arrayWithArray:aryAddBefor]];
    }
    
    return [NSArray arrayWithArray:aryAddData];
}

/** 通过最大最小值返回一个blcok */
FltFunc funcAreaInvert(float max, float min, float distance)
{
    float pix = distance / (max - min);
    
    float zero = min > 0 ? distance : distance - pix * fabsf(min);
    
    return ^(CGFloat val) {
        
        if (val < 0) {
            
            return zero + fabs(val) * pix;
        }
        else {
        
            if (min < 0) {
                
                return zero - fabs(val) * pix;
            }
            
            return zero - fabs(val - min) * pix;
        }
    };
}

FitFunc funcLineOffset(NSInteger split, CGFloat distance)
{
    CGFloat interval = distance / split;
    
    return ^(NSInteger index) {
    
        return index * interval;
    };
}

/** 偏移x */
CGPoint offSetx(CGPoint point, float offSet)
{
    return CGPointMake(point.x + offSet, point.y);
}

/** 偏移y */
CGPoint offSety(CGPoint point, float offSet)
{
    return CGPointMake(point.x, point.y + offSet);
}

/** 数组求和 */
CGFloat addToIndex(NSArray<NSNumber *> *array, NSInteger index)
{
    if (index < 0 || array.count <= index) return 0;
    
    CGFloat sum = 0;
    
    for (int i = 0; i <= index; i++) {
        
        sum += [array[i] floatValue];
    }
    
    return sum;
}

CGPoint cop_w_x(NSArray<NSValue *> *points, CGPoint point)
{
    CGPoint p = CGPointZero;
    CGFloat sum = FLT_MAX;
    
    for (NSValue *pt in points) {
        
        CGFloat abs = ABS(pt.CGPointValue.x - point.x);
        
        if (sum > abs) {
            
            sum = abs;
            p = [pt CGPointValue];
        }
    }
    
    return p;
}
