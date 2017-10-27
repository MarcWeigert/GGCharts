//
//  RadarDataSet.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadarData.h"
#import "RadarIndicatorData.h"

@interface RadarDataSet : NSObject

/**
 * 图层数据
 */
@property (nonatomic, strong) NSArray <RadarData *> * radarSet;

/**
 * 基础摄制
 */
@property (nonatomic, strong) NSArray <RadarIndicatorData *> * indicatorSet;

/**
 * 背景雷达线颜色
 */
@property (nonatomic, strong) UIColor * strockColor;

/**
 * 分割数
 */
@property (nonatomic, assign) NSUInteger splitCount;

/**
 * 标题字体
 */
@property (nonatomic, strong) UIFont * titleFont;

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 雷达图半径
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * 文字与顶点间距
 */
@property (nonatomic, assign) CGFloat titleSpacing;

/**
 * 最外层雷达线宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 是否背景为圆形
 */
@property (nonatomic, assign) BOOL isCirlre;

/**
 * 文字颜色
 */
@property (nonatomic, strong) UIColor * stringColor;

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect;

@end
