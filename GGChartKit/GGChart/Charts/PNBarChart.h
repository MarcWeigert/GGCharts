//
//  IOBarChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseCountChart.h"
#import "PNBarData.h"

@interface PNBarChart : BaseCountChart

#pragma mark - 标题

@property (nonatomic, strong, readonly) UILabel * lbTop;        ///< 顶部标题
@property (nonatomic, strong, readonly) UILabel * lbBottom;        ///< 底部标题

#pragma mark - 轴

@property (nonatomic, copy) NSArray * axisTitles;   ///< x轴文字
@property (nonatomic, strong) UIFont * axisFont;        ///< 轴字体
@property (nonatomic, strong) UIColor * axisColor;      ///< 轴颜色

@property (nonatomic, strong) PNBarData * pnBarData;    ///< 正负轴数据

#pragma mark - 内容

@property (nonatomic, assign) UIEdgeInsets insets;      /// 默认 UIEdgeInsetsMake(20, 10, 20, 10)
@property (nonatomic, strong) NSString * format;    ///< 格式化字符串

@property (nonatomic, strong) UIColor * positiveColor;  ///< 正数据颜色
@property (nonatomic, strong) UIColor * negativeColor;      ///< 负数据颜色

- (void)updateChart;

/** 图表动画 */
- (void)addAnimation:(NSTimeInterval)duration;

@end
