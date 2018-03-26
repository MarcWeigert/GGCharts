//
//  BarCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarCanvas.h"
#import "GGRectRenderer.h"
#import "BarAnimationsManager.h"
#include <objc/runtime.h>

@interface BarCanvas ()

/**
 * 中线位置
 */
@property (nonatomic, assign) CGFloat lastMidLinePix;

/**
 * 动画管理类
 */
@property (nonatomic, strong) BarAnimationsManager * barAnimations;

/**
 * 是否经过第一次渲染
 */
@property (nonatomic, assign) BOOL hadRenderer;

@end

@implementation BarCanvas

/**
 * 绘制图表(父类方法)
 */
- (void)drawChart
{
    [super drawChart];
    
    // 清空动画管理类
    [self.barAnimations resetAnimationManager];
    
    for (NSInteger i = [_barDrawConfig barAry].count - 1; i >= 0; i--) {
        
        [self drawBarRectsWidthBar:[_barDrawConfig barAry][i] section:i];
        [self drawBarStringWithBar:[_barDrawConfig barAry][i]];
        
        // 柱状图抽象类注册到管理类中
        [self.barAnimations registerBarDrawAbstract:[_barDrawConfig barAry][i]];
    }
    
    [self drawMidLine];
    
    // 启动动画
    if ([_barDrawConfig updateNeedAnimation]) {
        
        if (self.hadRenderer) {
            
            [self.barAnimations startAnimationWithDuration:.25f animationType:BarAnimationChangeType];
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
- (void)startAnimationsWithType:(BarAnimationsType)type duration:(NSTimeInterval)duration
{
    [self.barAnimations startAnimationWithDuration:duration animationType:type];
}

/**
 * 绘制柱状图
 */
- (void)drawBarRectsWidthBar:(id <BarDrawAbstract>)barAbstract section:(NSInteger)section
{
    _lastMidLinePix = [barAbstract bottomYPix];
    
    CGMutablePathRef upBarRef = CGPathCreateMutable();
    CGMutablePathRef downBarRef = CGPathCreateMutable();
    
    for (NSInteger i = 0; i < [barAbstract dataAry].count; i++) {
        
        CGRect barRect = [barAbstract barRects][i];
        CGRect mixRect = CGRectMake(barRect.origin.x, [barAbstract bottomYPix], [barAbstract barWidth], 0);
        
        if (CGRectGetMaxY(barRect) > [barAbstract bottomYPix]) {
            
            GGPathAddCGRect(upBarRef, barRect);
            GGPathAddCGRect(downBarRef, mixRect);
        }
        else {
        
            GGPathAddCGRect(downBarRef, barRect);
            GGPathAddCGRect(upBarRef, mixRect);
        }
    }
    
    GGShapeCanvas * upBarCanvas = [self getGGShapeCanvasEqualFrame];
    upBarCanvas.fillColor = [barAbstract barFillColor].CGColor;
    upBarCanvas.lineWidth = 0;
    upBarCanvas.strokeColor = [barAbstract barBorderColor].CGColor;
    upBarCanvas.path = upBarRef;
    CGPathRelease(upBarRef);
    SET_ASSOCIATED_ASSIGN(barAbstract, barUpLayer, upBarCanvas);
    
    GGShapeCanvas * downBarCanvas = [self getGGShapeCanvasEqualFrame];
    downBarCanvas.fillColor = [barAbstract barFillColor].CGColor;
    downBarCanvas.lineWidth = 0;
    downBarCanvas.strokeColor = [barAbstract barBorderColor].CGColor;
    downBarCanvas.path = downBarRef;
    CGPathRelease(downBarRef);
    SET_ASSOCIATED_ASSIGN(barAbstract, barDownLayer, downBarCanvas);
    
    if ([_barDrawConfig barColorsAtIndexPath]) {    // 分布绘制颜色
        
        GGCanvas * upCanvas = [self getCanvasEqualFrame];
        upCanvas.isCloseDisableActions = YES;
        upCanvas.isCashBeforeRenderers = YES;
        [upCanvas removeAllRenderer];
        [upBarCanvas removeFromSuperlayer];
        upCanvas.mask = upBarCanvas;
        
        GGCanvas * downCanvas = [self getCanvasEqualFrame];
        downCanvas.isCloseDisableActions = YES;
        downCanvas.isCashBeforeRenderers = YES;
        [downCanvas removeAllRenderer];
        [downBarCanvas removeFromSuperlayer];
        downCanvas.mask = downBarCanvas;
        
        CGRect drawRect = UIEdgeInsetsInsetRect(self.frame, [_barDrawConfig insets]);
        
        for (NSInteger row = 0; row < [barAbstract dataAry].count; row++) {
            
            CGRect barRect = [barAbstract barRects][row];
            NSNumber * data = [barAbstract dataAry][row];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UIColor * blockColor = [_barDrawConfig barColorsAtIndexPath](indexPath, data);
            
            GGRectRenderer * rectRenderder = [[GGRectRenderer alloc] init];
            rectRenderder.rect = CGRectMake(barRect.origin.x, drawRect.origin.y, [barAbstract barWidth], drawRect.size.height);
            rectRenderder.fillColor = blockColor == nil ? [barAbstract barFillColor] : blockColor;
            
            if (CGRectGetMaxY(barRect) > [barAbstract bottomYPix]) {
                
                [upCanvas addRenderer:rectRenderder];
            }
            else {
                
                [downCanvas addRenderer:rectRenderder];
            }
        }
        
        [downCanvas setNeedsDisplay];
        [upCanvas setNeedsDisplay];
    }
}

/**
 * 绘制文字
 */
- (void)drawBarStringWithBar:(id <BarDrawAbstract>)barAbstract
{
    if ([barAbstract stringFont] != nil &&
        [barAbstract stringColor] != nil) {
        
        GGCanvas * stringCanvas = [self getCanvasEqualFrame];
        stringCanvas.isCloseDisableActions = YES;
        [stringCanvas removeAllRenderer];
        
        NSMutableArray * numberRenderers = [NSMutableArray array];
        
        for (NSInteger i = 0; i < [barAbstract dataAry].count; i++) {
            
            CGRect rect = [barAbstract barRects][i];
            CGPoint barRatio = RATIO_POINT_CONVERT([barAbstract offSetRatio]);
            CGFloat x = rect.origin.x - barRatio.x * rect.size.width;
            CGFloat y = rect.origin.y + (barRatio.y + 1) * rect.size.height;
            
            GGNumberRenderer * number = [self getNumberRenderer];
            number.offSetRatio = [barAbstract offSetRatio];
            number.format = [barAbstract dataFormatter];
            number.color = [barAbstract stringColor];
            number.font = [barAbstract stringFont];
            number.toNumber = [[barAbstract dataAry][i] floatValue];
            number.toPoint = CGPointMake(x + [barAbstract stringOffset].width, y + [barAbstract stringOffset].height);
            number.getNumberColorBlock = [_barDrawConfig stringColorForValue];
            
            [number drawAtToNumberAndPoint];
            [stringCanvas addRenderer:number];
            [numberRenderers addObject:number];
        }
        
        [stringCanvas setNeedsDisplay];
        
        SET_ASSOCIATED_RETAIN(barAbstract, barNumberArray, numberRenderers);
        SET_ASSOCIATED_ASSIGN(barAbstract, barStringLayer, stringCanvas);
    }
}

/**
 * 绘制中轴线
 */
- (void)drawMidLine
{
    if ([_barDrawConfig midLineWidth] > 0) {
        
        CGRect drawRect = UIEdgeInsetsInsetRect(self.frame, [_barDrawConfig insets]);
        GGLine line = GGLineRectForY(drawRect, _lastMidLinePix);
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPathMoveToPoint(ref, NULL, line.start.x, line.start.y);
        CGPathAddLineToPoint(ref, NULL, line.end.x, line.end.y);
        
        GGShapeCanvas * lineLayer = [self getGGShapeCanvasEqualFrame];
        lineLayer.path = ref;
        lineLayer.lineWidth = [_barDrawConfig midLineWidth];
        lineLayer.strokeColor = [_barDrawConfig midLineColor].CGColor;
        CGPathRelease(ref);
        
        self.barAnimations.midLineLayer = lineLayer;
    }
}

#pragma mark - Lazy

GGLazyGetMethod(BarAnimationsManager, barAnimations);

@end
