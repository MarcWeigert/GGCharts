//
//  RadarCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarCanvas.h"
#import "GGGraphics.h"
#import "DRadarScaler.h"
#include <objc/runtime.h>

static const void * radarLayer = @"radarLayer";

@interface RadarCanvas ()

@property (nonatomic, strong) GGPolygonRenderder * polyRenderer;

@property (nonatomic, strong) NSMutableArray * arrayNumberRenderer;

@property (nonatomic, strong) Animator * animator;

@end

@implementation RadarCanvas

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _polyRenderer = [[GGPolygonRenderder alloc] init];
        [self addRenderer:_polyRenderer];
        
        _topCanvas = [[GGCanvas alloc] init];
        [self addSublayer:_topCanvas];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _topCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

- (void)setRadarDrawConfig:(id <RadarSetAbstract>)radarDrawConfig
{
    _radarDrawConfig = radarDrawConfig;
    
    _polyRenderer.width = radarDrawConfig.lineWidth;
    _polyRenderer.strockColor = radarDrawConfig.strockColor;
    _polyRenderer.splitCount = radarDrawConfig.splitCount;
    _polyRenderer.stringColor = radarDrawConfig.stringColor;
    _polyRenderer.stringFont = radarDrawConfig.titleFont;
    _polyRenderer.titles = radarDrawConfig.titles;
    _polyRenderer.isPiece = YES;
    _polyRenderer.titleSpacing = [radarDrawConfig titleSpacing];
    _polyRenderer.isCircle = [radarDrawConfig isCirlre];
    _polyRenderer.borderWidth = [radarDrawConfig borderWidth];
}

/** 更新视图 */
- (void)drawChart
{
    [super drawChart];
    
    _polyRenderer.polygon = GGPolygonMake(_radarDrawConfig.radius, self.gg_width / 2, self.gg_height / 2, _radarDrawConfig.side, 0);
    [self updateSubLayers];
    [self setNeedsDisplay];
}

/** 更新子视图 */
- (void)updateSubLayers
{
    for (NSInteger i = 0; i < _radarDrawConfig.radarSet.count; i++) {
        
        id <RadarAbstract> drawData = _radarDrawConfig.radarSet[i];
        
        [self drawRadarLineLayer:drawData];
        [self drawRadarFillLayer:drawData];
        [self drawRadarShapeLayer:drawData];
    }
    
    [self addSublayer:_topCanvas];
}

/**
 * 绘制雷达小圆点
 */
- (void)drawRadarShapeLayer:(id <RadarAbstract>)drawData
{
    if ([drawData shapeRadius] > 0) {
        
        GGShapeCanvas * shapeCanvas = [self getGGShapeCanvasEqualFrame];
        shapeCanvas.strokeColor = [drawData strockColor].CGColor;
        shapeCanvas.lineWidth = [drawData shapeLineWidth];
        shapeCanvas.fillColor = [drawData shapeFillColor].CGColor;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        
        for (NSInteger i = 0; i < [drawData datas].count; i++) {
            
            GGPathAddCircle(ref, GGCirclePointMake([drawData points][i], [drawData shapeRadius]));
        }
        
        shapeCanvas.path = ref;
        CGPathRelease(ref);
    }
}

/**
 * 绘制雷达分割线
 */
- (void)drawRadarLineLayer:(id <RadarAbstract>)drawData
{
    if ([drawData lineWidth] > 0) {
        
        GGShapeCanvas * shapeCanvas = [self getGGShapeCanvasEqualFrame];
        shapeCanvas.strokeColor = [drawData strockColor].CGColor;
        shapeCanvas.lineWidth = [drawData lineWidth];
        shapeCanvas.fillColor = [UIColor clearColor].CGColor;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddPoints(ref, [drawData points], [drawData datas].count);
        CGPathCloseSubpath(ref);
        shapeCanvas.path = ref;
        CGPathRelease(ref);
    }
}

/**
 * 绘制填充色
 */
- (void)drawRadarFillLayer:(id <RadarAbstract>)drawData
{
    if ([drawData fillColor] || [drawData gradientColors].count > 0) {
        
        GGCanvas * baseCanvas = [self getCanvasEqualFrame];
        GGShapeCanvas * shapeCanvas = [baseCanvas getGGShapeCanvasEqualFrame];;
        shapeCanvas.lineWidth = 0;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddPoints(ref, [drawData points], [drawData datas].count);
        CGPathCloseSubpath(ref);
        shapeCanvas.path = ref;
        CGPathRelease(ref);
        
        [shapeCanvas removeFromSuperlayer];
        CAGradientLayer * gradientLayer = [baseCanvas getCAGradientEqualFrame];
        gradientLayer.mask = shapeCanvas;
        
        if ([drawData gradientColors].count > 0) {
            
            CGFloat startRatio = _polyRenderer.polygon.center.y - _polyRenderer.polygon.radius;
            CGFloat endRatio = _polyRenderer.polygon.center.y + _polyRenderer.polygon.radius;
            
            gradientLayer.colors = [drawData gradientColors];
            gradientLayer.startPoint = CGPointMake(.5f, startRatio / self.gg_height);
            gradientLayer.endPoint = CGPointMake(.5f, endRatio / self.gg_height);
        }
        else {
        
            gradientLayer.backgroundColor = [drawData fillColor].CGColor;
        }
        
        SET_ASSOCIATED_ASSIGN(drawData, radarLayer, shapeCanvas);
    }
}

/** 动画 */
- (void)addAnimationWithDuration:(NSTimeInterval)duration
{
    for (NSInteger i = 0; i < _radarDrawConfig.radarSet.count; i++) {
        
        id <RadarAbstract> drawData = _radarDrawConfig.radarSet[i];
        
        GGShapeCanvas * shapeCanvas = GET_ASSOCIATED(drawData, radarLayer);
        CAKeyframeAnimation * scaleAtnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAtnimation.duration = duration;
        scaleAtnimation.values = @[@0 , @1];
        [shapeCanvas addAnimation:scaleAtnimation forKey:@"scaleAtnimation"];
    }
    
    __weak RadarCanvas * weakSelf = self;
    self.animator.animationType = AnimationLinear;
    
    [_animator startAnimationWithDuration:duration animationArray:self.arrayNumberRenderer updateBlock:^(CGFloat progress) {
        
        [weakSelf.topCanvas setNeedsDisplay];
    }];
}

/** 增加渲染器 */
- (void)addGGNumberRenderer:(GGNumberRenderer *)renderer
{
    [self.arrayNumberRenderer addObject:renderer];
}

/** 清除渲染器 */
- (void)removeAllGGNumberRenderer
{
    [self.arrayNumberRenderer removeAllObjects];
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, arrayNumberRenderer);

GGLazyGetMethod(Animator, animator);

@end
