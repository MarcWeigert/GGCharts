//
//  TimeChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MinuteChart.h"
#import "GGChartDefine.h"
#import "DLineScaler.h"
#import "DBarScaler.h"
#import "NSArray+Stock.h"
#import "CGPathCategory.h"

@interface MinuteChart ()

@property (nonatomic, strong) DBarScaler * barScaler;       ///< 成交量定标器
@property (nonatomic, strong) DLineScaler * lineScaler;     ///< 分时线定标器
@property (nonatomic, strong) DLineScaler * averageScaler;      ///< 均价线定标器

@end

@implementation MinuteChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _lineRatio = .6f;
        _lineColor = RGB(66, 112, 186);
        _redColor = RGB(216, 94, 101);
        _greenColor = RGB(150, 234, 166);
        _avgColor = RGB(204, 156, 101);
    }
    
    return self;
}

- (void)setObjTimeAry:(NSArray<VolumeAbstract, MinuteAbstract> *)objTimeAry
{
    _objTimeAry = objTimeAry;
    
    [self configLineScaler];
    [self configBarScaler];
}

- (void)configLineScaler
{
    CGFloat lineMax;
    CGFloat lineMin;
    [_objTimeAry getMax:&lineMax min:&lineMin selGetter:@selector(ggTimePrice) base:.15f];
    
    self.lineScaler.max = lineMax;
    self.lineScaler.min = lineMin;
    self.lineScaler.xMaxCount = 240;
    self.lineScaler.xRatio = 0;
    [self.lineScaler setObjAry:_objTimeAry getSelector:@selector(ggTimePrice)];
    
    self.averageScaler.max = lineMax;
    self.averageScaler.min = lineMin;
    self.averageScaler.xMaxCount = 240;
    self.averageScaler.xRatio = 0;
    [self.averageScaler setObjAry:_objTimeAry getSelector:@selector(ggTimeAveragePrice)];
}

- (void)drawLineChart
{
    CGFloat lineHeight = self.frame.size.height * _lineRatio;
    
    // 分时线
    CGRect lineRect = CGRectMake(0, 0, self.frame.size.width, lineHeight);
    self.lineScaler.rect = lineRect;
    [self.lineScaler updateScaler];
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, self.lineScaler.linePoints, self.lineScaler.lineObjAry.count);
    GGShapeCanvas * shape = [self getGGCanvasEqualFrame];
    shape.strokeColor = _lineColor.CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.path = ref;
    CGPathRelease(ref);
    
    self.averageScaler.rect = lineRect;
    [self.averageScaler updateScaler];
    
    // 均价线
    CGMutablePathRef avg_ref = CGPathCreateMutable();
    CGPathAddLines(avg_ref, NULL, self.averageScaler.linePoints, self.averageScaler.lineObjAry.count);
    GGShapeCanvas * avgShape = [self getGGCanvasEqualFrame];
    avgShape.strokeColor = _avgColor.CGColor;
    avgShape.fillColor = [UIColor clearColor].CGColor;
    avgShape.path = avg_ref;
    CGPathRelease(avg_ref);
}

- (void)configBarScaler
{
    CGFloat lineMax;
    CGFloat lineMin;
    [_objTimeAry getMax:&lineMax min:&lineMin selGetter:@selector(ggVolume) base:0];
    
    self.barScaler.max = lineMax;
    self.barScaler.min = 0;
    self.barScaler.xMaxCount = 240;
    self.barScaler.xRatio = 0;
    self.barScaler.barWidth = 1;
    [self.barScaler setObjAry:_objTimeAry getSelector:@selector(ggVolume)];
}

- (void)drawBarChart
{
    CGFloat lineHeight = self.frame.size.height * _lineRatio;
    CGFloat lineBarPadding = 10;
    
    // 成交量
    CGRect barRect = CGRectMake(0, lineHeight + lineBarPadding, self.frame.size.width, self.frame.size.height - lineHeight - lineBarPadding);
    self.barScaler.rect = barRect;
    [self.barScaler updateScaler];
    
    CGMutablePathRef redBar = CGPathCreateMutable();
    CGMutablePathRef greenBar = CGPathCreateMutable();
    
    [self.objTimeAry enumerateObjectsUsingBlock:^(id <MinuteAbstract> obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUInteger before = idx == 0 ? 0 : idx - 1;
        CGFloat cur_price = [obj ggTimePrice];
        CGFloat before_price = [self.objTimeAry[before] ggTimePrice];
        
        CGRect barRect = self.barScaler.barRects[idx];
        cur_price >= before_price ? GGPathAddCGRect(redBar, barRect) : GGPathAddCGRect(greenBar, barRect);
    }];
    
    GGShapeCanvas * barRedShape = [self getGGCanvasEqualFrame];
    barRedShape.lineWidth = 0;
    barRedShape.strokeColor = _redColor.CGColor;
    barRedShape.fillColor = _redColor.CGColor;
    barRedShape.path = redBar;
    CGPathRelease(redBar);
    
    GGShapeCanvas * barGreenShape = [self getGGCanvasEqualFrame];
    barGreenShape.lineWidth = 0;
    barGreenShape.strokeColor = _greenColor.CGColor;
    barGreenShape.fillColor = _greenColor.CGColor;
    barGreenShape.path = greenBar;
    CGPathRelease(greenBar);
}

- (void)drawChart
{
    [super drawChart];
    
    [self drawLineChart];
    [self drawBarChart];
}

#pragma mark - Lazy

GGLazyGetMethod(DLineScaler, lineScaler);

GGLazyGetMethod(DLineScaler, averageScaler);

GGLazyGetMethod(DBarScaler, barScaler);

@end
