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
    [self startEjectAnimationWithDuration:duration];
}

#pragma mark - Line Animations

- (NSArray *)spiderLineAnimation:(GGLine)line_m circle:(GGCircle)circle
{
    CGMutablePathRef ref1 = CGPathCreateMutable();
    CGMutablePathRef ref2 = CGPathCreateMutable();
    CGMutablePathRef ref3 = CGPathCreateMutable();
    CGMutablePathRef ref4 = CGPathCreateMutable();
    CGMutablePathRef ref5 = CGPathCreateMutable();
    CGMutablePathRef ref6 = CGPathCreateMutable();
    
    CGPathMoveToPoint(ref1, NULL, line_m.start.x, line_m.start.y);
    CGPathAddLineToPoint(ref1, NULL, line_m.start.x, line_m.start.y);
    
    CGPathMoveToPoint(ref2, NULL, line_m.start.x, line_m.start.y);
    CGPathAddLineToPoint(ref2, NULL, line_m.end.x, line_m.end.y);
    
    GGPathAddLine(ref3, line_m);
    CGPathMoveToPoint(ref3, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref3, NULL, circle.center.x, circle.center.y);
    
    GGPathAddLine(ref4, line_m);
    CGPathMoveToPoint(ref4, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref4, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref4, circle);
    
    GGPathAddLine(ref5, line_m);
    CGPathMoveToPoint(ref5, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref5, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref5, GGCirclePointMake(circle.center, circle.radius + .5f));
    
    GGPathAddLine(ref6, line_m);
    CGPathMoveToPoint(ref6, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref6, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref6, circle);
    
    NSArray * paths = @[(__bridge id)ref1, (__bridge id)ref2, (__bridge id)ref3,
                        (__bridge id)ref4, (__bridge id)ref5, (__bridge id)ref6];
    
    CFRelease(ref1);
    CFRelease(ref2);
    CFRelease(ref3);
    CFRelease(ref4);
    CFRelease(ref5);
    CFRelease(ref6);
    
    return paths;
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

- (void)startEjectAnimationWithDuration:(NSTimeInterval)duration
{
    for (id <PieDrawAbstract> pieAbstract in [self.pieCanvasAbstract pieAry]) {
        
        [self startEjectAnimationWithPieAbstract:pieAbstract duation:duration];
        [self startLineAnimationWithPieAbstract:pieAbstract duation:duration];
    }
    
    [self startInnerLableAnimationWithDuation:duration];
}

- (void)startEjectAnimationWithPieAbstract:(id <PieDrawAbstract>)pieAbstract duation:(NSTimeInterval)duation
{
    CGFloat maxValue = .0f, minValue = .0f;
    
    if ([pieAbstract roseType] == RoseRadius) {     // 取得最大值
        
        [[pieAbstract dataAry] getMax:&maxValue min:&minValue selGetter:@selector(floatValue) base:0];
    }
    
    NSArray * pieShapeLayersArray = GET_ASSOCIATED(pieAbstract, pieShapeLayerArray);
    
    for (NSInteger i = 0; i < pieShapeLayersArray.count; i++) {
    
        GGPie pie = [pieAbstract pies][i];
        GGShapeCanvas * shapeCanvas = pieShapeLayersArray[i];
    
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
    CGFloat maxValue = .0f, minValue = .0f;
    
    if ([pieAbstract roseType] == RoseRadius) {     // 取得最大值
        
        [[pieAbstract dataAry] getMax:&maxValue min:&minValue selGetter:@selector(floatValue) base:0];
    }
    
    NSArray * pieLineLayersArray = GET_ASSOCIATED(pieAbstract, pieOutSideLayerArray);
    
    for (NSInteger i = 0; i < pieLineLayersArray.count; i++) {
    
        GGShapeCanvas * shapeLayer = pieLineLayersArray[i];
        GGPie pie = [pieAbstract pies][i];
        
        CGFloat pieLineSpacing = [[pieAbstract outSideLable] lineSpacing];
        CGFloat pieLineLength = [[pieAbstract outSideLable] lineLength];
        CGFloat pieInflectionLength = [[pieAbstract outSideLable] inflectionLength];
        
        CGFloat lineStartMove =  pie.radiusRange.outRadius + pieLineSpacing;
        
        // 根据比例伸缩
        if ([pieAbstract roseType] == RoseRadius) {
            
            CGFloat ratioBaseValue = maxValue == 0 ? 1 : maxValue;
            CGFloat radius = pie.radiusRange.outRadius - pie.radiusRange.inRadius;
            radius *= [[pieAbstract dataAry][i] floatValue] / ratioBaseValue;
            lineStartMove = pie.radiusRange.inRadius + radius + pieLineSpacing;
        }
        
        // 逐步设置内外半径
        if ([pieAbstract pieRadiuRangeForIndex]) {
            
            pie.radiusRange = [pieAbstract pieRadiuRangeForIndex](i);
            lineStartMove = pie.radiusRange.outRadius + pieLineSpacing;
        }
        
        CGPoint draw_center = CGPointMake(shapeLayer.gg_width / 2, shapeLayer.gg_height / 2);
        GGArcLine arcLine = GGArcLineMake(draw_center, pie.transform + pie.arc / 2, pie.radiusRange.outRadius + pieLineSpacing + pieLineLength);
        GGLine line = GGLineWithArcLine(arcLine, false);
        GGLine line_m = GGLineMoveStart(line, lineStartMove);
        CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, pieInflectionLength);
        GGCircle circle = GGCirclePointMake(end_pt, [[pieAbstract outSideLable] linePointRadius]);
        
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = duation;
        pathAnimation.values = [self spiderLineAnimation:line_m circle:circle];
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
