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
#import "NSObject+FireBlock.h"
#import "GGPieLayer.h"

#pragma mark - NSIndexPath (PieIndexPath)

@interface NSIndexPath (PieIndexPath)

@end

@implementation NSIndexPath(PieIndexPath)

- (BOOL)isEqual:(id)object
{
    return (self.row == [object row] && self.section == [object section]);
}

@end

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
    NSArray * pieLineLayersArray = GET_ASSOCIATED(pieAbstract, pieOutSideLayerArray);
    GGCanvas * outBaseCanvas = GET_ASSOCIATED(pieAbstract, pieOutSideLayer);
    NSArray * pieNumberArray = GET_ASSOCIATED(pieAbstract, pieOutSideNumberArray);
    
    if (_beforeIndexPath) {
        
        GGShapeCanvas * beforeCanvas = pieLayersArray[_beforeIndexPath.row];
        GGPie pie = [pieAbstract pies][_beforeIndexPath.row];
        GGPie small_pie = GGPieCopyWithPie(pie);
        small_pie.radiusRange.outRadius -= GGRadiusRangeGetRadius(pie.radiusRange) * .05f;
        
        NSMutableArray * beforePies = [NSMutableArray array];
        [beforePies addObjectsFromArray:GGPieChange(_beforePie, small_pie, .2f)];
        [beforePies addObjectsFromArray:GGPieChange(small_pie, pie, .05f)];
        
        GGPathKeyFrameAnimation(beforeCanvas, @"pieLargeAnimation", .25f, beforePies);
        
        if ([pieAbstract showOutLableType] == OutSideSelect) {
            
            GGShapeCanvas * lineCanvas = pieLineLayersArray[_beforeIndexPath.row];
            [self startLineAnimationWithLayer:lineCanvas pie:pie pieAbstract:pieAbstract show:NO];
            
            GGNumberRenderer * number = pieNumberArray[_beforeIndexPath.row];
            number.hidden = YES;
            [outBaseCanvas setNeedsDisplay];
        }
    }
    
    if (![_beforeIndexPath isEqual:indexPath]) {
        
        GGShapeCanvas * shapeCanvas = pieLayersArray[indexPath.row];
        GGPie pie = [pieAbstract pies][indexPath.row];
        GGPie large_pie = GGPieCopyWithPie(pie);
        large_pie.radiusRange.outRadius += GGRadiusRangeGetRadius(pie.radiusRange) * .15f;
        _beforePie = GGPieCopyWithPie(pie);
        _beforePie.radiusRange.outRadius += GGRadiusRangeGetRadius(pie.radiusRange) * .1f;
        
        NSMutableArray * aryPies = [NSMutableArray array];
        [aryPies addObjectsFromArray:GGPieChange(pie, large_pie, .2f)];
        [aryPies addObjectsFromArray:GGPieChange(large_pie, _beforePie, .05f)];
        
        GGPathKeyFrameAnimation(shapeCanvas, @"pieSmallAnimation", .25f, aryPies);
        
        if ([pieAbstract showOutLableType] == OutSideSelect) {
            
            GGShapeCanvas * lineCanvas = pieLineLayersArray[indexPath.row];
            [self startLineAnimationWithLayer:lineCanvas pie:pie pieAbstract:pieAbstract show:YES];
            
            GGNumberRenderer * number = pieNumberArray[indexPath.row];
            number.hidden = NO;
            [outBaseCanvas setNeedsDisplay];
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
