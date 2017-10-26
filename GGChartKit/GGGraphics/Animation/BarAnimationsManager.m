//
//  BarAnimationsManager.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/16.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarAnimationsManager.h"
#include <objc/runtime.h>

@interface BarAnimationsManager ()

/**
 * 柱状图抽象类数组
 */
@property (nonatomic, strong) NSMutableArray * barAbstractAry;

/**
 * 动画类
 */
@property (nonatomic, strong) Animator * animator;

@end

@implementation BarAnimationsManager

#pragma mark - Public Method

/**
 * 注册柱状图动画类
 *
 * @param 柱状抽象类
 */
- (void)registerBarDrawAbstract:(id <BarDrawAbstract>)barDrawAbstract
{
    [self.barAbstractAry addObject:barDrawAbstract];
}

/**
 * 清空动画类
 */
- (void)resetAnimationManager
{
    [self.barAbstractAry removeAllObjects];
}

/**
 * 开始动画
 *
 * @param 动画时长
 * @param 动画类型
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration animationType:(BarAnimationsType)type
{
    if (type == BarAnimationRiseType) {
        
        [self startRiseAnimationsWithDuration:duration];
    }
    else if (type == BarAnimationChangeType) {
    
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
    
    for (id <BarDrawAbstract> barAbstract in self.barAbstractAry) {
        
        [GET_ASSOCIATED(barAbstract, barUpLayer) pathChangeAnimation:duration];
        [GET_ASSOCIATED(barAbstract, barDownLayer) pathChangeAnimation:duration];
        
        [aryAllNumberRenderers addObjectsFromArray:GET_ASSOCIATED(barAbstract, barNumberArray)];
    }
    
    [self.animator startAnimationWithDuration:duration animationArray:aryAllNumberRenderers updateBlock:^(CGFloat progress) {
        
        for (id <BarDrawAbstract> drawBarAbstract in self.barAbstractAry) {
            
            [GET_ASSOCIATED(drawBarAbstract, barStringLayer) setNeedsDisplay];
        }
    }];
    
    [self.midLineLayer pathChangeAnimation:duration];
}

/**
 * 开启柱状图升起动画
 *
 * @param 动画时长
 */
- (void)startRiseAnimationsWithDuration:(NSTimeInterval)duration
{
    NSMutableArray * aryAllNumberRenderers = [NSMutableArray array];

    for (id <BarDrawAbstract> barAbstract in self.barAbstractAry) {
        
        CGMutablePathRef barRef = CGPathCreateMutable();
        NSArray * numberRenderers = GET_ASSOCIATED(barAbstract, barNumberArray);
        
        for (NSInteger i = 0; i < [barAbstract dataAry].count; i++) {
            
            CGRect barRect = [barAbstract barRects][i];
            CGRect risRect = CGRectMake(barRect.origin.x, [barAbstract bottomYPix], [barAbstract barWidth], 0);
            
            GGPathAddCGRect(barRef, risRect);
            
            if (numberRenderers) {
                
                GGNumberRenderer * renderer = numberRenderers[i];
                renderer.fromPoint = CGPointMake(renderer.toPoint.x, [barAbstract bottomYPix]);
                renderer.fromNumber = 0;
                [aryAllNumberRenderers addObject:renderer];
            }
        }
        
        GGShapeCanvas * upBarCanvas = GET_ASSOCIATED(barAbstract, barUpLayer);
        CAKeyframeAnimation * upAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        upAnimation.duration = duration;
        upAnimation.values = @[(__bridge id)barRef, (__bridge id)upBarCanvas.path];
        [upBarCanvas addAnimation:upAnimation forKey:@"barUpRiseAnimation"];
        
        GGShapeCanvas * downBarCanvas = GET_ASSOCIATED(barAbstract, barDownLayer);
        CAKeyframeAnimation * downAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        downAnimation.duration = duration;
        downAnimation.values = @[(__bridge id)barRef, (__bridge id)downBarCanvas.path];
        [downBarCanvas addAnimation:downAnimation forKey:@"barDownRiseAnimation"];

        CGPathRelease(barRef);
    }
    
    [self.animator startAnimationWithDuration:duration animationArray:aryAllNumberRenderers updateBlock:^(CGFloat progress) {
        
        for (id <BarDrawAbstract> drawBarAbstract in self.barAbstractAry) {
            
            [GET_ASSOCIATED(drawBarAbstract, barStringLayer) setNeedsDisplay];
        }
    }];
}


#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, barAbstractAry);

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
