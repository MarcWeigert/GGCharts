//
//  ProgressChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/10/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressData.h"
#import "ProgressCanvas.h"

@interface ProgressChart : UIView

/**
 * 进度条数据
 */
@property (nonatomic, strong) ProgressData * progressData;

/**
 * 进度条画布
 */
@property (nonatomic, strong, readonly) ProgressCanvas * progressCanvas;

/**
 * 绘制进度条图
 */
- (void)drawProgressChart;

/**
 * 启动动画
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration;

@end
