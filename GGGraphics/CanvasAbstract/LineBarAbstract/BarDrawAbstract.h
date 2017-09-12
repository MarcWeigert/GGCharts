//
//  BarDrawAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BarDrawAbstract_h
#define BarDrawAbstract_h

#import "BaseLineBarAbstract.h"

@protocol BarDrawAbstract <BaseLineBarAbstract>

/**
 * 柱状图结构体
 */
@property (nonatomic, assign, readonly) CGRect * barRects;

/**
 * 柱状图边框颜色
 */
@property (nonatomic, strong, readonly) UIColor * barBorderColor;

/**
 * 柱状图边框
 */
@property (nonatomic, assign, readonly) CGFloat borderWidth;

/**
 * 柱状图填充色
 */
@property (nonatomic, strong, readonly) UIColor * barFillColor;

/**
 * 柱状图宽度
 */
@property (nonatomic, assign, readonly) CGFloat barWidth;

@end

#endif /* BarDrawAbstract_h */
