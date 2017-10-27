//
//  RadarData.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRadarScaler.h"

@interface RadarData : NSObject

@property (nonatomic, strong, readonly) DRadarScaler * radarScaler;

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 填充颜色
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 * 线颜色
 */
@property (nonatomic, strong) UIColor *strockColor;

/**
 * 基础长度比例, 当数据为0时最低雷达图显示位置
 */
@property (nonatomic, assign) CGFloat baseRatio;

/**
 * 数据源
 */
@property (nonatomic, strong) NSArray <NSNumber *> *datas;

#pragma mark - 折线关键点配置

/**
 * 折线关键点半径
 */
@property (nonatomic, assign) CGFloat shapeRadius;

/**
 * 折线关键点填充色
 */
@property (nonatomic, strong) UIColor * shapeFillColor;

/**
 * 折线线宽
 */
@property (nonatomic, assign) CGFloat shapeLineWidth;

#pragma mark - Gradient

/**
 * 渐变色
 */
@property (nonatomic, strong) NSArray * gradientColors;

@end
