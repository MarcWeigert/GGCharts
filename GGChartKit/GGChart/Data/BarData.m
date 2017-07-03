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
static NSDictionary * s_renderDictionary;

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
    [self.barScaler updateScaler];
    
    // 柱图层
    CGMutablePathRef ref = CGPathCreateMutable();
    GGpathAddCGRects(ref, self.barScaler.barRects, self.datas.count);
    _barCanvas.path = ref;
    _barCanvas.fillColor = self.color.CGColor;
    _barCanvas.lineWidth = 0;
    CGPathRelease(ref);
}

/**
 * 柱状图基数
 */
- (NSDictionary *)dictionaryBaseBar
{
    if (s_baseDictionary == nil) {
        
        s_baseDictionary = @{@(DrawBarTopStringMid) : @0,
                             @(DrawBarTopStringAbove) : @0,
                             @(DrawBarTopStringBelow) : @0,
                             @(DrawBarMidStringMid) : @.5,
                             @(DrawBarMidStringAbove) : @.5,
                             @(DrawBarMidStringBelow) : @.5,
                             @(DrawBarBottomStringMid) : @1,
                             @(DrawBarBottomStringBelow) : @1,
                             @(DrawBarBottomStringAbove) : @1};
    }
    
    return s_baseDictionary;
}

/**
 * 柱状图基数
 */
- (NSDictionary *)dictionaryStringRatio
{
    if (s_renderDictionary == nil) {
        
        s_renderDictionary = @{@(DrawBarTopStringMid) : @-.5,
                               @(DrawBarTopStringAbove) : @-1,
                               @(DrawBarTopStringBelow) : @0,
                               @(DrawBarMidStringMid) : @-.5,
                               @(DrawBarMidStringAbove) : @-1,
                               @(DrawBarMidStringBelow) : @0,
                               @(DrawBarBottomStringMid) : @-.5,
                               @(DrawBarBottomStringBelow) : @0,
                               @(DrawBarBottomStringAbove) : @-1};
    }
    
    return s_renderDictionary;
}

/**
 * 绘制文字层
 *
 * @param stringCanvas 文字
 */
- (void)drawStringWithCanvas:(GGCanvas *)stringCanvas
{
    [super drawStringWithCanvas:stringCanvas];
    
    [self.datas enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        CGRect rect = self.barScaler.barRects[idx];
        CGFloat y = rect.origin.y + [self.dictionaryBaseBar[@(_stringDrawType)] floatValue] * rect.size.height;
        CGFloat ratio = [self.dictionaryStringRatio[@(_stringDrawType)] floatValue];
        CGPoint point = CGPointMake(CGRectGetMidX(rect), y);
        
        NSString * drawStr = [NSString stringWithFormat:self.format, obj.floatValue];
        drawStr = self.attachedString.length ? [NSString stringWithFormat:@"%@%@", drawStr, self.attachedString] : drawStr;
        
        GGStringRenderer * render = [[GGStringRenderer alloc] init];
        render.string = drawStr;
        render.color = self.stringColor;
        render.font = self.stringFont;
        render.offSetRatio = CGPointMake(-.5f, ratio);
        render.point = point;
        [stringCanvas addRenderer:render];
    }];
    
    [stringCanvas setNeedsDisplay];
}

@end
