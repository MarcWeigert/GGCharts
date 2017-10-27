//
//  ProgressAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/10/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef ProgressAbstract_h
#define ProgressAbstract_h

#import "NumberAbstract.h"

@protocol ProgressAbstract <NSObject>

/**
 * 最大值
 */
@property (nonatomic, assign, readonly) CGFloat maxValue;

/**
 * 当前值
 */
@property (nonatomic, assign, readonly) CGFloat value;

/**
 * 弧度范围
 */
@property (nonatomic, assign, readonly) GGSizeRange arcRange;

#pragma mark - 进度条设置

/**
 * 进度条背景颜色
 */
@property (nonatomic, strong, readonly) UIColor * progressBackColor;

/**
 * 进度条半径
 */
@property (nonatomic, assign, readonly) CGFloat progressRadius;

/**
 * 小圆点弧度
 */
@property (nonatomic, assign, readonly) CGFloat pointRadius;

/**
 * 小圆颜色
 */
@property (nonatomic, strong, readonly) UIColor * pointColor;

/**
 * 线宽
 */
@property (nonatomic, assign, readonly) CGFloat lineWidth;


#pragma mark - 渐变色

/**
 * 进度条渐变色
 */
@property (nonatomic, strong, readonly) NSArray <UIColor *> * progressGradientColor;

/**
 * 渐变色权重
 */
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *gradientLocations;

/**
 * 渐变色曲线
 */
@property (nonatomic, assign, readonly) GradientCurve gradientCurve;

#pragma mark - 中心文字设置

/**
 * 中心文字外观设置
 */
@property (nonatomic, strong, readonly) id <NumberAbstract> centerLable;

@end

#endif /* ProgressAbstract_h */
