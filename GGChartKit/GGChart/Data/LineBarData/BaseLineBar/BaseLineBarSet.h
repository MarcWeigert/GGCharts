//
//  BaseLineBarSet.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LineData.h"
#import "LineBarGird.h"
#import "LineBarQuery.h"

typedef enum : NSUInteger {
    LineBarDrawNomal,              ///< 默认格式
    LineBarDrawHeapUp,             ///< 堆叠
    LineBarDrawPNHeapUp,           ///< 正负堆叠
    LineBarDrawParallel,           ///< 并列显示
    LineBarDrawCenter,             ///< 居中
} LineBarDataMode;

@interface BaseLineBarSet : NSObject

/**
 * 折线与柱状图内边距
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 * 折线与柱状图背景层设置
 */
@property (nonatomic, strong) LineBarGird * gridConfig;

/**
 * 折线与柱状表现形式
 */
@property (nonatomic, assign) LineBarDataMode lineBarMode;

/**
 * 数据中极大极小值偏移比率, 默认0.1
 */
@property (nonatomic, assign) CGFloat idRatio;

/**
 * 更新时是否需要动画
 */
@property (nonatomic, assign) BOOL updateNeedAnimation;

/**
 * 柱状图折线图数据文字颜色
 * 优先级高于 data.stringColor
 *
 * @param value 数据
 *
 * @return 柱状图颜色
 */
@property (nonatomic, copy) UIColor *(^stringColorForValue)(CGFloat value);

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel;

/**
 * 设置填充数据轴
 */
- (void)configAxisWithArray:(NSArray <BaseLineBarData *> *)baseLineArray;

/**
 * 设置填充定标器
 */
- (void)configLineScalerWithArray:(NSArray <BaseLineBarData *> *)baseLineArray;

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect;

@end
