//
//  LineBrush.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "LineBrush.h"

typedef NS_ENUM(NSUInteger, BEFORE_SET_TYPE) {
    before_from,
    before_to,
};

@interface LineBrush ()

@property (nonatomic) CGPoint fromPt;

@property (nonatomic) CGPoint toPt;

@property (nonatomic) BEFORE_SET_TYPE beforSet;

@property (nonatomic) CGFloat w;

@property (nonatomic) UIColor *stockColor;

@end

@implementation LineBrush

/**
 * 通过枚举获得frame中的点
 */
- (CGPoint)pointType:(FRAME_VERTICES)type
{
    CGFloat min_x = self.frame.origin.x;
    CGFloat min_y = self.frame.origin.y;
    CGFloat max_x = self.frame.origin.x + self.frame.size.width;
    CGFloat max_y = self.frame.origin.y + self.frame.size.height;
    
    switch (type) {
        case up_left:
            return CGPointMake(min_x, min_y);
        case up_right:
            return CGPointMake(max_x, min_y);
        case low_left:
            return CGPointMake(min_x, max_y);
        case low_right:
            return CGPointMake(max_x, max_y);
        case center:
            return CGPointMake(min_x + self.frame.size.width / 2, min_y + self.frame.size.height / 2);
        default:
            return CGPointZero;
    }
}

- (void)setFromPt:(CGPoint)fromPt
{
    _beforSet = before_from;
    _fromPt = fromPt;
}

- (void)setToPt:(CGPoint)toPt
{
    _beforSet = before_to;
    _toPt = toPt;
}

- (void)setDrawPoint:(CGPoint(^)(CGPoint point))drawPt
{
    if (_beforSet == before_from) {
        _fromPt = drawPt(_fromPt);
    }
    else {
        _toPt = drawPt(_toPt);
    }
}

#pragma mark - 属性

- (LineBrush *(^)(FRAME_VERTICES))from
{
    return ^(FRAME_VERTICES type){
        self.fromPt = [self pointType:type];
        return self;
    };
}

- (LineBrush *(^)(FRAME_VERTICES))to
{
    return ^(FRAME_VERTICES type){
        self.toPt = [self pointType:type];
        return self;
    };
}

- (LineBrush *(^)(CGFloat))leftset
{
    return ^(CGFloat offset){
        
        [self setDrawPoint:^CGPoint(CGPoint point) {
            
            return CGPointMake(point.x - offset, point.y);
        }];
        
        return self;
    };
}

- (LineBrush *(^)(CGFloat))rightset
{
    return ^(CGFloat offset){
        
        [self setDrawPoint:^CGPoint(CGPoint point) {
            
            return CGPointMake(point.x + offset, point.y);
        }];
        
        return self;
    };
}

- (LineBrush *(^)(CGFloat))upset
{
    return ^(CGFloat offset){
        
        [self setDrawPoint:^CGPoint(CGPoint point) {
            
            return CGPointMake(point.x, point.y - offset);
        }];
        
        return self;
    };
}

- (LineBrush *(^)(CGFloat))downset
{
    return ^(CGFloat offset){
        
        [self setDrawPoint:^CGPoint(CGPoint point) {
            
            return CGPointMake(point.x, point.y + offset);
        }];
        
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
    CGPoint from = _fromPt;
    CGPoint to = _toPt;
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
