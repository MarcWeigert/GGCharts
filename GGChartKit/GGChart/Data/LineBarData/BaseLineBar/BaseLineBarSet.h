//
//  BaseLineBarSet.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGLineData.h"
#import "LineBarGird.h"
#import "LineBarQuery.h"

typedef enum : NSUInteger {
    LineBarDrawNomal,              ///< 默认格式
    LineBarDrawHeapUp,             ///< 折线堆叠
    LineBarDrawPNHeapUp,           ///< 折线正负堆叠
    LineBarDrawParallel,           ///< 折线并列显示
    LineBarDrawCenter,             ///< 折线居中
} LineBarDataMode;

@interface BaseLineBarSet : NSObject

/**
 * 折线图内边距
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 * 折线图背景层设置
 */
@property (nonatomic, strong) LineBarGird * gridConfig;

/**
 * 折线图查价配置
 */
@property (nonatomic, strong) LineBarQuery * queryConfig;

/**
 * 折线表现形式
 */
@property (nonatomic, assign) LineBarDataMode lineBarMode;

/**
 * 数据中极大极小值偏移比率, 默认0.1
 */
@property (nonatomic, assign) CGFloat idRatio;

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel;

/**
 * 获取数据数组(子类重写)
 */
- (NSArray <BaseLineBarData *> *)getBaseLineBarDataArray;

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect;

@end
