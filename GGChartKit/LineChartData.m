//
//  LineChartData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineChartData.h"

#define GGLazyGetMethod(type, attribute)            \
- (type *)attribute                                 \
{                                                   \
if (!_##attribute) {                            \
_##attribute = [[type alloc] init];         \
}                                               \
return _##attribute;                            \
}

@implementation LineChartData

#pragma mark - Private

- (void)setUpMaxAndMin
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self.dataSet enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        chartMax = obj.floatValue > chartMax ? obj.floatValue : chartMax;
        chartMin = obj.floatValue < chartMin ? obj.floatValue : chartMin;
    }];
    
    _dataMax = chartMax;
    _dataMin = chartMin;
}

- (void)setUpLineScaler
{
    CGFloat base = [self getBase];
    
    self.lineScaler.max = _dataMax += base;
    self.lineScaler.min = _dataMin -= base;
    self.lineScaler.dataAry = _datas;
}

#pragma mark - Public

- (void)drawLineWithCanvas:(GGShapeCanvas *)lineCanvas
{
    _lineCanvas = lineCanvas;
}

#pragma mark - Setter && Getter

- (void)setWidth:(CGFloat)width
{
    _width = width;
    _lineCanvas.lineWidth = width;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    _lineCanvas.strokeColor = color.CGColor;
}

- (void)setDatas:(NSArray<NSNumber *> *)datas
{
    _datas = datas;
    
    [self setUpMaxAndMin];
    [self setUpLineScaler];
}

- (CGFloat)getBase
{
    return fabs(_dataMax - _dataMin) * 0.1;
}

#pragma mark - Lazy

GGLazyGetMethod(DLineScaler, lineScaler);

@end
