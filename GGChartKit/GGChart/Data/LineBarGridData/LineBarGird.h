//
//  LineBarGird.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAxis.h"
#import "YAxis.h"

@interface LineBarGird : NSObject

#pragma mark - 轴设置

/**
 * 左数据轴
 */
@property (nonatomic, strong) YAxis * leftNumberAxis;

/**
 * 右数据轴
 */
@property (nonatomic, strong) YAxis * rightNumberAxis;

/**
 * 上层签轴
 */
@property (nonatomic, strong) XAxis * topLableAxis;

/**
 * 下标签轴
 */
@property (nonatomic, strong) XAxis * bottomLableAxis;


#pragma mark - 网格设置

/**
 * 网格层内边距
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 * 网格线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 网格线颜色
 */
@property (nonatomic, strong) UIColor * lineColor;

/**
 * 虚线样式
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dashPattern;


#pragma mark - 轴设置

/**
 * 轴文字字体
 */
@property (nonatomic, strong) UIFont * axisLableFont;

/**
 * 轴文字颜色
 */
@property (nonatomic, strong) UIColor * axisLableColor;

/**
 * 轴线颜色
 */
@property (nonatomic, strong) UIColor * axisLineColor;

/**
 * 轴分割线颜色
 */
@property (nonatomic, strong) UIColor * axisSplitLineColor;

@end
