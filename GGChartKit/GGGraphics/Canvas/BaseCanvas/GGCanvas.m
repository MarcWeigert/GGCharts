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

/**
 * 渲染器
 */
@property (nonatomic, strong) NSMutableArray <id <GGRenderProtocol>> * aryRenderer;

/**
 * 更新页面之前的渲染器数组
 */
@property (nonatomic, strong) NSMutableArray <id <GGRenderProtocol>> * aryBeforeRenderer;

/**
 * 当前页面渲染器数组
 */
@property (nonatomic, strong) NSMutableArray <id <GGRenderProtocol>> * aryCurrentRenderer;


#pragma mark - Layers

/**
 * 显示的图层(路径层)
 */
@property (nonatomic, strong) NSMutableArray <GGShapeCanvas *> * visibleLayers;

/**
 * 闲置的图层(路径层)
 */
@property (nonatomic, strong) NSMutableArray <GGShapeCanvas *> * idleLayers;

/**
 * 显示的图层(渐变色)
 */
@property (nonatomic, strong) NSMutableArray <CAGradientLayer *> * visibleGradientLayers;

/**
 * 闲置的图层(渐变色)
 */
@property (nonatomic, strong) NSMutableArray <CAGradientLayer *> * idleGradientLayers;

/**
 * 显示的图层(普通)
 */
@property (nonatomic, strong) NSMutableArray <GGCanvas *> * visibleCanvas;

/**
 * 闲置的图层(普通)
 */
@property (nonatomic, strong) NSMutableArray <GGCanvas *> * idleCanvas;

/**
 * 显示的图层(普通)
 */
@property (nonatomic, strong) NSMutableArray <GGPieLayer *> * visiblePieLayer;

/**
 * 闲置的图层(普通)
 */
@property (nonatomic, strong) NSMutableArray <GGPieLayer *> * idlePieLayer;


#pragma mark - Renderer

/**
 * 当前显示的NumberRenderer
 */
@property (nonatomic, strong) NSMutableArray <GGNumberRenderer *> * visibleNumberRenderer;

/**
 * 闲置的NumberRenderer
 */
@property (nonatomic, strong) NSMutableArray <GGNumberRenderer *> * idleNumberRenderer;

@end

@implementation GGCanvas

/** 初始化 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.masksToBounds = YES;
    }
    
    return self;
}

#pragma mark - Renderer

/**
 * 获取Number渲染器
 */
- (GGNumberRenderer *)getNumberRenderer
{
    GGNumberRenderer * numberRenderer = [self makeOrGetNumberRenrer];
    [self.visibleNumberRenderer addObject:numberRenderer];
    return numberRenderer;
}

/**
 * 获取number渲染器
 */
- (GGNumberRenderer *)makeOrGetNumberRenrer
{
    GGNumberRenderer * renderer = [self.idleNumberRenderer firstObject];
    
    if (renderer == nil) {
        
        renderer = [[GGNumberRenderer alloc] init];
    }
    else {
        
        [self.idleNumberRenderer removeObject:renderer];
    }
    
    return renderer;
}

#pragma mark - Shape

/**
 * 取图层视图大小与Chart一致
 */
- (GGShapeCanvas *)getGGShapeCanvasEqualFrame
{
    GGShapeCanvas * shape = [self makeOrGetShapeCanvas];
    shape.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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

#pragma mark - GGPieLayer

/**
 * 取图层视图大小与Chart一致
 */
- (GGPieLayer *)getPieLayerEqualFrame
{
    GGPieLayer * canvas = [self makeOrGetPieLayer];
    canvas.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSublayer:canvas];
    [self.visiblePieLayer addObject:canvas];
    return canvas;
}

/**
 * 扇形图
 */
- (GGPieLayer *)makeOrGetPieLayer
{
    GGPieLayer * shape = [self.idlePieLayer firstObject];
    
    if (shape == nil) {
        
        shape = [[GGPieLayer alloc] init];
    }
    else {
        
        [self.idlePieLayer removeObject:shape];
    }
    
    return shape;
}

#pragma mark - Canvas

/**
 * 取图层视图大小与Chart一致
 */
- (GGCanvas *)getCanvasEqualFrame
{
    GGCanvas * canvas = [self makeOrGetCanvas];
    canvas.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSublayer:canvas];
    [self.visibleCanvas addObject:canvas];
    return canvas;
}

