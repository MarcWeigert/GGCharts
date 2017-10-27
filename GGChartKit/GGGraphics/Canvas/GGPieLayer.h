//
//  GGPieLayer.h
//  GGCharts
//
//  Created by _ | Durex on 17/10/18.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PieDrawAbstract.h"

@interface GGPieLayer : CALayer

/**
 * 结构体
 */
@property (nonatomic, assign) GGPie pie;

/**
 * 扇形图颜色
 */
@property (nonatomic, strong) UIColor * pieColor;

/**
 * 折线颜色
 */
@property (nonatomic, strong) UIColor * lineColor;

/**
 * 文字类
 */
@property (nonatomic, strong) GGNumberRenderer * numberRenderer;

/**
 * 外线显示样式
 */
@property (nonatomic, assign) OutSideLableType showOutLableType;

/**
 * 外线显示样式
 */
@property (nonatomic, strong) id <PieOutSideLableAbstract> outSideLable;


#pragma mark - 渐变色

/**
 * 颜色渐变曲线
 */
@property (nonatomic, assign) GradientCurve gradientCurve;

/**
 * 渐变色权重
 */
@property (nonatomic, strong) NSArray <NSNumber *> *gradientLocations;

/**
 * 渐变色
 */
@property (nonatomic, strong) NSArray <UIColor *> * gradientColors;

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 */
- (void)startPieLineStrokeStartAnimationWithDuration:(NSTimeInterval)duration;

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 */
- (void)startPieLineStrokeEndAnimationWithDuration:(NSTimeInterval)duration;

/**
 * 扇形图伸展动画
 *
 * @param duration 动画时长
 */
- (void)startPieOutRadiusLargeWithDuration:(NSTimeInterval)duation;

/**
 * 扇形图缩小动画
 *
 * @param duration 动画时长
 */
- (void)startPieOutRadiusSmallWithDuration:(NSTimeInterval)duation;

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 */
- (void)startPieChangeAnimationWithDuration:(NSTimeInterval)duration;

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 * @param transform 旋转动画
 */
- (void)startTransformArcAddWithDuration:(NSTimeInterval)duration baseTransform:(CGFloat)transform;

/**
 * 扇形图弹射动画
 *
 * @param duration 动画时长
 */
- (void)startEjectAnimationWithDuration:(NSTimeInterval)duration;

@end
