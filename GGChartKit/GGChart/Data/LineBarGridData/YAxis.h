//
//  YAxis.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AxisName.h"

@interface YAxis : NSObject

/**
 * 轴最大值
 */
@property (nonatomic, strong) NSNumber * max;

/**
 * 轴最小值
 */
@property (nonatomic, strong) NSNumber * min;

/**
 * 轴线结构体
 */
@property (nonatomic, assign) GGLine axisLine;

/**
 * 轴格式化字符串
 */
@property (nonatomic, strong) NSString * dataFormatter;

/**
 * Y轴分割个数
 */
@property (nonatomic, assign) NSUInteger splitCount;

/**
 * 轴线分割线长度
 */
@property (nonatomic, assign) CGFloat over;

/**
 * 文字与轴之间的间距
 */
@property (nonatomic, assign) CGFloat stringGap;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 是否显示轴网格线
 */
@property (nonatomic, assign) BOOL showSplitLine;

/**
 * 是否显示查价标
 */
@property (nonatomic, assign) BOOL showQueryLable;

/**
 * 轴标题
 */
@property (nonatomic, strong) AxisName * name;

@end
