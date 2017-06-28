//
//  LineData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineData.h"
#import "CGPathCategory.h"

@implementation LineData

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

@end
