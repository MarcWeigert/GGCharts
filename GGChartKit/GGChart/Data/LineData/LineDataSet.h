//
//  LineDataSet.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGLineData.h"
#import "LineBarGird.h"
#import "LineBarQuery.h"

typedef enum : NSUInteger {
    LineDrawNomal,              ///< 默认格式
    LineDrawHeapUp,             ///< 折线堆叠
    LineDrawPNHeapUp,           ///< 折线正负堆叠
    LineDrawParallel,           ///< 折线并列显示
    LineDrawCenter,             ///< 折线居中
} LineDataMode;

@interface LineDataSet : NSObject

/**
 * 折线图内边距
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 * 折线图数据数组
 */
@property (nonatomic, strong) NSArray <GGLineData *> * lineAry;

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
@property (nonatomic, assign) LineDataMode lineMode;

/**
 * 数据中极大极小值偏移比率, 默认0.1
 */
@property (nonatomic, assign) CGFloat idRatio;

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect;

@end
