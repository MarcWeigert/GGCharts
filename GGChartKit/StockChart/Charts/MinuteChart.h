//
//  TimeChart.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"
#import "MinuteAbstract.h"
#import "VolumeAbstract.h"

typedef enum : NSUInteger {
    TimeMiddle,
    TimeHalfAnHour,
    TimeDay,
} TimeChartType;

@interface MinuteChart : BaseChart

@property (nonatomic, strong) UIColor * lineColor;      ///< 分时线颜色
@property (nonatomic, strong) UIColor * redColor;       ///< 环比上次涨颜色
@property (nonatomic, strong) UIColor * greenColor;     ///< 环比上次跌颜色
@property (nonatomic, strong) UIColor * avgColor;       ///< 均价线颜色
@property (nonatomic, strong) UIColor * gridColor;      ///< 网格颜色

@property (nonatomic, strong) UIColor * axisStringColor;      ///< 文字颜色
@property (nonatomic, strong) UIColor * posColor;       ///< 涨轴颜色
@property (nonatomic, strong) UIColor * negColor;           ///< 跌轴颜色
@property (nonatomic, strong) UIFont * axisFont;        ///< 轴字体

@property (nonatomic, assign) CGFloat lineRatio;    ///< 分时线所占比率
@property (nonatomic, assign) NSUInteger dirAxisSplitCount;     ///< 单向轴分割数
@property (nonatomic, assign) NSInteger dayMinuteAxisInterval;      ///< 横轴时间分割(仅用于日分时线)

@property (nonatomic, strong, readonly) NSArray <MinuteAbstract, VolumeAbstract> * objTimeAry;  ///< 分时数组

/** 是否正在交易 */
- (void)setTrading:(BOOL)trading;

/** 设置分时线数组 */
- (void)setMinuteTimeArray:(NSArray <MinuteAbstract, VolumeAbstract> *) objTimeArray timeChartType:(TimeChartType)type;

@end
