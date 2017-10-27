//
//  GGShapeCanvas.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGShapeCanvas.h"

@interface GGShapeCanvas ()

@end

@implementation GGShapeCanvas

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _oldPie = GGPieZero;
        _pie = GGPieZero;
    }
    
    return self;
}

/**
 * 绘制扇形结构体
 *
 * @param pie 扇形图结构体
 */
- (void)drawPie:(GGPie)pie
{
    _oldPie = _pie;
    
    CGMutablePathRef ref = CGPathCreateMutable();
    GGPathAddPie(ref, pie);
    self.path = ref;
    CGPathRelease(ref);
    _pie = pie;
}

/**
 * 路径变换动画
 *
 * @param duration 动画时间
 */
- (void)pathChangeAnimation:(NSTimeInterval)duration
{
    if (_oldRef) {
        
        CABasicAnimation * shapeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        shapeAnimation.fromValue = (__bridge id)_oldRef;
        shapeAnimation.toValue = (__bridge id)self.path;
        shapeAnimation.duration = duration;
        [self addAnimation:shapeAnimation forKey:@"shapeAnimation"];
    }
}

/**
 * 扇形图变换动画
 *
 * @param duration 动画时间
 */
- (void)pieChangeAnimation:(NSTimeInterval)duration
{
    if (!GGPieIsEmpty(_oldPie)) {
        
        GGPathKeyFrameAnimation(self, @"pieChangeAnimation", duration, GGPieChange(_oldPie, _pie, duration));
    }
}

/**
 * 对象销毁
 */
- (void)dealloc
{
    CGPathRelease(_oldRef);
}

#pragma mark - Getter && Setter

/**
 * 设置旧路径
 */
- (void)setOldRef:(CGPathRef)oldRef
{
    if (_oldRef) {
        
        CGPathRelease(_oldRef);
    }
    
    _oldRef = oldRef;
    CGPathRetain(_oldRef);
}

/**
 * 设置路径
 */
- (void)setPath:(CGPathRef)path
{
    if (self.path) { self.oldRef = self.path; }
    
    [super setPath:path];
}

@end
