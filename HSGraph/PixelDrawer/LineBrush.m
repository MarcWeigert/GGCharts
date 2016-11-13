//
//  LineBrush.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "LineBrush.h"

@interface LineBrush ()

@property (nonatomic) CGPoint fromPt;

@property (nonatomic) CGPoint toPt;

@property (nonatomic) CGFloat w;

@property (nonatomic) UIColor *stockColor;

@end

@implementation LineBrush

#pragma mark - 属性

- (LineBrush *(^)(CGPoint offset))offset
{
    return ^(CGPoint offset) {
    
        _fromPt = CGPointMake(_fromPt.x + offset.x, _fromPt.y + offset.y);
        _toPt = CGPointMake(_toPt.x + offset.x, _toPt.y + offset.y);
        
        return self;
    };
}

- (LineBrush *(^)(CGFloat x))x
{
    return ^(CGFloat x) {
    
        _fromPt = CGPointMake(_fromPt.x + x, _fromPt.y);
        _toPt = CGPointMake(_toPt.x + x, _toPt.y);
        
        return self;
    };
}

- (LineBrush *(^)(CGFloat y))y
{
    return ^(CGFloat y) {
    
        _fromPt = CGPointMake(_fromPt.x, _fromPt.y + y);
        _toPt = CGPointMake(_toPt.x, _toPt.y + y);
        
        return self;
    };
}

- (LineBrush *(^)(CGPoint from))from
{
    return ^(CGPoint from){
        
        _fromPt = from;
        
        return self;
    };
}

- (LineBrush *(^)(CGPoint to))to
{
    return ^(CGPoint to){
        
        _toPt = to;
        
        return self;
    };
}

- (LineBrush *(^)(CGPoint from, CGPoint to))line
{
    return ^(CGPoint f, CGPoint t){
    
        _fromPt = f;
        _toPt = t;
        
        return self;
    };
}

- (LineBrush *(^)(CGFloat))width
{
    return ^(CGFloat width){
        
        _w = width;
        
        return self;
    };
}

- (LineBrush *(^)(UIColor *))color
{
    return ^(UIColor *color){
        
        _stockColor = color;
        
        return self;
    };
}

#pragma mark - 构造

/** 构造绘制函数放入数组 */
- (void (^)())draw
{
    __weak UIColor *color = _stockColor;
    CGPoint from = CGPointMake(_fromPt.x + self.drawFrame.origin.x, _fromPt.y + self.drawFrame.origin.y);
    CGPoint to = CGPointMake(_toPt.x + self.drawFrame.origin.x, _toPt.y + self.drawFrame.origin.y);
    CGFloat width = _w;
    
    void (^drawBlock)(CGContextRef) = ^(CGContextRef context){
    
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, width);
        CGContextMoveToPoint(context, from.x, from.y);
        CGContextAddLineToPoint(context, to.x, to.y);
        CGContextStrokePath(context);
    };
    
    return ^() {
    
        [self.array addObject:drawBlock];
    };
}

@end
