//
//  BarCanvasAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BarCanvasAbstract_h
#define BarCanvasAbstract_h

#import "BaseLineBarCanvasAbstract.h"
#import "BarDrawAbstract.h"

@protocol BarCanvasAbstract <BaseLineBarCanvasAbstract>

/**
 * 柱状图内边距
 */
@property (nonatomic, assign, readonly) UIEdgeInsets insets;

/**
 * 中间分割线线宽
 */
@property (nonatomic, assign, readonly) CGFloat midLineWidth;

/**
 * 中间线颜色
 */
@property (nonatomic, strong, readonly) UIColor * midLineColor;

/**
 * 柱状图颜色
 * 优先级高于 bardata.fillColor
 *
 * @param indexPath 柱状位置
 * @param number 柱状图数据
 *
 * @return 柱状图颜色
 */
@property (nonatomic, copy, readonly) UIColor *(^barColorsAtIndexPath)(NSIndexPath *indexPath, NSNumber * number);

/**
 * 柱状图数据数组
 */
@property (nonatomic, strong, readonly) NSArray <id <BarDrawAbstract>> *barAry;

@end

#endif /* BarCanvasAbstract_h */
