//
//  BaseChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCanvas.h"
#import "GGShapeCanvas.h"
#import "BaseChartData.h"

#define ChartShape(A)         [self getShapeWithTag:A]
#define ChartBack(A)          [self getCanvasWithTag:A]
#define ChartPie(A)           [self getPieWithTag:A]

@interface BaseChart : UIView

- (GGCanvas *)getCanvasWithTag:(NSInteger)tag;

- (GGShapeCanvas *)getShapeWithTag:(NSInteger)tag;

- (GGShapeCanvas *)getPieWithTag:(NSInteger)tag;

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

@end
