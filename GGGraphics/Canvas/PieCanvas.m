//
//  PieCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieCanvas.h"
#import <objc/runtime.h>

@interface PieCanvas ()

@end

@implementation PieCanvas

/**
 * 父类方法
 */
- (void)drawChart
{
    for (id <PieDrawAbstract> pieAbstract in [_pieCanvasConfig pieAry]) {
        
        [self drawPieChartWithPie:pieAbstract];
        [self drawSpiderLineWithPie:pieAbstract];
    }
}

/**
 * 绘制扇形图
 */
- (void)drawPieChartWithPie:(id <PieDrawAbstract>)pieAbstract
{
    NSMutableArray * pieAry = [NSMutableArray array];
    GGCanvas * baseCanvas = [self getCanvasSquareFrame];
    
    for (NSInteger i = 0; i < [pieAbstract dataAry].count; i++) {
        
        [pieAbstract pies][i].center = CGPointMake(baseCanvas.gg_width / 2, baseCanvas.gg_height / 2);
        
        GGPie pie = [pieAbstract pies][i];
        
        // 根据比例伸缩
        if ([pieAbstract roseType] == RoseRadius) {
            
            CGFloat radius = pie.radiusRange.outRadius - pie.radiusRange.inRadius;
            radius *= [pieAbstract ratios][i];
            pie.radiusRange.outRadius = pie.radiusRange.inRadius + radius;
        }
        
        // 将计算出的结构体滞0, 后面以旋转的方式控制扇形
        GGPie newPie = GGPieCopyWithPie(pie);
        newPie.transform = 0;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddPie(ref, newPie);
        
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
            
            GGPie pie = [pieAbstract pies][i];
            CGFloat pieLineSpacing = [[pieAbstract outSideLable] lineSpacing];
            CGFloat pieLineLength = [[pieAbstract outSideLable] lineLength];
            CGFloat pieInflectionLength = [[pieAbstract outSideLable] inflectionLength];
            
            CGMutablePathRef ref = CGPathCreateMutable();
            CGPoint draw_center = CGPointMake(shapeLayer.gg_width / 2, shapeLayer.gg_height / 2);
            GGArcLine arcLine = GGArcLineMake(draw_center, pie.transform + pie.arc / 2, pie.radiusRange.outRadius + pieLineSpacing + pieLineLength);
            GGLine line = GGLineWithArcLine(arcLine, false);
            GGLine line_m = GGLineMoveStart(line, pie.radiusRange.outRadius + pieLineSpacing);
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
            CGPoint offsetRadio = line_arc > 0 ? CGPointMake(0, -.5f) : CGPointMake(-1, -.5f);
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
    }
}

@end
