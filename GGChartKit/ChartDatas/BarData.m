//
//  BarData.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarData.h"
#import "CGPathCategory.h"
#import "GGStringRenderer.h"

static NSDictionary * s_baseDictionary;

@implementation BarData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _stringFont = [UIFont systemFontOfSize:10];
        _stringColor = [UIColor blackColor];
        _format = @"%.2f";
    }
    
    return self;
}

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

- (NSDictionary *)dicBase
{
    if (s_baseDictionary == nil) {
        
        s_baseDictionary = @{@(BarRectTop) : @0, @(BarRectCenter) : @.5, @(BarRectBottom) : @1};
    }
    
    return s_baseDictionary;
}

/**
 * 绘制文字
 *
 * @param stringCanvas 静态图层
 * @param tye 绘制类型
 */
- (void)drawBarStringWithCanvas:(GGCanvas *)stringCanvas type:(BarDrawType)tye;
{
    [_stringCanvas removeAllRenderer];
    _stringCanvas = stringCanvas;
    [_stringCanvas removeAllRenderer];
    
    [self.datas enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        CGRect rect = self.barScaler.barRects[idx];
        CGFloat y = rect.origin.y + [self.dicBase[@(tye)] floatValue] * rect.size.height;
        CGPoint point = CGPointMake(CGRectGetMidX(rect), y);
        
        NSString * drawStr = [NSString stringWithFormat:_format, obj.floatValue];
        drawStr = _attachedString.length ? [NSString stringWithFormat:@"%@%@", drawStr, _attachedString] : drawStr;
        
        GGStringRenderer * render = [[GGStringRenderer alloc] init];
        render.string = drawStr;
        render.color = self.stringColor;
        render.font = self.stringFont;
        render.offSetRatio = CGPointMake(-.5f, -.5f);
        render.point = point;
        [stringCanvas addRenderer:render];
    }];
    
    [stringCanvas setNeedsDisplay];
}

@end
