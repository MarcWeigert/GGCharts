//
//  LineAnimationsManager.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/17.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineAnimationsManager.h"
#import <objc/runtime.h>

@interface LineAnimationsManager ()

/**
 * 柱状图抽象类数组
 */
@property (nonatomic, strong) NSMutableArray * lineAbstractAry;

/**
 * 动画类
 */
@property (nonatomic, strong) Animator * animator;

@end

@implementation LineAnimationsManager

#pragma mark - Public Method

/**
 * 注册折线图动画类
 *
 * @param 折线抽象类
 */
- (void)registerLineDrawAbstract:(id <LineDrawAbstract>)lineDrawAbstract
{
    [self.lineAbstractAry addObject:lineDrawAbstract];
}

/**
 * 清空动画类
 */
- (void)resetAnimationManager
{
    [self.lineAbstractAry removeAllObjects];
}

/**
 * 开始动画
 *
 * @param 动画时长
 * @param 动画类型
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration animationType:(LineAnimationsType)type
{
    if (type == LineAnimationRiseType) {
        
        [self startLineRiseAnimationWithDuration:duration];
    }
    else if (type == LineAnimationChangeType) {
        
        [self startChangeAnimationWithDuration:duration];
    }
}

#pragma mark - Private Method

/**
 * 开启柱状图变换
 *
 * @param 动画时长
 */
- (void)startChangeAnimationWithDuration:(NSTimeInterval)duration
{
    NSMutableArray * aryAllNumberRenderers = [NSMutableArray array];
    
    for (id <BarDrawAbstract> barAbstract in self.lineAbstractAry) {
        
        [GET_ASSOCIATED(barAbstract, lineFillLayer) pathChangeAnimation:duration];
        [GET_ASSOCIATED(barAbstract, lineLayer) pathChangeAnimation:duration];
        [GET_ASSOCIATED(barAbstract, lineShapeLayer) pathChangeAnimation:duration];
        
        [aryAllNumberRenderers addObjectsFromArray:GET_ASSOCIATED(barAbstract, lineNumberArray)];
    }
    
    [self.animator startAnimationWithDuration:duration animationArray:aryAllNumberRenderers updateBlock:^(CGFloat progress) {
        
        for (id <LineDrawAbstract> lineDrawAbstract in self.lineAbstractAry) {
            
            [GET_ASSOCIATED(lineDrawAbstract, lineStringLayer) setNeedsDisplay];
        }
    }];
}


/**
 * 开启柱状图升起动画
 *
 * @param 动画时长
 */

- (void)startLineRiseAnimationWithDuration:(NSTimeInterval)duration
{
    NSMutableArray * aryAllNumberRenderers = [NSMutableArray array];
    
    for (id <LineDrawAbstract> lineAbstract in self.lineAbstractAry) {
        
        CGPoint * linePoints = [lineAbstract points];
        NSInteger size = [lineAbstract dataAry].count;
        CGFloat bottomPix = [lineAbstract bottomYPix];
        NSArray * numberRenderers = GET_ASSOCIATED(lineAbstract, lineNumberArray);
        
        if (numberRenderers) {
            
            for (NSInteger i = 0; i < [lineAbstract dataAry].count; i++) {
                
                GGNumberRenderer * renderer = numberRenderers[i];
                renderer.fromPoint = CGPointMake(renderer.toPoint.x, bottomPix);
                renderer.fromNumber = 0;
                [aryAllNumberRenderers addObject:renderer];
            }
        }
        
        GGShapeCanvas * anifillLayer = GET_ASSOCIATED(lineAbstract, lineFillLayer);
        
        if (anifillLayer) {
            
            CAKeyframeAnimation * fillAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            fillAnimation.duration = duration;
            fillAnimation.values = GGPathFillLinesUpspringAnimation(linePoints, size, bottomPix);
            [anifillLayer addAnimation:fillAnimation forKey:@"fillAnimation"];
        }
        
        GGShapeCanvas * aniLineLayer = GET_ASSOCIATED(lineAbstract, lineLayer);
        
        if (aniLineLayer) {
            
            CAKeyframeAnimation * lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            lineAnimation.duration = duration;
            lineAnimation.values = GGPathLinesUpspringAnimation(linePoints, size, bottomPix);
            [aniLineLayer addAnimation:lineAnimation forKey:@"lineAnimation"];
        }
        
        GGShapeCanvas * aniShapeLayer = GET_ASSOCIATED(lineAbstract, lineShapeLayer);
        
        if (aniShapeLayer) {
            
            CAKeyframeAnimation * pointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            pointAnimation.duration = duration;
            pointAnimation.values = GGPathCirclesUpspringAnimation(linePoints, [lineAbstract shapeRadius], size, bottomPix);
            [aniShapeLayer addAnimation:pointAnimation forKey:@"pointAnimation"];
        }
    }
    
    [self.animator startAnimationWithDuration:duration animationArray:aryAllNumberRenderers updateBlock:^(CGFloat progress) {
        
        for (id <LineDrawAbstract> lineDrawAbstract in self.lineAbstractAry) {
            
            [GET_ASSOCIATED(lineDrawAbstract, lineStringLayer) setNeedsDisplay];
        }
    }];
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, lineAbstractAry);

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
