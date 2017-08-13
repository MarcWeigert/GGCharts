//
//  LineCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineCanvas.h"
#import "DLineScaler.h"
#include <objc/runtime.h>

static const void * lineLayer = @"lineLayer";
static const void * lineShapeLayer = @"lineShapeLayer";
static const void * lineStringRenderer = @"lineStringRenderer";
static const void * lineFillLayer = @"lineFillLayer";

#define SET_ASSOCIATED_ASSIGN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_ASSIGN)
#define SET_ASSOCIATED_RETAIN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN)
#define GET_ASSOCIATED(obj, key) objc_getAssociatedObject(obj, key)

@interface LineCanvas ()

@property (nonatomic, strong) GGCanvas * stringCanvas;

@property (nonatomic, strong) Animator * animator;

@end

@implementation LineCanvas

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _stringCanvas = [[GGCanvas alloc] init];
        _stringCanvas.isCloseDisableActions = YES;
        _animator = [Animator new];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _stringCanvas.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)drawChart
{
    [super drawChart];
    
    [_stringCanvas removeAllRenderer];
    
    CGRect rect = CGRectMake(0, 0, self.gg_width, self.gg_height);
    rect = UIEdgeInsetsInsetRect(rect, [_lineDrawConfig lineInsets]);
    
    for (NSInteger i = 0; i < _lineDrawConfig.lineAry.count; i++) {
        
        id <LineDrawAbstract> lineDraw = _lineDrawConfig.lineAry[i];
        
        DLineScaler * lineScaler = [lineDraw lineScaler];
        lineScaler.rect = rect;
        lineScaler.xRatio = 0;
        
        if ([_lineDrawConfig isGroupingAlignment]) {
            
            lineScaler.xRatio = (float)(i + 1) / ([[_lineDrawConfig lineAry] count] + 1);
        }
        else if ([_lineDrawConfig isCenterAlignment]) {
        
            lineScaler.xRatio = .5f;
        }
        
        [lineScaler updateScaler];
        
        [self drawFillChartWithDraw:lineDraw];
        [self drawLineChartWithLineDraw:lineDraw];
        [self drawShapeChartWithLineDraw:lineDraw];
        [self drawStringChartWithDraw:lineDraw];
    }
    
    [self bringSublayerToFront:_stringCanvas];
    [_stringCanvas setNeedsDisplay];
}

/** 绘制线 */
- (void)drawLineChartWithLineDraw:(id <LineDrawAbstract>)lineDraw
{
    DLineScaler * lineScaler = lineDraw.lineScaler;
    
    GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
    shape.lineWidth = [lineDraw lineWidth];
    shape.strokeColor = [lineDraw lineColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, lineScaler.linePoints, lineScaler.pointSize);
    shape.path = path;
    CGPathRelease(path);
    
    SET_ASSOCIATED_ASSIGN(lineDraw, lineLayer, shape);
}

/** 绘制远点 */
- (void)drawShapeChartWithLineDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw shapeRadius] > 0) {
        
        DLineScaler * lineScaler = lineDraw.lineScaler;
        
        GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
        shape.lineWidth = [lineDraw lineWidth];
        shape.strokeColor = [lineDraw lineColor].CGColor;
        shape.fillColor = [lineDraw shapeFillColor] == nil ? [UIColor whiteColor].CGColor : [lineDraw shapeFillColor].CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        GGPathAddCircles(path, lineScaler.linePoints, [lineDraw shapeRadius], lineScaler.pointSize);
        shape.path = path;
        CGPathRelease(path);
        
        SET_ASSOCIATED_ASSIGN(lineDraw, lineShapeLayer, shape);
    }
}

/** 绘制文字 */
- (void)drawStringChartWithDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw stringFont] != nil) {
        
        NSMutableArray * arrayRenderer = [NSMutableArray array];
        NSString * dataFromatter = [lineDraw dataFormatter] == nil ? @"%.2f" : [lineDraw dataFormatter];
        DLineScaler * lineScaler = lineDraw.lineScaler;
        
        for (NSInteger i = 0; i < lineScaler.dataAry.count; i++) {
            
            GGNumberRenderer * stringRenderer = [[GGNumberRenderer alloc] init];
            stringRenderer.color = [lineDraw stringColor];
            stringRenderer.toPoint = lineScaler.linePoints[i];
            stringRenderer.font = [lineDraw stringFont];
            stringRenderer.toNumber = [lineScaler.dataAry[i] floatValue];
            stringRenderer.offSetRatio = CGPointMake(-.5f, -1.2f);
            stringRenderer.format = dataFromatter;
            [stringRenderer drawAtToNumberAndPoint];
            [_stringCanvas addRenderer:stringRenderer];
            [arrayRenderer addObject:stringRenderer];
        }
        
        SET_ASSOCIATED_RETAIN(lineDraw, lineStringRenderer, arrayRenderer);
    }
}

