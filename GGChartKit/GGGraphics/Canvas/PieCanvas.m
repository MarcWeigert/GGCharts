//
//  PieCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieCanvas.h"
#import <objc/runtime.h>
#import "NSArray+Stock.h"
#import "PieAnimationManager.h"

@interface PieCanvas ()

/**
 * 动画管理类
 */
@property (nonatomic, strong) PieAnimationManager * pieAnimation;

/**
 * 是否经过第一次渲染
 */
@property (nonatomic, assign) BOOL hadRenderer;

@end

@implementation PieCanvas

/**
 * 父类方法
 */
- (void)drawChart
{
    [super drawChart];
    
    for (id <PieDrawAbstract> pieAbstract in [_pieCanvasConfig pieAry]) {
        
        [self drawSpiderLineWithPie:pieAbstract];
        [self drawPieChartWithPie:pieAbstract];
        [self drawInnerStringWithPie:pieAbstract];
    }
    
    [self drawBorderLayer];
    
    [self.pieAnimation setPieCanvasAbstract:_pieCanvasConfig];
    
    if (!self.hadRenderer) {
        
        [self.pieAnimation startAnimationWithDuration:.5 animationType:EjectAnimation];
    }
    else {
        
        [self.pieAnimation startAnimationWithDuration:.5 animationType:ChangeAnimation];
    }
    
    self.hadRenderer = YES;
}

/**
 * 绘制扇形图
 */
- (void)drawPieChartWithPie:(id <PieDrawAbstract>)pieAbstract
{
    NSMutableArray * pieAry = [NSMutableArray array];
    GGCanvas * baseCanvas = [self getCanvasEqualFrame];
    [baseCanvas drawChart];
    
    for (NSInteger i = 0; i < [pieAbstract dataAry].count; i++) {
        
        GGPie pie = [pieAbstract pies][i];
        
        UIColor * pieColor = [UIColor blackColor];
        
        if ([pieAbstract pieColorsForIndex]) {
            
            pieColor = [pieAbstract pieColorsForIndex](i, [pieAbstract ratios][i]);
        }
        else if (![pieAbstract gradientColorsForIndex]) {
        
            GGLog(@"请实现扇形图Block: UIColor * (^pieColorsForIndex)(NSInteger index, CGFloat ratio) 或 NSArray <UIColor *> * (^gradientColorsForIndex)(NSInteger index)");
        }
        
        GGShapeCanvas * shapeLayer = [baseCanvas getGGShapeCanvasEqualFrame];
        shapeLayer.fillColor = pieColor.CGColor;
        shapeLayer.lineWidth = 0;
        [shapeLayer drawPie:pie];
        [pieAry addObject:shapeLayer];

        // 设置渐变色
        if ([pieAbstract gradientColorsForIndex]) {
         
            NSArray * colors = [pieAbstract gradientColorsForIndex](i);
            
            CAGradientLayer * gradientLayer = [baseCanvas getCAGradientEqualFrame];
            gradientLayer.colors = [colors getCGColorsArray];
            gradientLayer.startPoint = [pieAbstract gradientColorLine].start;
            gradientLayer.endPoint = [pieAbstract gradientColorLine].end;
            gradientLayer.locations = [pieAbstract gradientLocations];
            gradientLayer.mask = shapeLayer;
        }
    }
    
    SET_ASSOCIATED_RETAIN(pieAbstract, pieShapeLayerArray, pieAry);
    SET_ASSOCIATED_ASSIGN(pieAbstract, pieBaseShapeLayer, baseCanvas);
}

/**
 * 绘制边框外部
 */
- (void)drawSpiderLineWithPie:(id <PieDrawAbstract>)pieAbstract
{
    if ([pieAbstract showOutLableType] == OutSideShow) {
        
        GGCanvas * baseCanvas = [self getCanvasEqualFrame];
        [baseCanvas drawChart];
        [baseCanvas removeAllRenderer];
        
        NSMutableArray * aryLineLayers = [NSMutableArray array];
        NSMutableArray * aryNumbers = [NSMutableArray array];
        
        for (NSInteger i = 0; i < [pieAbstract dataAry].count; i++) {
            
            UIColor * lineColor = [UIColor blackColor];
            
            if ([[pieAbstract outSideLable] lineColorsBlock]) {
                
                lineColor = [[pieAbstract outSideLable] lineColorsBlock](i, [pieAbstract ratios][i]);
            }
            else {
            
                GGLog(@"请实现扇形图外线Block: UIColor * (^lineColorsBlock)(NSInteger index, CGFloat ratio)");
            }
            
            // 绘制折线
            GGShapeCanvas * shapeLayer = [baseCanvas getGGShapeCanvasEqualFrame];
            shapeLayer.lineWidth = [[pieAbstract outSideLable] lineWidth];
            shapeLayer.strokeColor = lineColor.CGColor;
            shapeLayer.fillColor = lineColor.CGColor;
            
            GGPie pie = [pieAbstract pies][i];
            CGFloat pieLineSpacing = [[pieAbstract outSideLable] lineSpacing];
            CGFloat pieLineLength = [[pieAbstract outSideLable] lineLength];
            CGFloat pieInflectionLength = [[pieAbstract outSideLable] inflectionLength];
            CGFloat maxLineLength = [pieAbstract radiusRange].outRadius + pieLineSpacing + pieLineLength;
            
            CGMutablePathRef ref = CGPathCreateMutable();
            CGPoint end_pt = GGPathAddPieLine(ref, pie, maxLineLength, pieInflectionLength, [[pieAbstract outSideLable] linePointRadius], pieLineSpacing);
            shapeLayer.path = ref;
            CGPathRelease(ref);
            
            CGFloat base = GGPieLineYCircular(pie) > 0 ? 1 : -1;
            CGPoint offsetRadio = CGPointMake([[pieAbstract outSideLable] stringRatio].x * base, [[pieAbstract outSideLable] stringRatio].y);
            CGSize size = CGSizeMake([[pieAbstract outSideLable] stringOffSet].width * base, [[pieAbstract outSideLable] stringOffSet].height);
            
            [aryLineLayers addObject:shapeLayer];
            
            // 折线文字
            GGNumberRenderer * numberRenderer = [[GGNumberRenderer alloc] init];
            numberRenderer.offSetRatio = offsetRadio;
            numberRenderer.toPoint = end_pt;
            numberRenderer.toNumber = [[pieAbstract dataAry][i] floatValue];
            numberRenderer.format = [[pieAbstract outSideLable] stringFormat];
            numberRenderer.color = [[pieAbstract outSideLable] lableColor];
            numberRenderer.font = [[pieAbstract outSideLable] lableFont];
            numberRenderer.offSet = size;
            numberRenderer.sum = [pieAbstract sum];
            [numberRenderer drawAtToNumberAndPoint];
            [baseCanvas addRenderer:numberRenderer];
            
            // 富文本字符
            if ([[pieAbstract outSideLable] attributeStringBlock]) {
                
                [numberRenderer setAttrbuteStringValueAndRatioBlock:^NSAttributedString *(CGFloat value, CGFloat ratio) {
                    
                    return [[pieAbstract outSideLable] attributeStringBlock](i, value, ratio);
                }];
            }
            
            [aryNumbers addObject:numberRenderer];
        }
        
        [baseCanvas setNeedsDisplay];
        
        SET_ASSOCIATED_RETAIN(pieAbstract, pieOutSideLayerArray, aryLineLayers);
        SET_ASSOCIATED_RETAIN(pieAbstract, pieOutSideNumberArray, aryNumbers);
        SET_ASSOCIATED_RETAIN(pieAbstract, pieOutSideLayer, baseCanvas);
    }
}

