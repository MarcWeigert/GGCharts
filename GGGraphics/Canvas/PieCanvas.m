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

@interface PieCanvas ()

@end

@implementation PieCanvas

/**
 * 父类方法
 */
- (void)drawChart
{
    [super drawChart];
    
    for (id <PieDrawAbstract> pieAbstract in [_pieCanvasConfig pieAry]) {
        
        [self drawPieChartWithPie:pieAbstract];
        [self drawSpiderLineWithPie:pieAbstract];
        [self drawInnerStringWithPie:pieAbstract];
    }
}

/**
 * 绘制扇形图
 */
- (void)drawPieChartWithPie:(id <PieDrawAbstract>)pieAbstract
{
    NSMutableArray * pieAry = [NSMutableArray array];
    GGCanvas * baseCanvas = [self getCanvasSquareFrame];
    
    CGFloat maxValue = .0f, minValue = .0f;
    
    if ([pieAbstract roseType] == RoseRadius) {     // 取得最大值
    
        [[pieAbstract dataAry] getMax:&maxValue min:&minValue selGetter:@selector(floatValue) base:0];
    }
    
    for (NSInteger i = 0; i < [pieAbstract dataAry].count; i++) {
        
        [pieAbstract pies][i].center = CGPointMake(baseCanvas.gg_width / 2, baseCanvas.gg_height / 2);
        
        GGPie pie = [pieAbstract pies][i];
        
        // 根据比例伸缩
        if ([pieAbstract roseType] == RoseRadius) {
            
            CGFloat ratioBaseValue = maxValue == 0 ? 1 : maxValue;
            CGFloat radius = pie.radiusRange.outRadius - pie.radiusRange.inRadius;
            radius *= [[pieAbstract dataAry][i] floatValue] / ratioBaseValue;
            pie.radiusRange.outRadius = pie.radiusRange.inRadius + radius;
        }
        
        // 逐步设置内外半径
        if ([pieAbstract pieRadiuRangeForIndex]) {
            
            pie.radiusRange = [pieAbstract pieRadiuRangeForIndex](i);
        }
        
        // 将计算出的结构体滞0, 后面以旋转的方式控制扇形
        pie.transform = 0;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddPie(ref, pie);
        
        UIColor * pieColor = [UIColor blackColor];
        
        if ([pieAbstract pieColorsForIndex]) {
            
            pieColor = [pieAbstract pieColorsForIndex](i, [pieAbstract ratios][i]);
        }
        else {
        
            GGLog(@"请实现扇形图Block: UIColor * (^pieColorsForIndex)(NSInteger index, CGFloat ratio)");
        }
        
        GGShapeCanvas * shapeLayer = [baseCanvas getGGShapeCanvasSquareFrame];
        shapeLayer.fillColor = pieColor.CGColor;
        shapeLayer.lineWidth = 0;
        shapeLayer.path = ref;
        
        // 通过旋转方式控制扇形
        CGAffineTransform transform = CGAffineTransformIdentity;
        shapeLayer.affineTransform = CGAffineTransformRotate(transform, [pieAbstract pies][i].transform);
        
        [pieAry addObject:shapeLayer];
        
        // 设置渐变色
        if ([pieAbstract gradientColorsForIndex]) {
         
            NSArray * colors = [pieAbstract gradientColorsForIndex](i);
            
            CAGradientLayer * gradientLayer = [baseCanvas getCAGradientSquareFrame];
            gradientLayer.colors = [colors getCGColorsArray];
            gradientLayer.startPoint = [pieAbstract gradientColorLine].start;
            gradientLayer.endPoint = [pieAbstract gradientColorLine].end;
            gradientLayer.locations = [pieAbstract gradientLocations];
            gradientLayer.mask = shapeLayer;
        }
    }
    
    SET_ASSOCIATED_RETAIN(pieAbstract, pieShapeLayerArray, pieAry);
}

/**
 * 绘制边框外部
 */
