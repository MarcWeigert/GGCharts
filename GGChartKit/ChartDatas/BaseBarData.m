//
//  BaseBarData.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseBarData.h"
#import "GGChartDefine.h"
#import "ChartBaseEvent.h"

@interface BarEvent : ChartBaseEvent

- (void)performWith:(CGRect)rect index:(NSUInteger)index;

@end

@implementation BarEvent

- (void)performWith:(CGRect)rect index:(NSUInteger)index
{
    void (*barFunc)(id target, SEL action, CGRect rect, NSUInteger idx) = self.imp;
    barFunc(self.eventTarget, self.eventAction, rect, index);
}

@end

#pragma mark - BarData

@interface BaseBarData ()

@property (nonatomic, strong) NSMutableDictionary * actionDictioary;

@end

@implementation BaseBarData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.width = 25;
    }
    
    return self;
}

- (void)setWidth:(CGFloat)width
{
    [super setWidth:width];
    
    self.barScaler.barWidth = width;
}

- (void)setDatas:(NSArray<NSNumber *> *)datas
{
    [super setDatas:datas];
    
    self.barScaler.max = self.lineScaler.max;
    self.barScaler.min = self.lineScaler.min > 0 ? 0 : self.lineScaler.min;
    self.barScaler.dataAry = datas;
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
    BarEvent * event = [BarEvent eventWithTarget:target action:action];
    [self.actionDictioary setObject:event forKey:@(controlEvents)];
}

/**
 * 开始触摸
 *
 * @param point 手指触碰屏幕的位置
 */
- (void)chartTouchesBegan:(CGPoint)point
{
    NSUInteger idx = [self.barScaler indexOfPoint:point];
    CGRect rect = self.barScaler.barRects[idx];

    BarEvent * nearBar = [self.actionDictioary objectForKey:@(GGTouchClickNearShape)];
    BarEvent * inBar = [self.actionDictioary objectForKey:@(GGTouchClickInShape)];
    [nearBar performWith:rect index:idx];
    
    if (CGRectContainsPoint(rect, point)) {
        
        [inBar performWith:rect index:idx];
    }
}

/**
 * 开始移动
 *
 * @param point 手指触碰屏幕的位置
 */
- (void)chartTouchesMoved:(CGPoint)point
{
    NSUInteger idx = [self.barScaler indexOfPoint:point];
    CGRect rect = self.barScaler.barRects[idx];
    
    BarEvent * nearBar = [self.actionDictioary objectForKey:@(GGTouchMoveNearShape)];
    BarEvent * inBar = [self.actionDictioary objectForKey:@(GGTouchMoveInShape)];
    [nearBar performWith:rect index:idx];
    
    if (CGRectContainsPoint(rect, point)) {
        
        [inBar performWith:rect index:idx];
    }
}

#pragma mark - Lazy

GGLazyGetMethod(DBarScaler, barScaler);

GGLazyGetMethod(NSMutableDictionary, actionDictioary);

@end