/** 填充色 */
- (void)drawFillChartWithDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw lineFillColor] || [lineDraw gradientColors].count > 0) {
        
        DLineScaler * lineScaler = lineDraw.lineScaler;
        
        GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
        shape.lineWidth = 0;
        shape.fillColor = [lineDraw lineFillColor].CGColor;
        
        CGFloat bottomY = [lineDraw fillRoundPrice] == nil ? CGRectGetMaxY(lineScaler.rect) : [lineScaler getYPixelWithData:[lineDraw fillRoundPrice].floatValue];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddLines(path, NULL, lineScaler.linePoints, lineScaler.pointSize);
        CGPathAddLineToPoint(path, NULL, lineScaler.linePoints[lineScaler.pointSize - 1].x, bottomY);
        CGPathAddLineToPoint(path, NULL, lineScaler.linePoints[0].x, bottomY);
        CGPathCloseSubpath(path);
        shape.path = path;
        CGPathRelease(path);
        
        SET_ASSOCIATED_ASSIGN(lineDraw, lineFillLayer, shape);
        
        if ([lineDraw gradientColors].count > 0) {
            
            CAGradientLayer * gradientLayer = [self getCAGradientEqualFrame];
            gradientLayer.mask = shape;
            gradientLayer.colors = [lineDraw gradientColors];
            gradientLayer.locations = [lineDraw locations];
        }
    }
}

- (void)startAnimation:(NSTimeInterval)duration
{
    [[self.lineDrawConfig lineAry] enumerateObjectsUsingBlock:^(id <LineDrawAbstract> obj, NSUInteger idx, BOOL * stop) {
        
        GGShapeCanvas * lineCanvas = GET_ASSOCIATED(obj, lineLayer);
        GGShapeCanvas * shapeCanvas = GET_ASSOCIATED(obj, lineShapeLayer);
        GGShapeCanvas * fillCanvas = GET_ASSOCIATED(obj, lineFillLayer);
        
        DLineScaler * scaler = [obj lineScaler];
        CGFloat y = [obj fillRoundPrice] == nil ? [obj.lineScaler getYPixelWithData:obj.lineScaler.min] : [obj.lineScaler getYPixelWithData:[[obj fillRoundPrice] floatValue]];
        
        CAKeyframeAnimation * lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        lineAnimation.duration = duration;
        lineAnimation.values = GGPathLinesUpspringAnimation(obj.lineScaler.linePoints, obj.lineScaler.pointSize, y);
        [lineCanvas addAnimation:lineAnimation forKey:@"lineAnimation"];
        
        CAKeyframeAnimation * pointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pointAnimation.duration = duration;
        pointAnimation.values = GGPathCirclesUpspringAnimation(obj.lineScaler.linePoints, [obj shapeRadius], obj.lineScaler.pointSize, y);
        [shapeCanvas addAnimation:pointAnimation forKey:@"pointAnimation"];
        
        CAKeyframeAnimation * fillAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        fillAnimation.duration = duration;
        fillAnimation.values = GGPathFillLinesUpspringAnimation(obj.lineScaler.linePoints, obj.lineScaler.pointSize, y);
        [fillCanvas addAnimation:fillAnimation forKey:@"fillAnimation"];
        
        NSArray <GGNumberRenderer *> * numberRenders = GET_ASSOCIATED(obj, lineStringRenderer);
        
        [numberRenders enumerateObjectsUsingBlock:^(GGNumberRenderer * objRenderer, NSUInteger idx, BOOL * stop) {
            
            objRenderer.fromNumber = 0;
            objRenderer.fromPoint = CGPointMake(scaler.linePoints[idx].x , y);
        }];
    }];
    
    __weak LineCanvas * weakSelf = self;
    _animator.animationType = AnimationLinear;
    
    _animator.updateBlock = ^(CGFloat progress) {
    
        for (NSInteger i = 0; i < weakSelf.lineDrawConfig.lineAry.count; i++) {
            
            id <LineDrawAbstract> obj = weakSelf.lineDrawConfig.lineAry[i];
            NSArray <GGNumberRenderer *> * numberRenders = GET_ASSOCIATED(obj, lineStringRenderer);
            
            for (NSInteger j = 0; j < numberRenders.count; j++) {
                
                GGNumberRenderer * objRenderer = [numberRenders objectAtIndex:j];
                [objRenderer drawProgressNumberAndPoint:progress];
            }
        }
        
        [weakSelf.stringCanvas setNeedsDisplay];
    };
    
    [_animator startAnimationWithDuration:duration];
}

@end
