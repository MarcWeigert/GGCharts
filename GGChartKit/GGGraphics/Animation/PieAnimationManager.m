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
        [self startLineAnimationWithPieAbstract:pieAbstract duation:duration];
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
        [self startLineAnimationWithPieAbstract:pieAbstract duation:duration];
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
    
        GGPie pie = [pieAbstract pies][i];
        GGShapeCanvas * shapeCanvas = pieShapeLayersArray[i];
        
        shapeCanvas.hidden = YES;
        
        [self performAfterDelay:i * duation / 2 block:^{
            
            shapeCanvas.hidden = NO;
            
            CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            pathAnimation.duration = duation;
            pathAnimation.values = EjectAnimationWithPie(pie, duation);
            [shapeCanvas addAnimation:pathAnimation forKey:@"pathAnimation"];
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
        [self startChangePieLineAnimationWithPieAbstract:pieAbstract duation:duration];
        [self startChangeNumberRendererAnimationWithPieAbstract:pieAbstract duation:duration];
    }
    
    [self.animator startAnimationWithDuration:duration animationArray:nil updateBlock:^(CGFloat progress) {
        
        for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {
        
            [GET_ASSOCIATED(pieAbstract, pieOutSideLayer) setNeedsDisplay];
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
        
        GGShapeCanvas * shapeCanvas = pieShapeLayersArray[i];
        [shapeCanvas pieChangeAnimation:duation];
    }
}

/**
 * 路径变换动画
 *
 * @param pieAbstract 扇形图接口
 * @param duation 动画时间
 */
- (void)startChangePieLineAnimationWithPieAbstract:(id <PieDrawAbstract>)pieAbstract duation:(NSTimeInterval)duation
{
    NSArray * pieLineShapeLayersArray = GET_ASSOCIATED(pieAbstract, pieOutSideLayerArray);
    NSArray * pieShapeLayersArray = GET_ASSOCIATED(pieAbstract, pieShapeLayerArray);
    
    for (NSInteger i = 0; i < pieShapeLayersArray.count; i++) {
        
        GGShapeCanvas * pieCanvas = pieShapeLayersArray[i];
        GGShapeCanvas * shapeCanvas = pieLineShapeLayersArray[i];
        
        CGFloat pieLineSpacing = [[pieAbstract outSideLable] lineSpacing];
        CGFloat pieLineLength = [[pieAbstract outSideLable] lineLength];
        CGFloat pieInflectionLength = [[pieAbstract outSideLable] inflectionLength];
        CGFloat endRadius = [[pieAbstract outSideLable] linePointRadius];
        CGFloat maxLineLength = [pieAbstract radiusRange].outRadius + pieLineSpacing + pieLineLength;
        
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = duation;
        pathAnimation.values = GGPieLineChange(pieCanvas.oldPie, pieCanvas.pie, maxLineLength, pieInflectionLength, endRadius, pieLineSpacing, duation);
        [shapeCanvas addAnimation:pathAnimation forKey:@"pathAnimation"];
    }
}

/**
 * 路径变换动画
 *
 * @param pieAbstract 扇形图接口
 * @param duation 动画时间
 */
- (void)startChangeNumberRendererAnimationWithPieAbstract:(id <PieDrawAbstract>)pieAbstract duation:(NSTimeInterval)duation
{
    NSArray * pieShapeLayersArray = GET_ASSOCIATED(pieAbstract, pieShapeLayerArray);
    NSArray * outSideNumerArray = GET_ASSOCIATED(pieAbstract, pieOutSideNumberArray);
    NSArray * innerNumerArray = GET_ASSOCIATED(pieAbstract, pieInnerNumberArray);
    
    if (outSideNumerArray) {
        
        for (NSInteger i = 0; i < pieShapeLayersArray.count; i++) {
            
            GGShapeCanvas * pieCanvas = pieShapeLayersArray[i];
            
            CGFloat pieLineSpacing = [[pieAbstract outSideLable] lineSpacing];
            CGFloat pieLineLength = [[pieAbstract outSideLable] lineLength];
            CGFloat pieInflectionLength = [[pieAbstract outSideLable] inflectionLength];
            CGFloat endRadius = [[pieAbstract outSideLable] linePointRadius];
            CGFloat maxLineLength = [pieAbstract radiusRange].outRadius + pieLineSpacing + pieLineLength;
            
            GGNumberRenderer * numberRenderer = outSideNumerArray[i];
            
            GGPie fromPie = pieCanvas.oldPie;
            GGPie toPie = pieCanvas.pie;
            
            [numberRenderer setDrawPointBlock:^CGPoint(CGFloat progress) {
                
                GGPie pie = PieFromToWithProgress(fromPie, toPie, progress);
                
                return PieLineEndPoint(pie, maxLineLength, pieInflectionLength, endRadius, pieLineSpacing);
            }];
            
            [self.animator addAnimatior:numberRenderer];
        }
    }
    
    if (innerNumerArray) {
    
        for (NSInteger i = 0; i < pieShapeLayersArray.count; i++) {
            
            GGShapeCanvas * pieCanvas = pieShapeLayersArray[i];
            
            GGNumberRenderer * numberRenderer = innerNumerArray[i];
            
            GGPie fromPie = pieCanvas.oldPie;
            GGPie toPie = pieCanvas.pie;
            
            [numberRenderer setDrawPointBlock:^CGPoint(CGFloat progress) {
                
                GGPie pie = PieFromToWithProgress(fromPie, toPie, progress);
                
                GGArcLine arcLine = GGArcLineMake(pie.center, pie.transform + pie.arc / 2, pie.radiusRange.outRadius * .5 + pie.radiusRange.inRadius * .5);
                GGLine line = GGLineWithArcLine(arcLine, false);
                
                return line.end;
            }];
            
            [self.animator addAnimatior:numberRenderer];
        }
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
 * 线性动画
 *
 * @param pieAbstract 扇形图接口
 * @param duation 动画时间
 */
- (void)startLineAnimationWithPieAbstract:(id <PieDrawAbstract>)pieAbstract duation:(NSTimeInterval)duation
{
    NSArray * pieLineLayersArray = GET_ASSOCIATED(pieAbstract, pieOutSideLayerArray);
    
    for (NSInteger i = 0; i < pieLineLayersArray.count; i++) {
    
        GGShapeCanvas * shapeLayer = pieLineLayersArray[i];
        GGPie pie = [pieAbstract pies][i];
        
        CGFloat pieLineSpacing = [[pieAbstract outSideLable] lineSpacing];
        CGFloat pieLineLength = [[pieAbstract outSideLable] lineLength];
        CGFloat pieInflectionLength = [[pieAbstract outSideLable] inflectionLength];
        CGFloat endRadius = [[pieAbstract outSideLable] linePointRadius];
        CGFloat maxLineLength = [pieAbstract radiusRange].outRadius + pieLineSpacing + pieLineLength;
        
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = duation;
        pathAnimation.values = GGPieLineStretch(pie, maxLineLength, pieInflectionLength, endRadius, pieLineSpacing);
        [shapeLayer addAnimation:pathAnimation forKey:@"pathAnimation"];
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
    
    for (NSInteger i = 0; i < pieLayersArray.count; i++) {
        
        GGPie pie = [pieAbstract pies][i];
        GGShapeCanvas * shapeCanvas = pieLayersArray[i];
        
        GGPie fromPie = GGPieCopyWithPie(pie);
        fromPie.transform = [pieAbstract pieStartTransform];
        fromPie.arc = 0;
        
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = duation;
        pathAnimation.values = GGPieChange(fromPie, pie, duation);
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
