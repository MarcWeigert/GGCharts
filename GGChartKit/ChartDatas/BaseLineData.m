//
//  BaseLineData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/27.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineData.h"
#import "GGChartDefine.h"

@implementation BaseLineData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.width = 1;
        self.color = [UIColor blackColor];
    }
    
    return self;
}

#pragma mark - Private

- (void)setUpMaxAndMin
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self.datas enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
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
    
    [self.lineScaler updateScaler];
    CGMutablePathRef lineRef = CGPathCreateMutable();
    CGPathAddLines(lineRef, NULL, self.lineScaler.linePoints, self.datas.count);
    self.lineCanvas.path = lineRef;
    self.lineCanvas.strokeColor = _color.CGColor;
    self.lineCanvas.lineWidth = _width;
    self.lineCanvas.fillColor = [UIColor clearColor].CGColor;
    CGPathRelease(lineRef);
}

/**
 * 获取数组中最大值最小值
 *
 * @param dataAry 数据组
 * @param max 极大值指针
 * @param min 最小值指针
 */
+ (void)getChartDataAry:(NSArray <BaseLineData *> *)dataAry max:(CGFloat *)max min:(CGFloat *)min
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [dataAry enumerateObjectsUsingBlock:^(BaseLineData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.datas enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
            
            chartMax = obj.floatValue > chartMax ? obj.floatValue : chartMax;
            chartMin = obj.floatValue < chartMin ? obj.floatValue : chartMin;
        }];
    }];
    
    *max = chartMax;
    *min = chartMin;
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

- (BOOL)isAllPositive
{
    __block BOOL isAllPositive = YES;
    
    [self.datas enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        if (obj.floatValue < 0) isAllPositive = NO;
    }];
    
    return isAllPositive;
}

#pragma mark - Lazy

GGLazyGetMethod(DLineScaler, lineScaler);

@end
