//
//  KLineChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseStockChart.h"
#import "KLineAbstract.h"
#import "VolumeAbstract.h"
#import "QueryViewAbstract.h"

typedef enum : NSUInteger {
    KLineTypeDay,       ///< 日k 一个月显示一根柱线
    KLineTypeWeek,      ///< 周k 三个月显示一根柱线
    KLineTypeMonth,     ///< 年k 一年显示一根柱线
} KLineStyle;

@interface KLineChart : BaseStockChart

@property (nonatomic, readonly) NSArray <id <KLineAbstract, VolumeAbstract, QueryViewAbstract> > * kLineArray;    ///< k线数组

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

@property (nonatomic, readonly) NSString * kLineIndexIndexName;
@property (nonatomic, readonly) NSString * volumIndexIndexName;

@property (nonatomic, assign) CGFloat kLineProportion;  ///< 主图占比 默认 .6f
@property (nonatomic, assign, readonly) KLineStyle kStyle;        ///< k线日期

@property (nonatomic, copy) void (^RefreshBlock)(void);     ///< 刷新回调

/** 结束刷新状态 */
- (void)endLoadingState;

/** 设置k线以及类型 */
- (void)setKLineArray:(NSArray<id<KLineAbstract,VolumeAbstract,QueryViewAbstract>> *)kLineArray type:(KLineStyle)kType;

/** 更新K线图 */
- (void)updateChart;

/** 指标切换回调 */
- (void)setIndexChangeBlock:(void(^)(NSString * indexName))block;

/** 切换指标 */
- (void)setIndex:(NSString *)string;

@end
