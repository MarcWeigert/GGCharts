//
//  BaseLineData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/27.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChartData.h"
#import "DLineScaler.h"
#import "GGShapeCanvas.h"
#import "GGCanvas.h"

@interface BaseLineData : BaseChartData

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

@property (nonatomic, copy) NSString * attachedString;      ///< 关键点文字
@property (nonatomic, strong) UIFont * stringFont;      ///< 关键点字体
@property (nonatomic, strong) UIColor * stringColor;    ///< 文字颜色
@property (nonatomic, copy) NSString * format;      ///< 数据格式化字符串
@property (nonatomic, strong) GGCanvas * stringCanvas;    ///< 文字渲染层
@property (nonatomic, assign) BOOL isShowString;        ///< 是否显示文字

/**
 * 绘制线图层
 *
 * @param lineCanvas 图层
 */
- (void)drawLineWithCanvas:(GGShapeCanvas *)lineCanvas;

/**
 * 绘制文字层
 *
 * @param stringCanvas 文字
 */
- (void)drawStringWithCanvas:(GGCanvas *)stringCanvas;

/**
 * 获取数组中最大值最小值
 *
 * @param dataAry 数据组
 * @param max 极大值指针
 * @param min 最小值指针
 */
+ (void)getChartDataAry:(NSArray <BaseLineData *> *)dataAry max:(CGFloat *)max min:(CGFloat *)min;

@end
