//
//  GGLineData.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLineScaler.h"

typedef enum : NSUInteger {
    ScalerAxisLeft = 0,
    ScalerAxisRight,
} ScalerAxisType;

@interface GGLineData : NSObject

/**
 * 折线定标器
 */
@property (nonatomic, strong, readonly) DLineScaler * lineScaler;

#pragma mark - 折线数据

/**
 * 用来显示的数据
 */
@property (nonatomic, strong) NSArray <NSNumber *> *lineDataAry;

/**
 * 绘制折线点
 */
@property (nonatomic, assign, readonly) CGPoint * points;

#pragma mark - 折线配置

/**
 * 折线线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 折线颜色
 */
@property (nonatomic, strong) UIColor * lineColor;

#pragma mark - 折线关键点配置

/**
 * 折线关键点半径
 */
@property (nonatomic, assign) CGFloat shapeRadius;

/**
 * 折线关键点填充色
 */
@property (nonatomic, strong) UIColor * shapeFillColor;

#pragma mark - 折线文字

/**
 * 折线文字字体
 */
@property (nonatomic, strong) UIFont * stringFont;

/**
 * 折线文字颜色
 */
@property (nonatomic, strong) UIColor * stringColor;

/**
 * 折线格式化字符串
 */
@property (nonatomic, strong) NSString * dataFormatter;

/**
 * 折线文字偏移比例
 *
 * {-1, -1} 数据点右上方绘制, {0, 0} 数据点左下方绘制, {0.5, 0.5} 数据点中心绘制
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 折线文字偏移
 */
@property (nonatomic, assign) CGSize stringOffset;

#pragma mark - 折线填充

/**
 * 围绕该Y轴坐标点填充, FLT_MIN 代表不填充
 */
@property (nonatomic, assign, readonly) CGFloat bottomYPix;

/**
 * 折线填充色, 优先级比渐变色高
 */
@property (nonatomic, strong) UIColor * lineFillColor;

/**
 * 折线填充渐变色, 数据内传入CGColor
 */
@property (nonatomic, strong) NSArray * gradientColors;

/**
 * 填充色变化曲线, 由上至下
 */
@property (nonatomic, strong) NSArray <NSNumber *> *locations;

@end
