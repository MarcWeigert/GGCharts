//
//  LineCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineCanvas.h"
#import "DLineScaler.h"
#include <objc/runtime.h>
#import "LineAnimationsManager.h"

@interface LineCanvas ()

/**
 * 折线动画类
 */
@property (nonatomic, strong) LineAnimationsManager * lineAnimations;

/**
 * 是否经过第一次渲染
 */
@property (nonatomic, assign) BOOL hadRenderer;

@end

@implementation LineCanvas

- (void)dealloc
{
    for (id <LineDrawAbstract> lineDraw in [_lineDrawConfig lineAry]) {
        
        objc_removeAssociatedObjects(lineDraw);
    }
}

- (void)drawChart
{
    [super drawChart];
    
    // 清空动画管理类
    [self.lineAnimations resetAnimationManager];
    
    for (NSInteger i = 0; i < _lineDrawConfig.lineAry.count; i++) {
        
        id <LineDrawAbstract> lineDraw = _lineDrawConfig.lineAry[i];
        
        [self drawFillLayerWithLine:lineDraw];
        [self drawLineLayertWithLine:lineDraw];
        [self drawShapeLayerWithLine:lineDraw];
        [self drawStringLayerWithLine:lineDraw];
        
        [self.lineAnimations registerLineDrawAbstract:lineDraw];
    }
    
    self.lineAnimations.baseLineLayer = self;
    
    // 启动动画
    if ([_lineDrawConfig updateNeedAnimation]) {
        
        if (self.hadRenderer) {
            
            [self.lineAnimations startAnimationWithDuration:.25f animationType:LineAnimationChangeType];
        }
    }
    
    self.hadRenderer = YES;
}

/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(LineAnimationsType)type duration:(NSTimeInterval)duration
{
    [self.lineAnimations startAnimationWithDuration:duration animationType:type];
}

/** 绘制线 */
- (void)drawLineLayertWithLine:(id <LineDrawAbstract>)lineAbstract
{
    GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
    shape.lineWidth = [lineAbstract lineWidth];
    shape.strokeColor = [lineAbstract lineColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.lineDashPattern = [lineAbstract dashPattern];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, [lineAbstract points], [lineAbstract dataAry].count);
    shape.path = path;
    CGPathRelease(path);
    
    SET_ASSOCIATED_ASSIGN(lineAbstract, lineLayer, shape);
}

/** 绘制圆点 */
- (void)drawShapeLayerWithLine:(id <LineDrawAbstract>)lineAbstract
{
    if ([lineAbstract shapeRadius] > 0) {
        
        GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
        shape.lineWidth = [lineAbstract shapeLineWidth];
        shape.strokeColor = [lineAbstract lineColor].CGColor;
        shape.fillColor = [lineAbstract shapeFillColor] == nil ? [UIColor whiteColor].CGColor : [lineAbstract shapeFillColor].CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        if ([lineAbstract showShapeIndexSet].count > 0) {
            
            for (NSNumber * number in [lineAbstract showShapeIndexSet]) {
                
                GGPathAddCircle(path, GGCirclePointMake([lineAbstract points][number.integerValue], [lineAbstract shapeRadius]));
            }
        }
        else {
        
            GGPathAddCircles(path, [lineAbstract points], [lineAbstract shapeRadius], [lineAbstract dataAry].count);
        }
        
        shape.path = path;
        CGPathRelease(path);
        
        SET_ASSOCIATED_ASSIGN(lineAbstract, lineShapeLayer, shape);
    }
}

/** 绘制文字 */
- (void)drawStringLayerWithLine:(id <LineDrawAbstract>)lineAbstract
{
    if ([lineAbstract stringFont] != nil &&
        [lineAbstract stringColor] != nil &&
        [lineAbstract dataFormatter] != nil) {
        
        NSString * dataFromatter = [lineAbstract dataFormatter] == nil ? @"%.2f" : [lineAbstract dataFormatter];
        
        GGCanvas * canvas = [self getCanvasEqualFrame];
        canvas.isCloseDisableActions = YES;
        [canvas removeAllRenderer];
        
        NSMutableArray * arrayNumber = [NSMutableArray array];
        
        for (NSInteger i = 0; i < [lineAbstract dataAry].count; i++) {
            
            GGNumberRenderer * stringRenderer = [self getNumberRenderer];
            stringRenderer.color = [lineAbstract stringColor];
            stringRenderer.toPoint = [lineAbstract points][i];
            stringRenderer.font = [lineAbstract stringFont];
            stringRenderer.toNumber = [[lineAbstract dataAry][i] floatValue];
            stringRenderer.offSetRatio = [lineAbstract offSetRatio];
            stringRenderer.offSet = [lineAbstract stringOffset];
            stringRenderer.format = dataFromatter;
            [stringRenderer drawAtToNumberAndPoint];
            
            [canvas addRenderer:stringRenderer];
            [arrayNumber addObject:stringRenderer];
        }
        
        [canvas setNeedsDisplay];
        
        SET_ASSOCIATED_RETAIN(lineAbstract, lineNumberArray, arrayNumber);
        SET_ASSOCIATED_ASSIGN(lineAbstract, lineStringLayer, canvas);
    }
}

/** 填充色 */
- (void)drawFillLayerWithLine:(id <LineDrawAbstract>)lineAbstract
{
    if ([lineAbstract lineFillColor] || [lineAbstract gradientFillColors].count > 0) {
        
        GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
        shape.lineWidth = 0;
        shape.fillColor = [lineAbstract lineFillColor].CGColor;
        
        CGPoint lineFirstPoint = [lineAbstract points][0];
        CGPoint lineLastPoint = [lineAbstract points][lineAbstract.dataAry.count - 1];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddLines(path, NULL, [lineAbstract points], lineAbstract.dataAry.count);
        CGPathAddLineToPoint(path, NULL, lineLastPoint.x, [lineAbstract bottomYPix]);
        CGPathAddLineToPoint(path, NULL, lineFirstPoint.x, [lineAbstract bottomYPix]);
        CGPathCloseSubpath(path);
        shape.path = path;
        CGPathRelease(path);
        
        SET_ASSOCIATED_ASSIGN(lineAbstract, lineFillLayer, shape);
        
        if ([lineAbstract gradientFillColors].count > 0) {
            
            [shape removeFromSuperlayer];
            
            CAGradientLayer * gradientLayer = [self getCAGradientEqualFrame];
            gradientLayer.mask = shape;
            gradientLayer.colors = [lineAbstract gradientFillColors];
            gradientLayer.locations = [lineAbstract locations];
        }
    }
}

/**
 * 查价线响应
 *
 * @param touchPoint 触碰的点
 * @return 返回横坐标
 */
- (CGFloat)queryPoint:(CGPoint)touchPoint
{
    return 0;
}

#pragma mark - Lazy

GGLazyGetMethod(LineAnimationsManager, lineAnimations);

@end
