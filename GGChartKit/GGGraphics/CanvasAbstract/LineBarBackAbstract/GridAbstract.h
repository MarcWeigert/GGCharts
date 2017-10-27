//
//  GridAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef GridAbstract_h
#define GridAbstract_h

#import "NumberAxisAbstract.h"
#import "LableAxisAbstract.h"

@protocol GridAbstract <NSObject>

#pragma mark - 轴设置

/**
 * 查价层左边数据轴
 */
@property (nonatomic, strong, readonly) id <NumberAxisAbstract> leftNumberAxis;

/**
 * 查价层右边数据轴
 */
@property (nonatomic, strong, readonly) id <NumberAxisAbstract> rightNumberAxis;

/**
 * 查价层上层标签轴
 */
@property (nonatomic, strong, readonly) id <LableAxisAbstract> topLableAxis;

/**
 * 查价层下层标签轴
 */
@property (nonatomic, strong, readonly) id <LableAxisAbstract> bottomLableAxis;


#pragma mark - 网格设置

/**
 * 网格层内边距
 */
@property (nonatomic, assign, readonly) UIEdgeInsets insets;

/**
 * 网格线宽
 */
@property (nonatomic, assign, readonly) CGFloat lineWidth;

/**
 * 网格线颜色
 */
@property (nonatomic, strong, readonly) UIColor * lineColor;

/**
 * 虚线样式
 */
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *dashPattern;

#pragma mark - 轴设置

/**
 * 轴文字字体
 */
@property (nonatomic, strong, readonly) UIFont * axisLableFont;

/**
 * 轴文字颜色
 */
@property (nonatomic, strong, readonly) UIColor * axisLableColor;

/**
 * 轴线颜色
 */
@property (nonatomic, strong, readonly) UIColor * axisLineColor;

/**
 * 轴分割线颜色
 */
@property (nonatomic, strong, readonly) UIColor * axisSplitLineColor;

@end


#endif /* GridAbstract_h */
