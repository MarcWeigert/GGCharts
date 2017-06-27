//
//  BaseLineData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/27.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarChartData.h"
#import "DLineScaler.h"
#import "GGShapeCanvas.h"

@interface BaseLineData : BarChartData

@property (nonatomic, strong) NSString * lineName;
@property (nonatomic, strong) UIColor * lineColor;

@property (nonatomic, strong) NSArray <NSNumber *> *datas;  ///< 数据

@property (nonatomic, readonly) CGFloat dataMax;      ///< 数组中最大值
@property (nonatomic, readonly) CGFloat dataMin;      ///< 数组中最小值
@property (nonatomic, readonly) BOOL isAllPositive;     ///< 是否全是正数

@property (nonatomic, assign) CGFloat width;    ///< 宽度
@property (nonatomic, strong) UIColor * color;  ///< 颜色

@property (nonatomic, readonly, weak) GGShapeCanvas * lineCanvas;   ///< 渲染层
@property (nonatomic, strong) DLineScaler * lineScaler;     ///< 线数据定标器

/**
 * 绘制线图层
 *
 * @param lineCanvas 图层
 */
- (void)drawLineWithCanvas:(GGShapeCanvas *)lineCanvas;

@end
