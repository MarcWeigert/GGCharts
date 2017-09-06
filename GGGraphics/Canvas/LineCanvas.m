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
    GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
    shape.lineWidth = [lineDraw lineWidth];
    shape.strokeColor = [lineDraw lineColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, [lineDraw points], [lineDraw lineDataAry].count);
    shape.path = path;
    CGPathRelease(path);
    
    SET_ASSOCIATED_ASSIGN(lineDraw, lineLayer, shape);
}

/** 绘制圆点 */
- (void)drawShapeChartWithLineDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw shapeRadius] > 0) {
        
        GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
        shape.lineWidth = [lineDraw lineWidth];
        shape.strokeColor = [lineDraw lineColor].CGColor;
        shape.fillColor = [lineDraw shapeFillColor] == nil ? [UIColor whiteColor].CGColor : [lineDraw shapeFillColor].CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        GGPathAddCircles(path, [lineDraw points], [lineDraw shapeRadius], [lineDraw lineDataAry].count);
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
        
        for (NSInteger i = 0; i < [lineDraw lineDataAry].count; i++) {
            
            GGNumberRenderer * stringRenderer = [[GGNumberRenderer alloc] init];
            stringRenderer.color = [lineDraw stringColor];
            stringRenderer.fromPoint = CGPointMake([lineDraw points][i].x, [lineDraw bottomYPix]);
            stringRenderer.toPoint = [lineDraw points][i];
            stringRenderer.font = [lineDraw stringFont];
            stringRenderer.toNumber = [[lineDraw lineDataAry][i] floatValue];
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
        
        GGShapeCanvas * shape = [self getGGShapeCanvasEqualFrame];
        shape.lineWidth = 0;
        shape.fillColor = [lineDraw lineFillColor].CGColor;
        
        CGPoint lineFirstPoint = [lineDraw points][0];
        CGPoint lineLastPoint = [lineDraw points][lineDraw.lineDataAry.count - 1];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddLines(path, NULL, [lineDraw points], lineDraw.lineDataAry.count);
        CGPathAddLineToPoint(path, NULL, lineLastPoint.x, [lineDraw bottomYPix]);
        CGPathAddLineToPoint(path, NULL, lineFirstPoint.x, [lineDraw bottomYPix]);
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
//    [[self.lineDrawConfig lineAry] enumerateObjectsUsingBlock:^(id <LineDrawAbstract> obj, NSUInteger idx, BOOL * stop) {
//        
//        [LineAnimation addLineCircleAnimationWithDuration:duration
//                                           lineShapeLater:GET_ASSOCIATED(obj, lineShapeLayer)
//                                               lineScaler:obj.lineScaler
//                                               fromRadius:0
//                                                 toRadius:obj.shapeRadius];
//        
//        [LineAnimation addLineFoldAnimationWithDuration:duration
//                                         lineShapeLater:GET_ASSOCIATED(obj, lineLayer)
//                                             lineScaler:obj.lineScaler];
//        
//        [LineAnimation addLineRectFoldAnimationWithDuration:duration
//                                             lineShapeLater:GET_ASSOCIATED(obj, lineFillLayer)
//                                                 lineScaler:obj.lineScaler];
//    }];
//    
//    __weak LineCanvas * weakSelf = self;
//    _animator.animationType = AnimationLinear;
//    
//    [_animator startAnimationWithDuration:duration animationArray:_allGGNumberArray updateBlock:^(CGFloat progress) {
//        
//        [weakSelf.stringCanvas setNeedsDisplay];
//    }];
}

@end