- (void)drawSpiderLineWithPie:(id <PieDrawAbstract>)pieAbstract
{
    if ([pieAbstract showOutLableType] == OutSideShow) {
        
        GGCanvas * baseCanvas = [self getCanvasEqualFrame];
        NSMutableArray * aryLineLayers = [NSMutableArray array];
        NSMutableArray * aryNumbers = [NSMutableArray array];
        
        CGFloat maxValue = .0f, minValue = .0f;
        
        if ([pieAbstract roseType] == RoseRadius) {     // 取得最大值
            
            [[pieAbstract dataAry] getMax:&maxValue min:&minValue selGetter:@selector(floatValue) base:0];
        }
        
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
            
            CGFloat lineStartMove =  pie.radiusRange.outRadius + pieLineSpacing;
            
            // 根据比例伸缩
            if ([pieAbstract roseType] == RoseRadius) {
                
                CGFloat ratioBaseValue = maxValue == 0 ? 1 : maxValue;
                CGFloat radius = pie.radiusRange.outRadius - pie.radiusRange.inRadius;
                radius *= [[pieAbstract dataAry][i] floatValue] / ratioBaseValue;
                lineStartMove = pie.radiusRange.inRadius + radius + pieLineSpacing;
            }
            
            // 逐步设置内外半径
            if ([pieAbstract pieRadiuRangeForIndex]) {
                
                pie.radiusRange = [pieAbstract pieRadiuRangeForIndex](i);
                lineStartMove = pie.radiusRange.outRadius + pieLineSpacing;
            }
            
            CGMutablePathRef ref = CGPathCreateMutable();
            CGPoint draw_center = CGPointMake(shapeLayer.gg_width / 2, shapeLayer.gg_height / 2);
            GGArcLine arcLine = GGArcLineMake(draw_center, pie.transform + pie.arc / 2, pie.radiusRange.outRadius + pieLineSpacing + pieLineLength);
            GGLine line = GGLineWithArcLine(arcLine, false);
            GGLine line_m = GGLineMoveStart(line, lineStartMove);
            CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, pieInflectionLength);
            GGCircle circle = GGCirclePointMake(end_pt, [[pieAbstract outSideLable] linePointRadius]);
            
            GGPathAddCircle(ref, circle);
            GGPathAddLine(ref, line_m);
            CGPathMoveToPoint(ref, NULL, line_m.end.x, line_m.end.y);
            CGPathAddLineToPoint(ref, NULL, end_pt.x, end_pt.y);
            
            shapeLayer.path = ref;
            CGPathRelease(ref);
            
            CGFloat line_arc = GGYCircular(line);
            CGFloat base = line_arc > 0 ? 1 : -1;
            CGFloat westRadioX = [[pieAbstract outSideLable] stringRatio].x >= 0 ? [[pieAbstract outSideLable] stringRatio].x * -1 :  1;
            CGPoint westRadio = CGPointMake([[pieAbstract outSideLable] stringRatio].x + westRadioX, [[pieAbstract outSideLable] stringRatio].y);
            CGPoint offsetRadio = line_arc > 0 ? [[pieAbstract outSideLable] stringRatio] : westRadio;
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
                    
                    return [[pieAbstract outSideLable] attributeStringBlock](i, ratio);
                }];
            }
            
            [aryNumbers addObject:numberRenderer];
        }
        
        [baseCanvas setNeedsDisplay];
        
        SET_ASSOCIATED_RETAIN(pieAbstract, pieOutSideLayerArray, aryLineLayers);
        SET_ASSOCIATED_RETAIN(pieAbstract, pieOutSideNumberArray, aryNumbers);
        SET_ASSOCIATED_RETAIN(pieAbstract, pieInnerLayer, baseCanvas);
    }
}

/**
 * 绘制内部
 */
- (void)drawInnerStringWithPie:(id <PieDrawAbstract>)pieAbstract
{
    if ([pieAbstract showInnerString]) {
        
        GGCanvas * canvas = [self getCanvasSquareFrame];
        NSMutableArray * aryNumbers = [NSMutableArray array];
        
        CGFloat maxValue = .0f, minValue = .0f;
        
        if ([pieAbstract roseType] == RoseRadius) {     // 取得最大值
            
            [[pieAbstract dataAry] getMax:&maxValue min:&minValue selGetter:@selector(floatValue) base:0];
        }
        
        for (NSInteger i = 0; i < [pieAbstract dataAry].count; i++) {
        
            GGPie pie = [pieAbstract pies][i];
            
            // 根据比例伸缩
            if ([pieAbstract roseType] == RoseRadius) {
                
                CGFloat ratioBaseValue = maxValue == 0 ? 1 : maxValue;
                CGFloat radius = pie.radiusRange.outRadius - pie.radiusRange.inRadius;
                radius *= [[pieAbstract dataAry][i] floatValue] / ratioBaseValue;
                pie.radiusRange.outRadius = pie.radiusRange.inRadius + radius;
            }
            
            // 逐步设置内外半径
            if ([pieAbstract pieRadiuRangeForIndex]) {
                
                pie.radiusRange = [pieAbstract pieRadiuRangeForIndex](i);
            }
            
            CGPoint draw_center = CGPointMake(canvas.gg_width / 2, canvas.gg_height / 2);
            GGArcLine arcLine = GGArcLineMake(draw_center, pie.transform + pie.arc / 2, pie.radiusRange.outRadius * .5 + pie.radiusRange.inRadius * .5);
            GGLine line = GGLineWithArcLine(arcLine, false);
            
            CGFloat line_arc = GGYCircular(line);
            CGFloat base = line_arc > 0 ? 1 : -1;
            CGSize size = CGSizeMake([[pieAbstract innerLable] stringOffSet].width * base, [[pieAbstract outSideLable] stringOffSet].height);
            
            // 折线文字
            GGNumberRenderer * numberRenderer = [[GGNumberRenderer alloc] init];
            numberRenderer.offSetRatio = [[pieAbstract innerLable] stringRatio];
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
                    
                    return [[pieAbstract innerLable] attributeStringBlock](i, ratio);
                }];
            }
            
            [canvas setNeedsDisplay];
        }
        
        SET_ASSOCIATED_RETAIN(pieAbstract, pieOutSideLayer, canvas);
        SET_ASSOCIATED_RETAIN(pieAbstract, pieInnerNumberArray, aryNumbers);
    }
}

@end
