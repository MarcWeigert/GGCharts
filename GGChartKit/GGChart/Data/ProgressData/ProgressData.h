//
//  ProgressData.h
//  GGCharts
//
//  Created by _ | Durex on 17/10/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgressAbstract.h"
#import "ProgressLable.h"

@interface ProgressData : NSObject <ProgressAbstract>

/**
 * 最大值
 */
@property (nonatomic, assign) CGFloat maxValue;

/**
 * 当前值
 */
@property (nonatomic, assign) CGFloat value;


#pragma mark - 进度条范围

/**
 * 开始角度
 *
 * 3点方向为0度(水平为0度)
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 * 结束角度
 */
@property (nonatomic, assign) CGFloat endAngle;


#pragma mark - 进度条设置

/**
 * 进度条背景颜色
 */
@property (nonatomic, strong) UIColor * progressBackColor;

/**
 * 进度条渐变色
 */
@property (nonatomic, strong) NSArray <UIColor *> * progressGradientColor;

/**
 * 渐变色权重
 */
@property (nonatomic, strong) NSArray <NSNumber *> *gradientLocations;

/**
 * 渐变色曲线
 */
@property (nonatomic, assign) GradientCurve gradientCurve;

/**
 * 进度条半径
 */
@property (nonatomic, assign) CGFloat progressRadius;

/**
 * 小圆点弧度
 */
@property (nonatomic, assign) CGFloat pointRadius;

/**
 * 小圆颜色
 */
@property (nonatomic, strong) UIColor * pointColor;

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;


#pragma mark - 中心文字设置

/**
 * 中心文字外观设置
 */
@property (nonatomic, strong) ProgressLable * centerLable;

@end