/**
 * 绘制内部
 */
- (void)drawInnerStringWithPie:(id <PieDrawAbstract>)pieAbstract
{
    if ([pieAbstract showInnerString]) {
        
        GGCanvas * canvas = [self getCanvasEqualFrame];
        [canvas drawChart];
        [canvas removeAllRenderer];
        
        NSMutableArray * aryNumbers = [NSMutableArray array];
        
        for (NSInteger i = 0; i < [pieAbstract dataAry].count; i++) {
        
            GGPie pie = [pieAbstract pies][i];
            
            GGArcLine arcLine = GGArcLineMake(pie.center, pie.transform + pie.arc / 2, pie.radiusRange.outRadius * .5 + pie.radiusRange.inRadius * .5);
            GGLine line = GGLineWithArcLine(arcLine, false);
            
            CGFloat line_arc = GGYCircular(line);
            CGFloat base = line_arc > 0 ? 1 : -1;
            CGPoint offsetRadio = CGPointMake([[pieAbstract innerLable] stringRatio].x * base, [[pieAbstract innerLable] stringRatio].y);
            CGSize size = CGSizeMake([[pieAbstract innerLable] stringOffSet].width * base, [[pieAbstract outSideLable] stringOffSet].height);
            
            // 折线文字
            GGNumberRenderer * numberRenderer = [[GGNumberRenderer alloc] init];
            numberRenderer.offSetRatio = offsetRadio;
            numberRenderer.toPoint = line.end;
            numberRenderer.toNumber = [[pieAbstract dataAry][i] floatValue];
            numberRenderer.format = [[pieAbstract innerLable] stringFormat];
            numberRenderer.color = [[pieAbstract innerLable] lableColor];
            numberRenderer.font = [[pieAbstract innerLable] lableFont];
            numberRenderer.offSet = size;
            numberRenderer.sum = [pieAbstract sum];
            [numberRenderer drawAtToNumberAndPoint];
            [canvas addRenderer:numberRenderer];
            [aryNumbers addObject:numberRenderer];
            
            // 富文本字符
            if ([[pieAbstract innerLable] attributeStringBlock]) {
                
                [numberRenderer setAttrbuteStringValueAndRatioBlock:^NSAttributedString *(CGFloat value, CGFloat ratio) {
                    
                    return [[pieAbstract innerLable] attributeStringBlock](i, value, ratio);
                }];
            }
            
            [canvas setNeedsDisplay];
        }
        
        SET_ASSOCIATED_RETAIN(pieAbstract, pieInnerLayer, canvas);
        SET_ASSOCIATED_RETAIN(pieAbstract, pieInnerNumberArray, aryNumbers);
    }
}

/**
 * 绘制中心园层
 */
- (void)drawBorderLayer
{
    if ([_pieCanvasConfig pieBorderWidth] > 0) {
        
        GGCanvas * canvas = [self getCanvasEqualFrame];
        [canvas drawChart];
        [canvas removeAllRenderer];
        
        CGPoint center = CGPointMake(canvas.gg_width / 2, canvas.gg_height / 2);
        GGCircleRenderer * circle = [[GGCircleRenderer alloc] init];
        circle.circle = GGCirclePointMake(center, [_pieCanvasConfig borderRadius]);
        circle.borderColor = [_pieCanvasConfig pieBorderColor];
        circle.borderWidth = [_pieCanvasConfig pieBorderWidth];
        
        [canvas addRenderer:circle];
        [canvas setNeedsDisplay];
    }
}

#pragma mark - Lazy

GGLazyGetMethod(PieAnimationManager, pieAnimation);

@end
