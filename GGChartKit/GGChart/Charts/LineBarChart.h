//
//  IOLineBarChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseChart.h"

#import "BarData.h"
#import "LineData.h"

@interface LineBarChart : BaseChart

#pragma mark - 标题

@property (nonatomic, strong, readonly) UILabel * lbTop;        ///< 顶部标题
@property (nonatomic, strong, readonly) UILabel * lbBottom;        ///< 底部标题

#pragma mark - 背景网格

@property (nonatomic, strong) UIFont * axisFont;        ///< 轴字体
@property (nonatomic, strong) UIColor * axisColor;      ///< 轴颜色
@property (nonatomic, copy) NSArray * xAxisTitles;      ///< 横轴文字
@property (nonatomic, assign) NSInteger yAxisSplit;     ///< y轴分割
@property (nonatomic, copy) NSString * yAxisformat;     ///< y轴格式化字符串
@property (nonatomic, copy) NSString * attachedString;     ///< 纵轴附加字符串
@property (nonatomic, assign) CGFloat gridLineWidth;    ///< 网格线宽
@property (nonatomic, assign) BOOL isNeedDash;     ///< 是否虚线
@property (nonatomic, assign) BOOL isNeedSplitX;   ///< 横轴是否需要分割

#pragma mark - 内容层

@property (nonatomic, assign) UIEdgeInsets insets;      /// 默认 UIEdgeInsetsMake(30, 40, 40, 40)

#pragma mark - 数据

@property (nonatomic, strong) NSArray <BarData *> * barDataAry;     ///< 柱状数据数组
@property (nonatomic, strong) NSArray <LineData *> * lineDataAry;       ///< 线数据数组

@property (nonatomic, assign) BOOL barPile;     ///< 柱状图是否堆叠
@property (nonatomic, assign) BOOL linePile;    ///< 线是否堆叠

/**
 * 更新视图
 */
- (void)updateChart;

- (void)addAnimation:(NSTimeInterval)duration;

@end
