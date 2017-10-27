//
//  GGNumberRenderer.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"
#import "Animator.h"

@interface GGNumberRenderer : NSObject <GGRenderProtocol, AnimatorProtocol>

/**
 * 开始数字
 */
@property (nonatomic, assign) CGFloat fromNumber;

/**
 * 结束数字
 */
@property (nonatomic, assign) CGFloat toNumber;

/**
 * 开始绘制点
 */
@property (nonatomic, assign) CGPoint fromPoint;

/**
 * 终止绘制点
 */
@property (nonatomic, assign) CGPoint toPoint;

/**
 * 字体
 */
@property (nonatomic, strong) UIFont * font;

/**
 * 文字颜色
 */
@property (nonatomic, strong) UIColor * color;

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
 * 格式化字符串
 */
@property (nonatomic, strong) NSString * format;

/**
 * 文字偏移量
 */
@property (nonatomic, assign) CGSize offSet;

/**
 * 是否隐藏
 */
@property (nonatomic, assign) BOOL hidden;

/**
 * 数值集合, 回调attrbuteStringValueAndRatioBlock是返回比例
 *
 * 如果该值为0, 则回调返回0
 */
@property (nonatomic, assign) CGFloat sum;

/**
 * 获取文字颜色
 */
@property (nonatomic, copy) UIColor *(^getNumberColorBlock)(CGFloat value);

/**
 * 富文本字符串
 */
@property (nonatomic, copy) NSAttributedString *(^attrbuteStringValueBlock)(CGFloat value);

/**
 * 富文本字符串
 */
@property (nonatomic, copy) NSAttributedString *(^attrbuteStringValueAndRatioBlock)(CGFloat value, CGFloat ratio);

/**
 * 动画的点, 用于动画
 */
@property (nonatomic, copy) CGPoint (^drawPointBlock)(CGFloat progress);

/** 
 * 绘制起始点文字 
 */
- (void)drawAtToNumberAndPoint;

/**
 * 绘制与终点
 */
- (void)drawAtToPoint;

/** 
 * 绘制终点文字 
 */
- (void)drawAtFromNumberAndPoint;

/** 
 * 更新点 
 */
- (void)startUpdatePointWithProgress:(CGFloat)progress;

/** 
 * 更新Number 
 */
- (void)startUpdateNumberWithProgress:(CGFloat)progress;

@end
