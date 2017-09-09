//
//  YAxis.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AxisAbstract.h"
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
 * 轴文字偏移比例
 *
 * {0, 0} 数据点左下方绘制, {-0.5, -0.5} 数据点中心绘制, {-1, -1} 数据点右上方绘制
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 是否显示轴网格线
 */
@property (nonatomic, assign) BOOL showSplitLine;

/**
 * 轴标题
 */
@property (nonatomic, assign) AxisName * name;

@end
