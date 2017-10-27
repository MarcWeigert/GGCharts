//
//  BaseLineBarChart.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/5.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineBarChart.h"

@interface BaseLineBarChart ()

@end

@implementation BaseLineBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressViewOnGesturer:)];
        _longPress.minimumPressDuration = [self minimumPressDuration];
        [self addGestureRecognizer:_longPress];
    }
    
    return self;
}

/**
 * 长按相应时间
 */
- (NSTimeInterval)minimumPressDuration
{
    return .5f;
}

/** 长按十字星 */
- (void)longPressViewOnGesturer:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint velocity = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self longPressGestureRecognizerStateEnded:velocity];
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self longPressGestureRecognizerStateBegan:velocity];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        [self longPressGestureRecognizerStateChanged:velocity];
    }
}

/**
 * 即将响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateBegan:(CGPoint)point
{
    
}

/**
 * 即将结束响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateEnded:(CGPoint)point
{

}

/**
 * 响应长按手势点变换
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateChanged:(CGPoint)point
{

}

@end
