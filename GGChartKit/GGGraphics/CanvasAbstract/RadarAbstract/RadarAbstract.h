//
//  RadarAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef RadarAbstract_h
#define RadarAbstract_h

@protocol RadarAbstract <NSObject>

/**
 * 雷达图线宽
 */
@property (nonatomic, assign, readonly) CGFloat lineWidth;

/**
 * 填充颜色
 */
@property (nonatomic, strong, readonly) UIColor *fillColor;

/**
 * 颜色
 */
@property (nonatomic, strong, readonly) UIColor *strockColor;

/**
 * 数据源
 */
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *datas;

/**
 * 数据点
 */
@property (nonatomic, assign, readonly) CGPoint * points;

#pragma mark - 折线关键点配置

/**
 * 折线关键点半径
 */
@property (nonatomic, assign, readonly) CGFloat shapeRadius;

/**
 * 折线关键点填充色
 */
@property (nonatomic, strong, readonly) UIColor * shapeFillColor;

/**
 * 折线线宽
 */
@property (nonatomic, assign, readonly) CGFloat shapeLineWidth;


#pragma mark - Gradient

/**
 * 渐变色
 */
@property (nonatomic, strong) NSArray * gradientColors;

@end

#endif /* RadarAbstract_h */
