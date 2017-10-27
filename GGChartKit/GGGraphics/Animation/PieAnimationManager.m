//
//  PieAnimationManager.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieAnimationManager.h"
#import <objc/runtime.h>
#import "NSObject+FireBlock.h"
#import "GGPieLayer.h"

#pragma mark - PieAnimationManager

@interface PieAnimationManager ()

/**
 * 动画类
 */
@property (nonatomic, strong) Animator * animator;

/**
 * 当前点击的位置
 */
@property (nonatomic, strong) NSIndexPath * beforeIndexPath;

/**
 * 当前点击的位置
 */
@property (nonatomic, assign) GGPie beforePie;

@end

@implementation PieAnimationManager

- (void)setPieCanvasAbstract:(id<PieCanvasAbstract>)pieCanvasAbstract
{
    _pieCanvasAbstract = pieCanvasAbstract;
    
    _beforeIndexPath = nil;
    _beforePie = GGPieZero;
}

/**
 * 开始动画
 *
 * @param 动画时长
 * @param 动画类型
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration animationType:(PieAnimationType)type
{
    if (type == RotationAnimation) {
        
        [self startRotationAnimationWithDuration:duration];
    }
    else if (type == EjectAnimation) {
    
        [self startEjectAnimationWithDuration:duration];
    }
    else if (type == ChangeAnimation) {
        
        [self startChangeAnimationWithDuration:duration];
    }
}

/**
 * 点击动画
 */
- (void)startAnimationForIndexPath:(NSIndexPath *)indexPath
{
    id <PieDrawAbstract> pieAbstract = [_pieCanvasAbstract pieAry][indexPath.section];
    NSArray * pieLayersArray = GET_ASSOCIATED(pieAbstract, pieShapeLayerArray);
    
    if (_beforeIndexPath) {
        
        GGPieLayer * pieLayer = pieLayersArray[_beforeIndexPath.row];
        [pieLayer startPieOutRadiusSmallWithDuration:.25f];
        
        if ([pieAbstract showOutLableType] == OutSideSelect) {
            
            [pieLayer startPieLineStrokeEndAnimationWithDuration:.25f];
        }
    }
    
    if (_beforeIndexPath == nil ||
        !(_beforeIndexPath.row == indexPath.row &&
          _beforeIndexPath.section == indexPath.section)) {

        GGPieLayer * pieLayer = pieLayersArray[indexPath.row];
        [pieLayer startPieOutRadiusLargeWithDuration:.25f];
        
        if ([pieAbstract showOutLableType] == OutSideSelect) {

            [pieLayer startPieLineStrokeStartAnimationWithDuration:.25f];
        }
        
        _beforeIndexPath = indexPath;
    }
    else {
    
        _beforeIndexPath = nil;
    }
}

- (void)startLineAnimationWithLayer:(GGShapeCanvas *)lineCanvas pie:(GGPie)pie pieAbstract:(id <PieDrawAbstract>)pieAbstract show:(BOOL)show
{
    CGFloat pieLineSpacing = [[pieAbstract outSideLable] lineSpacing];
    CGFloat pieLineLength = [[pieAbstract outSideLable] lineLength];
    CGFloat pieInflectionLength = [[pieAbstract outSideLable] inflectionLength];
    CGFloat endRadius = [[pieAbstract outSideLable] linePointRadius];
    CGFloat maxLineLength = [pieAbstract radiusRange].outRadius + pieLineSpacing + pieLineLength;
    
    NSArray * values = GGPieLineStretch(pie, maxLineLength, pieInflectionLength, endRadius, pieLineSpacing);
    lineCanvas.hidden = NO;
    
    if (!show) {
        
        values = [[values reverseObjectEnumerator] allObjects];
    }
    
    GGPathKeyFrameAnimation(lineCanvas, @"linePathAnimation", .25, values);
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
    
    [self startInnerLableAnimationWithDuation:duration];
}

/**
 * 弹射动画
 *
 * @param duration 动画时间
 */
