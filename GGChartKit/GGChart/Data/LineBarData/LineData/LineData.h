//
//  GGLineData.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLineBarData.h"

@interface LineData : BaseLineBarData

#pragma mark - 折线配置

/**
 * 折线线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 折线颜色
 */
@property (nonatomic, strong) UIColor * lineColor;

/**
 * 折线虚线样式
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dashPattern;

/**
 * 显示关键点设置
 */
@property (nonatomic, strong) NSSet <NSNumber *> * showShapeIndexSet;


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


#pragma mark - 折线填充

/**
 * 折线填充色, 优先级比渐变色高
 */
@property (nonatomic, strong) UIColor * lineFillColor;

/**
 * 折线填充渐变色, 数据内传入CGColor
 */
@property (nonatomic, strong) NSArray * gradientFillColors;

/**
 * 填充色变化曲线, 由上至下
 */
@property (nonatomic, strong) NSArray <NSNumber *> *locations;

@end
