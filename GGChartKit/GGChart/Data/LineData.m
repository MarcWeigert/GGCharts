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
#import "GGChartDefine.h"
#import "ChartBaseEvent.h"

@interface LineEvent : ChartBaseEvent

- (void)performWith:(CGPoint)point index:(NSUInteger)index;

@end

@implementation LineEvent

- (void)performWith:(CGPoint)point index:(NSUInteger)index
{
    void (*barFunc)(id target, SEL action, CGPoint point, NSUInteger idx) = self.imp;
    barFunc(self.eventTarget, self.eventAction, point, index);
}

@end

@interface LineData ()

@property (nonatomic, strong) NSMutableDictionary * actionDictioary;

@end

@implementation LineData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _isShowShape = YES;
    }
    
    return self;
}

/**
 * 增加点击事件
 *
 * @param target 执行类
 * @param action 响应方法
 * @param controlEvents 点击方法
 */
- (void)addTarget:(id)target
           action:(SEL)action
     forBarEvents:(GGChartEvents)controlEvents
{
    LineEvent * event = [LineEvent eventWithTarget:target action:action];
    [self.actionDictioary setObject:event forKey:@(controlEvents)];
}

/**
 * 绘制文字层
 *
 * @param stringCanvas 文字
 */
- (void)drawStringWithCanvas:(GGCanvas *)stringCanvas
{
    [super drawStringWithCanvas:stringCanvas];
    
    [self.datas enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString * drawStr = [NSString stringWithFormat:self.format, obj.floatValue];
        drawStr = self.attachedString.length ? [NSString stringWithFormat:@"%@%@", drawStr, self.attachedString] : drawStr;
        
        GGStringRenderer * render = [[GGStringRenderer alloc] init];
        render.string = drawStr;
        render.color = self.stringColor;
        render.font = self.stringFont;
        render.offSetRatio = CGPointMake(-.5f, -1.1);
        render.point = self.lineScaler.linePoints[idx];
        [stringCanvas addRenderer:render];
    }];
    
    [stringCanvas setNeedsDisplay];
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
 * 开始触摸
 *
 * @param point 手指触碰屏幕的位置
 */
- (void)chartTouchesBegan:(CGPoint)point
{
    NSUInteger idx = [self.lineScaler indexOfPoint:point];
    CGPoint touchPoint = self.lineScaler.linePoints[idx];
    
    LineEvent * nearLine = [self.actionDictioary objectForKey:@(TouchEventTapNear)];
    [nearLine performWith:touchPoint index:idx];
}

/**
 * 开始移动
 *
 * @param point 手指触碰屏幕的位置
 */
- (void)chartTouchesMoved:(CGPoint)point
{
    NSUInteger idx = [self.lineScaler indexOfPoint:point];
    CGPoint touchPoint = self.lineScaler.linePoints[idx];
    
    LineEvent * nearLine = [self.actionDictioary objectForKey:@(TouchEventMoveNear)];
    [nearLine performWith:touchPoint index:idx];
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableDictionary, actionDictioary);

@end
