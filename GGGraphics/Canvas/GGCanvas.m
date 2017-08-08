//
//  GGCanvas.m
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGCanvas.h"
#import <UIKit/UIKit.h>
#import "GGShapeCanvas.h"

@interface GGCanvas ()

@property (nonatomic) NSMutableArray <id <GGRenderProtocol>>*aryRenderer;

@property (nonatomic, strong) NSMutableArray <GGShapeCanvas *> * visibleLayers;      ///< 显示的图层
@property (nonatomic, strong) NSMutableArray <GGShapeCanvas *> * idleLayers;         ///< 闲置的图层

@property (nonatomic, strong) NSMutableArray <CAGradientLayer *> * visibleGradientLayers;      ///< 显示的图层
@property (nonatomic, strong) NSMutableArray <CAGradientLayer *> * idleGradientLayers;         ///< 闲置的图层

@end

@implementation GGCanvas

#pragma mark - Shape

/**
 * 取图层视图大小与Chart一致
 */
- (GGShapeCanvas *)getGGCanvasEqualFrame
{
    GGShapeCanvas * shape = [self makeOrGetShapeCanvas];
    shape.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSublayer:shape];
    [self.visibleLayers addObject:shape];
    return shape;
}

/**
 * 取图层视图大小为正方形
 */
- (GGShapeCanvas *)getGGCanvasSquareFrame
{
    CGFloat width = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    GGShapeCanvas * shape = [self makeOrGetShapeCanvas];
    shape.frame = CGRectMake(0, 0, width, width);
    shape.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSublayer:shape];
    [self.visibleLayers addObject:shape];
    return shape;
}

/**
 * 获取图层
 */
- (GGShapeCanvas *)makeOrGetShapeCanvas
{
    GGShapeCanvas * shape = [self.idleLayers firstObject];
    
    if (shape == nil) {
        
        shape = [[GGShapeCanvas alloc] init];
    }
    else {
        
        [self.idleLayers removeObject:shape];
    }
    
   return shape;
}

#pragma mark - Gradient

/**
 * 取图层视图大小与Chart一致
 */
- (CAGradientLayer *)getCAGradientEqualFrame
{
    CAGradientLayer * gradientLayer = [self makeOrGetGradientCanvas];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSublayer:gradientLayer];
    [self.visibleGradientLayers addObject:gradientLayer];
    return gradientLayer;
}

/**
 * 取图层视图大小为正方形
 */
- (CAGradientLayer *)getCAGradientSquareFrame
{
    CGFloat width = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    CAGradientLayer * gradientLayer = [self makeOrGetGradientCanvas];
    gradientLayer.frame = CGRectMake(0, 0, width, width);
    gradientLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self addSublayer:gradientLayer];
    [self.visibleGradientLayers addObject:gradientLayer];
    return gradientLayer;
}

/**
 * 渐变色
 */
- (CAGradientLayer *)makeOrGetGradientCanvas
{
    CAGradientLayer * shape = [self.idleGradientLayers firstObject];
    
    if (shape == nil) {
        
        shape = [[CAGradientLayer alloc] init];
    }
    else {
        
        [self.idleGradientLayers removeObject:shape];
    }
    
    return shape;
}

/**
 * 绘制图表(子类重写)
 */
- (void)drawChart
{
    // 形
    [self.idleLayers addObjectsFromArray:self.visibleLayers];
    
    [self.visibleLayers enumerateObjectsUsingBlock:^(GGShapeCanvas * obj, NSUInteger idx, BOOL * stop) {
        
        [obj removeFromSuperlayer];
    }];
    
    [self.visibleLayers removeAllObjects];
    
    // 渐变色
    [self.idleGradientLayers addObjectsFromArray:self.visibleGradientLayers];
    
    [self.visibleGradientLayers enumerateObjectsUsingBlock:^(CAGradientLayer * obj, NSUInteger idx, BOOL * stop) {
        
        [obj removeFromSuperlayer];
    }];
    
    [self.visibleGradientLayers removeAllObjects];
}

#pragma mark - 绘制

/** 初始化 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.masksToBounds = YES;
        _aryRenderer = [NSMutableArray array];
    }
    
    return self;
}

/**
 * 增加一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)addRenderer:(id <GGRenderProtocol>)renderer
{
    [self.aryRenderer addObject:renderer];
}

/**
 * 删除一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)removeRenderer:(id <GGRenderProtocol>)renderer
{
    [self.aryRenderer removeObject:renderer];
}

/**
 * 删除所有绘图工具
 */
- (void)removeAllRenderer
{
    [self.aryRenderer removeAllObjects];
}

/**
 * 继承 CALayer 
 *
 * @param ctx 上下文
 */
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    if (_isCloseDisableActions) {
        
        [CATransaction setDisableActions:YES];
    }
    
    [super drawInContext:ctx];
    
    for (id <GGRenderProtocol> renderer in _aryRenderer) {
        
        [renderer drawInContext:ctx];
    }
    
    CGContextRestoreGState(ctx);
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, visibleLayers);
GGLazyGetMethod(NSMutableArray, idleLayers);

GGLazyGetMethod(NSMutableArray, visibleGradientLayers);
GGLazyGetMethod(NSMutableArray, idleGradientLayers);

@end
