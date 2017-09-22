//
//  PieAnimationManager.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieAnimationManager.h"
#import <objc/runtime.h>
#import "NSArray+Stock.h"

@interface PieAnimationManager ()

/**
 * 动画类
 */
@property (nonatomic, strong) Animator * animator;

@end

@implementation PieAnimationManager

/**
 * 开始动画
 *
 * @param 动画时长
 * @param 动画类型
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration animationType:(PieAnimationType)type
{
    [self startRotationAnimationWithDuration:duration];
}

#pragma mark - 中心旋转动画

/**
 * 中心旋转动画
 *
 * @param duration 动画时间
 */
- (void)startRotationAnimationWithDuration:(NSTimeInterval)duration
{
    for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {
        
        [self startRotationAnimationWithPieAbstract:pieAbstract duation:duration];
    }
}

/**
 * 中心旋转动画
 *
 * @param pieAbstract 扇形图接口类
 * @param duration 动画时间
 */
- (void)startRotationAnimationWithPieAbstract:(id <PieDrawAbstract>)pieAbstract duation:(NSTimeInterval)duation
{
    NSArray * pieLayersArray = GET_ASSOCIATED(pieAbstract, pieShapeLayerArray);
    
    CGFloat maxValue = .0f, minValue = .0f;
    
    if ([pieAbstract roseType] == RoseRadius) {     // 取得最大值
        
        [[pieAbstract dataAry] getMax:&maxValue min:&minValue selGetter:@selector(floatValue) base:0];
    }
    
    for (NSInteger i = 0; i < pieLayersArray.count; i++) {
        
        GGPie pie = [pieAbstract pies][i];
        GGShapeCanvas * shapeCanvas = pieLayersArray[i];
        
        CAKeyframeAnimation * transAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        transAnimation.duration = duation;
        transAnimation.values = @[@([pieAbstract pieStartTransform]), @(pie.transform)];
        [shapeCanvas addAnimation:transAnimation forKey:@"transAnimation"];
        
        // 根据比例伸缩
        if ([pieAbstract roseType] == RoseRadius) {
            
            CGFloat ratioBaseValue = maxValue == 0 ? 1 : maxValue;
            CGFloat radius = pie.radiusRange.outRadius - pie.radiusRange.inRadius;
            radius *= [[pieAbstract dataAry][i] floatValue] / ratioBaseValue;
            pie.radiusRange.outRadius = pie.radiusRange.inRadius + radius;
        }
        
        // 逐步设置内外半径
        if ([pieAbstract pieRadiuRangeForIndex]) {
            
            pie.radiusRange = [pieAbstract pieRadiuRangeForIndex](i);
        }
        
        pie.transform = 0;
        
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = duation;
        pathAnimation.values = RotationAnimaitonWithPie(pie, duation);
        [shapeCanvas addAnimation:pathAnimation forKey:@"pathAnimation"];
    }
    
    CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duation;
    scaleAnimation.values = @[@.5, @1];
    [GET_ASSOCIATED(pieAbstract, pieBaseShapeLayer) addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [GET_ASSOCIATED(pieAbstract, pieInnerLayer) addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

#pragma mark - Lazy

/**
 * 动画类
 */
- (Animator *)animator
{
    if (_animator == nil) {
        
        _animator = [[Animator alloc] init];
        _animator.animationType = AnimationLinear;
    }
    
    return _animator;
}

@end
