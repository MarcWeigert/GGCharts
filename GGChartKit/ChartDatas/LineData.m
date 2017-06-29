//
//  LineData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineData.h"
#import "CGPathCategory.h"
#import "GGStringRenderer.h"

@implementation LineData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _stringFont = [UIFont systemFontOfSize:10];
        _stringColor = [UIColor blackColor];
    }
    
    return self;
}

/**
 * 绘制线图层
 *
 * @param lineCanvas 图层
 */
- (void)drawLineWithCanvas:(GGShapeCanvas *)lineCanvas shapeCanvas:(GGShapeCanvas *)shapeCanvas
{
    [self drawLineWithCanvas:lineCanvas];
    
    _shapeCanvas = shapeCanvas;
    
    CGMutablePathRef lineRef = CGPathCreateMutable();
    GGPathAddCircles(lineRef, self.lineScaler.linePoints, 2, self.datas.count);
    _shapeCanvas.path = lineRef;
    _shapeCanvas.strokeColor = self.color.CGColor;
    _shapeCanvas.lineWidth = self.width;
    _shapeCanvas.fillColor = [UIColor whiteColor].CGColor;
    CGPathRelease(lineRef);
}

/**
 * 绘制文字层
 *
 * @param stringCanvas 文字
 */
- (void)drawStringWithCanvas:(GGCanvas *)stringCanvas
{
    [_stringCanvas removeAllRenderer];
    _stringCanvas = stringCanvas;
    [_stringCanvas removeAllRenderer];
    
    [self.datas enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GGStringRenderer * render = [[GGStringRenderer alloc] init];
        render.string = obj.stringValue;
        render.color = self.stringColor;
        render.font = self.stringFont;
        render.offSetRatio = CGPointMake(-.5f, -1.1);
        render.point = self.lineScaler.linePoints[idx];
        [stringCanvas addRenderer:render];
    }];
    
    [stringCanvas setNeedsDisplay];
}

@end
