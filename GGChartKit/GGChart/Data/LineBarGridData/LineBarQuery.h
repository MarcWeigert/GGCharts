//
//  LineBarQuery.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XAxis.h"
#import "YAxis.h"

@interface LineBarQuery : NSObject

#pragma mark - 轴设置

/**
 * 查价层左边数据轴
 */
@property (nonatomic, weak) YAxis * leftNumberAxis;

/**
 * 查价层右边数据轴
 */
@property (nonatomic, weak) YAxis * rightNumberAxis;

/**
 * 查价层上层标签轴
 */
@property (nonatomic, weak) XAxis * topLableAxis;

/**
 * 查价层下层标签轴
 */
@property (nonatomic, weak) XAxis * bottomLableAxis;

/**
 * 查价中数据数组
 */
@property (nonatomic, weak) NSArray <id <BaseLineBarAbstract>> * lineBarArray;


#pragma mark - 查价设置

/**
 * 查价层内边距
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 * 查价层线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 查价层线颜色
 */
@property (nonatomic, strong) UIColor * lineColor;

/**
 * 虚线样式
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dashPattern;


#pragma mark - 查价文字设置

/**
 * 查价文字内边距
 */
@property (nonatomic, assign) UIEdgeInsets lableInsets;

/**
 * 查价文字字体
 */
@property (nonatomic, strong) UIFont * lableFont;

/**
 * 查价文字颜色
 */
@property (nonatomic, strong) UIColor * lableColor;

/**
 * 查价背景颜色
 */
@property (nonatomic, strong) UIColor * lableBackgroundColor;

/**
 * 查价标签弧度
 */
@property (nonatomic, assign) CGFloat lableRadius;

@end
