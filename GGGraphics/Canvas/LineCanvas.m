//
//  LineCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineCanvas.h"
#import "DLineScaler.h"
#import "LineAnimation.h"
#include <objc/runtime.h>

static const void * lineLayer = @"lineLayer";
static const void * lineShapeLayer = @"lineShapeLayer";
static const void * lineFillLayer = @"lineFillLayer";

#define SET_ASSOCIATED_ASSIGN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_ASSIGN)
#define SET_ASSOCIATED_RETAIN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN)
#define GET_ASSOCIATED(obj, key) objc_getAssociatedObject(obj, key)

@interface LineCanvas ()

@property (nonatomic, strong) GGCanvas * stringCanvas;

@property (nonatomic, strong) Animator * animator;

@property (nonatomic, strong) NSMutableArray <GGNumberRenderer *> * allGGNumberArray;

@end

@implementation LineCanvas

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _stringCanvas = [[GGCanvas alloc] init];
        _stringCanvas.isCloseDisableActions = YES;
        _animator = [Animator new];
        _allGGNumberArray = [NSMutableArray array];
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
    [_allGGNumberArray removeAllObjects];
    
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

/** 绘制圆点 */
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
    if ([lineDraw stringFont] != nil &&
        [lineDraw stringColor] != nil &&
        [lineDraw dataFormatter] != nil) {
        
        NSString * dataFromatter = [lineDraw dataFormatter] == nil ? @"%.2f" : [lineDraw dataFormatter];
        DLineScaler * lineScaler = lineDraw.lineScaler;
        lineScaler.aroundNumber = [lineDraw fillRoundPrice];
        
        for (NSInteger i = 0; i < lineScaler.dataAry.count; i++) {
            
            GGNumberRenderer * stringRenderer = [[GGNumberRenderer alloc] init];
            stringRenderer.color = [lineDraw stringColor];
            stringRenderer.fromPoint = CGPointMake(lineScaler.linePoints[i].x, lineScaler.aroundY);
            stringRenderer.toPoint = lineScaler.linePoints[i];
            stringRenderer.font = [lineDraw stringFont];
            stringRenderer.toNumber = [lineScaler.dataAry[i] floatValue];
            stringRenderer.offSetRatio = CGPointMake(-.5f, -1.2f);
            stringRenderer.format = dataFromatter;
            [stringRenderer drawAtToNumberAndPoint];
            
            [_stringCanvas addRenderer:stringRenderer];
            [_allGGNumberArray addObject:stringRenderer];
        }
    }
}

/** 填充色 */
- (void)drawFillChartWithDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw lineFillColor] || [lineDraw gradientColors].count > 0) {
        
        DLineScaler * lineScaler = lineDraw.lineScaler;
        lineScaler.aroundNumber = [lineDraw fillRoundPrice];
        
        GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
        shape.lineWidth = 0;
        shape.fillColor = [lineDraw lineFillColor].CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddLines(path, NULL, lineScaler.linePoints, lineScaler.pointSize);
        CGPathAddLineToPoint(path, NULL, lineScaler.linePoints[lineScaler.pointSize - 1].x, lineScaler.aroundY);
        CGPathAddLineToPoint(path, NULL, lineScaler.linePoints[0].x, lineScaler.aroundY);
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
        
        [LineAnimation addLineCircleAnimationWithDuration:duration
                                           lineShapeLater:GET_ASSOCIATED(obj, lineShapeLayer)
                                               lineScaler:obj.lineScaler
                                               fromRadius:0
                                                 toRadius:obj.shapeRadius];
        
        [LineAnimation addLineFoldAnimationWithDuration:duration
                                         lineShapeLater:GET_ASSOCIATED(obj, lineLayer)
                                             lineScaler:obj.lineScaler];
        
        [LineAnimation addLineRectFoldAnimationWithDuration:duration
                                             lineShapeLater:GET_ASSOCIATED(obj, lineFillLayer)
                                                 lineScaler:obj.lineScaler];
    }];
    
    __weak LineCanvas * weakSelf = self;
    _animator.animationType = AnimationLinear;
    
    [_animator startAnimationWithDuration:duration animationArray:_allGGNumberArray updateBlock:^(CGFloat progress) {
        
        [weakSelf.stringCanvas setNeedsDisplay];
    }];
}

@end
