//
//  DBarScaler.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "DBarScaler.h"
#import "GGChartGeometry.h"

@implementation DBarScaler

- (void)setDataAry:(NSArray<NSNumber *> *)dataAry
{
    [super setDataAry:dataAry];
    
    CGRect * rects = malloc(dataAry.count * sizeof(CGRect));
    [self updateBarRects:rects];
}

/**
 * 自定义对象转换转换
 *
 * @param objAry 模型类数组
 * @param getter 模型类方法, 方法无参数, 返回值为float, 否则会崩溃。
 */
- (void)setObjAry:(NSArray <NSObject *> *)objAry getSelector:(SEL)getter
{
    [super setObjAry:objAry getSelector:getter];
    
    CGRect * rects = malloc(objAry.count * sizeof(CGRect));
    [self updateBarRects:rects];
}

- (void)updateBarRects:(CGRect *)barRects
{
    if (_barRects != nil) {
        
        free(_barRects);
        _barRects = nil;
    }
    
    _barRects = barRects;
}

- (void)dealloc
{
    if (_barRects != nil) {
        
        free(_barRects);
        _barRects = nil;
    }
}

- (void)updateScaler
{
    [super updateScaler];
    
    CGFloat bottomY = self.aroundY;
    NSInteger count = self.lineObjAry.count > 0 ? self.lineObjAry.count : self.dataAry.count;
    
    for (NSInteger i = 0; i < count; i++) {
        
        CGPoint point = self.linePoints[i];
        _barRects[i] = GGLineDownRectMake(point, CGPointMake(point.x, bottomY), _barWidth);
    }
}

- (void)updateScalerWithRange:(NSRange)range
{
    [super updateScalerWithRange:range];
    
    NSInteger start = range.location;
    NSInteger end = NSMaxRange(range);
    CGFloat bottomY = self.aroundY;
    
    for (NSInteger i = start; i < end; i++) {
        
        CGPoint point = self.linePoints[i];
        _barRects[i] = GGLineDownRectMake(point, CGPointMake(point.x, bottomY), _barWidth);
    }
}

/** 靠近点的数据index */
- (NSUInteger)indexOfPoint:(CGPoint)point
{
    CGFloat xSpileWidth = CGRectGetWidth(self.rect) / self.xMaxCount;
    CGFloat offSet = xSpileWidth * self.xRatio;
    NSInteger index = (point.x - self.rect.origin.x - offSet + _barWidth / 2) / xSpileWidth;
    if (index < 0) { index = 0; }
    if (index >= self.dataAry.count) { index = self.dataAry.count - 1; }
    return index;
}

/** 正数的rect */
- (void)getPositiveData:(BarRects)block range:(NSRange)range
{
    CGRect rects[range.length];
    CGFloat bottomY = self.aroundY;
    
    for (NSInteger i = 0; i < range.length; i++) {
        
        CGFloat data = [self.dataAry[range.location + i] floatValue];
        CGPoint point = self.linePoints[range.location + i];
        CGPoint zero = CGPointMake(point.x, bottomY);
        CGRect zeroRect = GGLineDownRectMake(zero, zero, _barWidth);
        
        rects[i] = data >= 0 ? _barRects[range.location + i] : zeroRect;
    }
    
    block(rects, range.length);
}

/** 负数的rect */
- (void)getNegativeData:(BarRects)block range:(NSRange)range
{
    CGRect rects[range.length];
    CGFloat bottomY = self.aroundY;
    
    for (NSInteger i = 0; i < range.length; i++) {
        
        CGFloat data = [self.dataAry[range.location + i] floatValue];
        CGPoint point = self.linePoints[range.location + i];
        CGPoint zero = CGPointMake(point.x, bottomY);
        
        rects[i] = data < 0 ? _barRects[range.location + i] : GGLineDownRectMake(zero, zero, _barWidth);
    }
    
    block(rects, range.length);
}

/** 正数的rect */
- (void)getPositiveData:(BarRects)block
{
    CGRect rects[self.dataAry.count];
    CGFloat bottomY = self.aroundY;
    
    for (NSInteger i = 0; i < self.dataAry.count; i++) {
        
        CGFloat data = [self.dataAry[i] floatValue];
        CGPoint point = self.linePoints[i];
        CGPoint zero = CGPointMake(point.x, bottomY);
        CGRect zeroRect = GGLineDownRectMake(zero, zero, _barWidth);
        
        rects[i] = data >= 0 ? _barRects[i] : zeroRect;
    }
    
    block(rects, self.dataAry.count);
}

/** 负数的rect */
- (void)getNegativeData:(BarRects)block
{
    CGRect rects[self.dataAry.count];
    CGFloat bottomY = self.aroundY;
    
    for (NSInteger i = 0; i < self.dataAry.count; i++) {
        
        CGFloat data = [self.dataAry[i] floatValue];
        CGPoint point = self.linePoints[i];
        CGPoint zero = CGPointMake(point.x, bottomY);
        
        rects[i] = data < 0 ? _barRects[i] : GGLineDownRectMake(zero, zero, _barWidth);
    }
    
    block(rects, self.dataAry.count);
}

@end