- (void)startEjectAnimationWithDuration:(NSTimeInterval)duration
{
    for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {
        
        [self startEjectAnimationWithPieAbstract:pieAbstract duation:duration];
    }
    
    [self startInnerLableAnimationWithDuation:duration];
}

/**
 * 弹射动画
 *
 * @param pieAbstract 扇形图接口
 * @param duation 动画时间
 */
- (void)startEjectAnimationWithPieAbstract:(id <PieDrawAbstract>)pieAbstract duation:(NSTimeInterval)duation
{
    NSArray * pieShapeLayersArray = GET_ASSOCIATED(pieAbstract, pieShapeLayerArray);
    
    for (NSInteger i = 0; i < pieShapeLayersArray.count; i++) {
    
        GGPieLayer * pieLayer = pieShapeLayersArray[i];
        pieLayer.hidden = YES;
        
        [self performAfterDelay:i * duation / pieShapeLayersArray.count block:^{
            
            [pieLayer startEjectAnimationWithDuration:duation / pieShapeLayersArray.count];
        }];
    }
}

#pragma mark - 路径变化动画

/**
 * 路径变换动画
 *
 * @param duration 动画时间
 */
- (void)startChangeAnimationWithDuration:(NSTimeInterval)duration
{
    for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {
        
        [self startChangeAnimationWithPieAbstract:pieAbstract duation:duration];
    }
    
    [self.animator startAnimationWithDuration:duration animationArray:nil updateBlock:^(CGFloat progress) {
        
        for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {
        
            [GET_ASSOCIATED(pieAbstract, pieInnerLayer) setNeedsDisplay];
        }
    }];
}

/**
 * 路径变换动画
 *
 * @param pieAbstract 扇形图接口
 * @param duation 动画时间
 */
- (void)startChangeAnimationWithPieAbstract:(id <PieDrawAbstract>)pieAbstract duation:(NSTimeInterval)duation
{
    NSArray * pieShapeLayersArray = GET_ASSOCIATED(pieAbstract, pieShapeLayerArray);
    
    for (NSInteger i = 0; i < pieShapeLayersArray.count; i++) {
        
        GGPieLayer * pieLayer = pieShapeLayersArray[i];
        [pieLayer startPieChangeAnimationWithDuration:duation];
    }
}

#pragma mark - 逐一弹射动画

/**
 * 绘制Lable动画
 *
 * @param pieAbstract 扇形图接口
 * @param duation 动画时间
 */
- (void)startInnerLableAnimationWithDuation:(NSTimeInterval)duration
{
    NSMutableArray * arrayNumbers = [NSMutableArray array];
    
    for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {

        NSArray * innerNumerArray = GET_ASSOCIATED(pieAbstract, pieInnerNumberArray);
        
        if (innerNumerArray) {
            
            [innerNumerArray enumerateObjectsUsingBlock:^(GGNumberRenderer * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.fromPoint = obj.toPoint;
                obj.fromNumber = 0;
                
                [arrayNumbers addObject:obj];
            }];
        }
        
        NSArray * outSideNumerArray = GET_ASSOCIATED(pieAbstract, pieOutSideNumberArray);
        
        if (outSideNumerArray) {
            
            [outSideNumerArray enumerateObjectsUsingBlock:^(GGNumberRenderer * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.fromPoint = obj.toPoint;
                obj.fromNumber = 0;
                
                [arrayNumbers addObject:obj];
            }];
        }
    }
    
    [self.animator startAnimationWithDuration:duration animationArray:arrayNumbers updateBlock:^(CGFloat progress) {
        
        for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {
            
            [GET_ASSOCIATED(pieAbstract, pieInnerLayer) setNeedsDisplay];
            [GET_ASSOCIATED(pieAbstract, pieOutSideLayer) setNeedsDisplay];
        }
    }];
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
    
    for (NSInteger i = 0; i < pieLayersArray.count; i++) {
        
        GGPieLayer * pieLayer = pieLayersArray[i];
        
        [pieLayer startTransformArcAddWithDuration:duation baseTransform:M_PI * 1.5];
    }
    
    CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duation;
    scaleAnimation.values = @[@.5, @1];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
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
