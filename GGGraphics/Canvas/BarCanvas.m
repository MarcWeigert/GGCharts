//
//  BarCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarCanvas.h"
#import "GGRectRenderer.h"

@interface BarCanvas ()

/**
 * 文字数据
 */
@property (nonatomic, strong) NSMutableArray <GGNumberRenderer *> * allGGNumberArray;

@end

@implementation BarCanvas

/**
 * 绘制图表(父类方法)
 */
- (void)drawChart
{
    [super drawChart];
    
    // 清空文字信息
    [self.allGGNumberArray removeAllObjects];
    
    for (NSInteger i = 0; i < [_barDrawConfig barAry].count; i++) {
        
        [self drawBarRectsWidthBar:[_barDrawConfig barAry][i] section:i];
        [self drawBarStringWithBar:[_barDrawConfig barAry][i]];
    }
}

/**
 * 绘制柱状图
 */
- (void)drawBarRectsWidthBar:(id <BarDrawAbstract>)barAbstract section:(NSInteger)section
{
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
    
    GGShapeCanvas * downBarCanvas = [self getGGShapeCanvasEqualFrame];
    downBarCanvas.fillColor = [barAbstract barFillColor].CGColor;
    downBarCanvas.lineWidth = 0;
    downBarCanvas.strokeColor = [barAbstract barBorderColor].CGColor;
    downBarCanvas.path = downBarRef;
    CGPathRelease(downBarRef);
    
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
        
        [upBarCanvas pathChangeAnimation:1.0f];
        [downBarCanvas pathChangeAnimation:1.0f];
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
        [stringCanvas removeAllRenderer];
        
        for (NSInteger i = 0; i < [barAbstract dataAry].count; i++) {
            
            CGRect rect = [barAbstract barRects][i];
            CGFloat x = rect.origin.x - [barAbstract offSetRatio].x * rect.size.width;
            CGFloat y = rect.origin.y + ([barAbstract offSetRatio].y + 1) * rect.size.height;
            
            GGNumberRenderer * number = [[GGNumberRenderer alloc] init];
            number.offSetRatio = [barAbstract offSetRatio];
            number.format = [barAbstract dataFormatter];
            number.fromNumber = 0;
            number.toNumber = [[barAbstract dataAry][i] floatValue];
            number.fromPoint = CGPointZero;
            number.toPoint = CGPointMake(x, y);
            number.offSet = [barAbstract stringOffset];
            
            [number drawAtToNumberAndPoint];
            [stringCanvas addRenderer:number];
        }
        
        [stringCanvas setNeedsDisplay];
    }
}


#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, allGGNumberArray);

@end
