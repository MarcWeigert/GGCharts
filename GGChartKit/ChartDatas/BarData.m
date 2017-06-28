//
//  BarData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarData.h"
#import "CGPathCategory.h"

@implementation BarData

- (void)setDatas:(NSArray<NSNumber *> *)datas
{
    [super setDatas:datas];
    
    self.barScaler.min = self.lineScaler.min;
}

- (void)setColor:(UIColor *)color
{
    [super setColor:color];
    
    _barCanvas.fillColor = color.CGColor;
}

/**
 * 绘制柱状图层
 *
 * @param barCanvas 图层
 */
- (void)drawBarWithCanvas:(GGShapeCanvas *)barCanvas
{
    _barCanvas = barCanvas;
    
    self.barScaler.bottomPrice = self.barScaler.min;
    [self.barScaler updateScaler];
    
    // 柱图层
    CGMutablePathRef ref = CGPathCreateMutable();
    GGpathAddCGRects(ref, self.barScaler.barRects, self.datas.count);
    _barCanvas.path = ref;
    _barCanvas.fillColor = self.color.CGColor;
    _barCanvas.lineWidth = 0;
    CGPathRelease(ref);
}

@end
