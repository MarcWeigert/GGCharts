//
//  BaseChart.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCanvas.h"
#import "GGShapeCanvas.h"

@interface BaseChart : UIView

/**
 * 绘制图表(子类重写)
 */
- (void)drawChart;

/** 
 * 取图层视图大小与Chart一致
 */
- (GGShapeCanvas *)getGGCanvasEqualFrame;

/**
 * 取图层视图大小为正方形
 */
- (GGShapeCanvas *)getGGCanvasSquareFrame;

/**
 * 取图层视图大小与Chart一致
 */
- (GGCanvas *)getGGStaticCanvasEqualFrame;

/**
 * 取图层视图大小为正方形
 */
- (GGCanvas *)getGGStaticCanvasSquareFrame;

/**
 * 手指轻触视图
 *
 * @param point 点击屏幕的点
 */
- (void)onTapView:(CGPoint)point;

/**
 * 手指移动
 *
 * @param point 点击屏幕的点
 */
- (void)onPanView:(CGPoint)point;

@end
