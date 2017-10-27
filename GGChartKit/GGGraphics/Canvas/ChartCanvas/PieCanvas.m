//
//  PieCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieCanvas.h"
#import <objc/runtime.h>

@interface PieCanvas ()

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
    
    [self drawBorderLayer];
    
    for (id <PieDrawAbstract> pieAbstract in [_pieCanvasConfig pieAry]) {
        
        [self drawPieLayerWithPie:pieAbstract];
        [self drawInnerStringWithPie:pieAbstract];
    }
    
    [self.pieAnimation setPieCanvasAbstract:_pieCanvasConfig];
    
    // 启动动画
    if ([_pieCanvasConfig updateNeedAnimation]) {
        
        if (self.hadRenderer) {
            
            [self.pieAnimation startAnimationWithDuration:.25f animationType:ChangeAnimation];
        }
    }
    
    self.hadRenderer = YES;
}

- (void)dealloc
{
    for (id <PieDrawAbstract> pieAbstract in [_pieCanvasConfig pieAry]) {
        
        objc_removeAssociatedObjects(pieAbstract);
    }
}

/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(PieAnimationType)pieAnimationType duration:(NSTimeInterval)duration
{
    [self.pieAnimation startAnimationWithDuration:duration animationType:pieAnimationType];
}

/**
 * 绘制扇形
 */
- (void)drawPieLayerWithPie:(id <PieDrawAbstract>)pieAbstract
{
    NSMutableArray * pieAry = [NSMutableArray array];
    GGCanvas * baseCanvas = [self getCanvasEqualFrame];
    [baseCanvas drawChart];
    SET_ASSOCIATED_ASSIGN(pieAbstract, pieBaseShapeLayer, baseCanvas);
    
    for (NSInteger i = 0; i < [pieAbstract dataAry].count; i++) {
        
        GGPie pie = [pieAbstract pies][i];
        UIColor * pieColor = [UIColor blackColor];
        
        if ([pieAbstract pieColorsForIndex]) {
            
            pieColor = [pieAbstract pieColorsForIndex](i, [pieAbstract ratios][i]);
        }
        else if (![pieAbstract gradientColorsForIndex]) {
            
            GGLog(@"请实现扇形图Block: UIColor * (^pieColorsForIndex)(NSInteger index, CGFloat ratio) \
                  或 NSArray <UIColor *> * (^gradientColorsForIndex)(NSInteger index)");
        }
        
        GGPieLayer * pieLayer = [baseCanvas getPieLayerEqualFrame];
        pieLayer.pieColor = pieColor;
        pieLayer.pie = pie;
        pieLayer.showOutLableType = [pieAbstract showOutLableType];
        pieLayer.outSideLable = [pieAbstract outSideLable];
        pieLayer.numberRenderer.sum = [pieAbstract sum];
        pieLayer.numberRenderer.toNumber = [[pieAbstract dataAry][i] floatValue];
        pieLayer.numberRenderer.format = [[pieAbstract outSideLable] stringFormat];
        pieLayer.numberRenderer.color = [[pieAbstract outSideLable] lableColor];
        pieLayer.numberRenderer.font = [[pieAbstract outSideLable] lableFont];
        pieLayer.numberRenderer.hidden = [pieAbstract showOutLableType] != OutSideShow;
        
        // 富文本字符
        if ([[pieAbstract outSideLable] attributeStringBlock]) {
            
            [pieLayer.numberRenderer setAttrbuteStringValueAndRatioBlock:^NSAttributedString *(CGFloat value, CGFloat ratio) {
                
                return [[pieAbstract outSideLable] attributeStringBlock](i, value, ratio);
            }];
        }
        
        // 设置线颜色
        if ([[pieAbstract outSideLable] lineColorsBlock]) {
            
            pieLayer.lineColor = [[pieAbstract outSideLable] lineColorsBlock](i, [[pieAbstract dataAry][i] floatValue]);
        }
        else {
            
            pieLayer.lineColor = pieColor;
        }
        
        // 设置渐变色
        if ([pieAbstract gradientColorsForIndex]) {
            
            pieLayer.gradientColors = [pieAbstract gradientColorsForIndex](i);
            pieLayer.gradientLocations = [pieAbstract gradientLocations];
        }
        
        [pieLayer.numberRenderer drawAtToNumberAndPoint];
        [pieLayer setNeedsDisplay];
        [pieAry addObject:pieLayer];
        
        SET_ASSOCIATED_RETAIN(pieAbstract, pieShapeLayerArray, [NSArray arrayWithArray:pieAry]);
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
