//
//  BarCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarCanvas.h"
#import "GGRectRenderer.h"
#include <objc/runtime.h>

static const void * barUpLayer = @"barUpLayer";
static const void * barDownLayer = @"barDownLayer";
static const void * barStringLayer = @"barStringLayer";

#define SET_ASSOCIATED_ASSIGN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_ASSIGN)
#define SET_ASSOCIATED_RETAIN(obj, key, value) objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN)
#define GET_ASSOCIATED(obj, key) objc_getAssociatedObject(obj, key)

@interface BarCanvas ()

/**
 * 中线位置
 */
@property (nonatomic, assign) CGFloat lastMidLinePix;

/**
 * 中轴线层
 */
@property (nonatomic, weak) GGShapeCanvas * midLineLayer;

/**
 * 动画类
 */
@property (nonatomic, strong) Animator * animator;

@end

@implementation BarCanvas

/**
 * 绘制图表(父类方法)
 */
- (void)drawChart
{
    [super drawChart];
    
    for (NSInteger i = 0; i < [_barDrawConfig barAry].count; i++) {
        
        [self drawBarRectsWidthBar:[_barDrawConfig barAry][i] section:i];
        [self drawBarStringWithBar:[_barDrawConfig barAry][i]];
    }
    
    [self drawMidLine];
    
    // 启动动画
    if ([_barDrawConfig updateNeedAnimation]) {
        
        [self updateSubLayerWithAnimations];
    }
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
        
        for (NSInteger i = 0; i < [barAbstract dataAry].count; i++) {
            
            CGRect rect = [barAbstract barRects][i];
            CGFloat x = rect.origin.x - [barAbstract offSetRatio].x * rect.size.width;
            CGFloat y = rect.origin.y + ([barAbstract offSetRatio].y + 1) * rect.size.height;
            
            GGNumberRenderer * number = [self getNumberRenderer];
            number.offSetRatio = [barAbstract offSetRatio];
            number.format = [barAbstract dataFormatter];
            number.toNumber = [[barAbstract dataAry][i] floatValue];
            number.toPoint = CGPointMake(x + [barAbstract stringOffset].width, y + [barAbstract stringOffset].height);
            number.getNumberColorBlock = [_barDrawConfig stringColorForValue];
            
            if (CGPointEqualToPoint(number.fromPoint, CGPointZero)) {
                
                number.fromPoint = CGPointMake(number.toPoint.x, [barAbstract bottomYPix]);
            }
            
            [number drawAtToNumberAndPoint];
            [stringCanvas addRenderer:number];
        }
        
        [stringCanvas setNeedsDisplay];
        
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
        
        self.midLineLayer = [self getGGShapeCanvasEqualFrame];
        self.midLineLayer.path = ref;
        self.midLineLayer.lineWidth = [_barDrawConfig midLineWidth];
        self.midLineLayer.strokeColor = [_barDrawConfig midLineColor].CGColor;
    }
}

/**
 * 更新动画
 */
- (void)updateSubLayerWithAnimations
{
    [self.midLineLayer pathChangeAnimation:.5f];
    
    for (id <BarDrawAbstract> drawBarAbstract in [_barDrawConfig barAry]) {
        
        [GET_ASSOCIATED(drawBarAbstract, barUpLayer) pathChangeAnimation:.5f];
        [GET_ASSOCIATED(drawBarAbstract, barDownLayer) pathChangeAnimation:.5f];
    }
    
    [self.animator startAnimationWithDuration:.5f animationArray:self.visibleNumberRenderers updateBlock:^(CGFloat progress) {
        
        for (id <BarDrawAbstract> drawBarAbstract in [_barDrawConfig barAry]) {
            
            [GET_ASSOCIATED(drawBarAbstract, barStringLayer) setNeedsDisplay];
        }
    }];
}

#pragma mark - Lazy

/**
 * 动画类
 */
- (Animator *)animator
{
    if (_animator == nil) {
        
        _animator = [[Animator alloc] init];
        _animator.animationType = AnimationLinear;
    }
    
    return _animator;
}

@end
