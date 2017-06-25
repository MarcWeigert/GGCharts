//
//  DBarScaler.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/22.
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

- (void)updateBarRects:(CGRect *)barRects
{
    if (_barRects != nil) {
        
        free(_barRects);
    }
    
    _barRects = barRects;
}

- (void)dealloc
{
    free(_barRects);
}

- (void)updateScaler
{
    [super updateScaler];
    
    CGFloat bottomY = [self getYPixelWithData:_bottomPrice];
    
    [self.dataAry enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        CGPoint point = self.linePoints[idx];
        _barRects[idx] = GGLineRectMake(point, CGPointMake(point.x, bottomY), _barWidth);
    }];
    
    for (NSInteger i = 0; i < self.dataAry.count; i++) {
        
        CGPoint point = self.linePoints[i];
        _barRects[i] = GGLineRectMake(point, CGPointMake(point.x, bottomY), _barWidth);
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
- (void)getPositiveData:(BarRects)block
{
    CGRect rects[self.dataAry.count];
    CGFloat bottomY = [self getYPixelWithData:_bottomPrice];

    for (NSInteger i = 0; i < self.dataAry.count; i++) {
        
        CGFloat data = [self.dataAry[i] floatValue];
        CGPoint point = self.linePoints[i];
        CGPoint zero = CGPointMake(point.x, bottomY);
        CGRect zeroRect = GGLineRectMake(zero, zero, _barWidth);
        
        rects[i] = data >= 0 ? _barRects[i] : zeroRect;
    }
    
    block(rects, self.dataAry.count);
}

/** 负数的rect */
- (void)getNegativeData:(BarRects)block
{
    CGRect rects[self.dataAry.count];
    CGFloat bottomY = [self getYPixelWithData:_bottomPrice];
    
    for (NSInteger i = 0; i < self.dataAry.count; i++) {
        
        CGFloat data = [self.dataAry[i] floatValue];
        CGPoint point = self.linePoints[i];
        CGPoint zero = CGPointMake(point.x, bottomY);
        
        rects[i] = data < 0 ? _barRects[i] : GGLineRectMake(zero, zero, _barWidth);
    }
    
    block(rects, self.dataAry.count);
}

@end
