//
//  GGStringRenderer.h
//  111
//
//  Created by _ | Durex on 2017/6/4.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"

@interface GGStringRenderer : NSObject <GGRenderProtocol>

/**
 * 绘制文字字体
 */
@property (nonatomic, strong) UIFont * font;

/**
 * 绘制文字颜色
 */
@property (nonatomic, strong) UIColor * color;

/**
 * 绘制文字关键点
 */
@property (nonatomic, assign) CGPoint point;

/**
 * 绘制文字偏移量
 */
@property (nonatomic, assign) CGSize offset;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 绘制文字
 */
@property (nonatomic, copy) NSString * string;

/**
 * 填充色
 */
@property (nonatomic, strong) UIColor * fillColor;

/**
 * 文字内边距
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/**
 * 标签背景弧度
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * 横向范围, 设置之后不可超出范围
 */
@property (nonatomic, assign) GGSizeRange horizontalRange;

/**
 * 垂直范围, 设置之后不可超出范围
 */
@property (nonatomic, assign) GGSizeRange verticalRange;

@end