/**
 * 渐变色
 */
- (GGCanvas *)makeOrGetCanvas
{
    GGCanvas * shape = [self.idleCanvas firstObject];
    
    if (shape == nil) {
        
        shape = [[GGCanvas alloc] init];
    }
    else {
        
        [self.idleCanvas removeObject:shape];
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
    
    for (GGShapeCanvas * obj in self.visibleLayers) {
        
        [obj removeFromSuperlayer];
    }
    
    [self.visibleLayers removeAllObjects];
    
    // 渐变色
    [self.idleGradientLayers addObjectsFromArray:self.visibleGradientLayers];
    
    for (CAGradientLayer * obj in self.visibleGradientLayers) {
        
        [obj removeFromSuperlayer];
    }
    
    [self.visibleGradientLayers removeAllObjects];
    
    // 普通图层
    [self.idleCanvas addObjectsFromArray:self.visibleCanvas];
    
    for (GGCanvas * obj in self.visibleCanvas) {
        
        [obj removeFromSuperlayer];
    }
    
    [self.visibleCanvas removeAllObjects];
    
    // PieLayer
    [self.idlePieLayer addObjectsFromArray:self.visiblePieLayer];
    
    for (GGCanvas * obj in self.visiblePieLayer) {
        
        [obj removeFromSuperlayer];
    }
    
    [self.visiblePieLayer removeAllObjects];
    
    // 渲染器
    [self.idleNumberRenderer addObjectsFromArray:self.visibleNumberRenderer];
    
    [self.visibleNumberRenderer removeAllObjects];
}

#pragma mark - 绘制

/**
 * 增加一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)addRenderer:(id <GGRenderProtocol>)renderer
{
    if (_isCashBeforeRenderers) {
        
        [self.aryCurrentRenderer addObject:renderer];
    }
    else {
    
        [self.aryRenderer addObject:renderer];
    }
}

/**
 * 删除一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)removeRenderer:(id <GGRenderProtocol>)renderer
{
    if (_isCashBeforeRenderers) {
        
        [self.aryCurrentRenderer addObject:renderer];
    }
    else {
    
        [self.aryRenderer removeObject:renderer];
    }
}

/**
 * 删除所有绘图工具
 */
- (void)removeAllRenderer
{
    [self.aryRenderer removeAllObjects];
    
    if (_isCashBeforeRenderers) {   // 开启上级缓存, 讲current中的渲染器同步到before中
        
        [self.aryBeforeRenderer removeAllObjects];
        [self.aryBeforeRenderer addObjectsFromArray:self.aryCurrentRenderer];
        [self.aryCurrentRenderer removeAllObjects];
    }
}

/**
 * 更新视图页面
 */
- (void)setNeedsDisplay
{
    if (_isCashBeforeRenderers) {   // 如果开启上级缓存, 则将befor, current 加入当前数组
        
        [self.aryRenderer addObjectsFromArray:self.aryBeforeRenderer];
        [self.aryRenderer addObjectsFromArray:self.aryCurrentRenderer];
    }
    
    [super setNeedsDisplay];
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

#pragma mark - Getter

/**
 * 获取Number渲染器
 */
- (NSArray<GGNumberRenderer *> *)visibleNumberRenderers
{
    return self.visibleNumberRenderer;
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, aryRenderer);
GGLazyGetMethod(NSMutableArray, aryBeforeRenderer);
GGLazyGetMethod(NSMutableArray, aryCurrentRenderer);

GGLazyGetMethod(NSMutableArray, visibleNumberRenderer);
GGLazyGetMethod(NSMutableArray, idleNumberRenderer);

GGLazyGetMethod(NSMutableArray, visibleLayers);
GGLazyGetMethod(NSMutableArray, idleLayers);

GGLazyGetMethod(NSMutableArray, visibleGradientLayers);
GGLazyGetMethod(NSMutableArray, idleGradientLayers);

GGLazyGetMethod(NSMutableArray, visibleCanvas);
GGLazyGetMethod(NSMutableArray, idleCanvas);

GGLazyGetMethod(NSMutableArray, visiblePieLayer);
GGLazyGetMethod(NSMutableArray, idlePieLayer);

@end
