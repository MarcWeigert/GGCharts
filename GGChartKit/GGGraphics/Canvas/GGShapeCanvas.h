//
//  GGShapeCanvas.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GGShapeCanvas : CAShapeLayer

/**
 * 旧扇形路径
 */
@property (nonatomic, assign) GGPie oldPie;

/**
 * 当前绘制的扇形
 */
@property (nonatomic, assign) GGPie pie;

/**
 * 旧路径
 */
@property (nonatomic, assign) CGPathRef oldRef;

/**
 * 路径变换动画
 *
 * @param duration 动画时间
 */
- (void)pathChangeAnimation:(NSTimeInterval)duration;

/**
 * 绘制扇形结构体
 *
 * @param pie 扇形图结构体
 */
- (void)drawPie:(GGPie)pie;

/**
 * 扇形图变换动画
 *
 * @param duration 动画时间
 */
- (void)pieChangeAnimation:(NSTimeInterval)duration;

@end
