//
//  BarCanvasAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BarCanvasAbstract_h
#define BarCanvasAbstract_h

#import "BarDrawAbstract.h"

@protocol BarCanvasAbstract <NSObject>

/**
 * 柱状图内边距
 */
@property (nonatomic, assign, readonly) UIEdgeInsets insets;

/**
 * 柱状图颜色
 */
@property (nonatomic, copy, readonly) UIColor *(^barColorsAtIndexPath)(NSIndexPath *indexPath);

/**
 * 柱状图数据数组
 */
@property (nonatomic, strong, readonly) NSArray <id <BarDrawAbstract>> *barAry;

@end

#endif /* BarCanvasAbstract_h */
