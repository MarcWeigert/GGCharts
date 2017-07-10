//
//  KLineChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseStockChart.h"
#import "KLineAbstract.h"
#import "VolumeAbstract.h"
#import "QueryViewAbstract.h"

@interface KLineChart : BaseStockChart

@property (nonatomic, strong) NSArray <id <KLineAbstract, VolumeAbstract, QueryViewAbstract> > * kLineArray;    ///< k线数组

@property (nonatomic, assign) NSInteger kLineCountVisibale;     ///< 一屏幕显示多少根k线     默认60
@property (nonatomic, assign) NSInteger kMaxCountVisibale;      ///< 屏幕最多显示多少k线     默认120
@property (nonatomic, assign) NSInteger kMinCountVisibale;      ///< 屏幕最少显示多少k线     默认20
@property (nonatomic, assign) CGFloat kInterval;    ///< k线之间的间隔

@property (nonatomic, assign) NSUInteger kAxisSplit;        ///< k线纵轴 默认7

@property (nonatomic, strong) UIColor * riseColor;      ///< 涨颜色  默认 RGB(216, 94, 101)
@property (nonatomic, strong) UIColor * fallColor;      ///< 跌颜色  默认 RGB(150, 234, 166)
@property (nonatomic, strong) UIColor * gridColor;      ///< 网格颜色  默认 RGB(154, 160, 180)
@property (nonatomic, strong) UIColor * axisStringColor;      ///< 文字颜色

@property (nonatomic, strong) UIFont * axisFont;        ///< 轴字体

@property (nonatomic, assign) NSInteger kLineIndexIndex;
@property (nonatomic, assign) NSInteger volumIndexIndex;

/** 更新K线图 */
- (void)updateChart;

@end
