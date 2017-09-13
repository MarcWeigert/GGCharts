//
//  BaseLineBarChart.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/5.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineBarChart.h"

@interface BaseLineBarChart ()

@property (nonatomic, strong) UILongPressGestureRecognizer * longPress;

@end

@implementation BaseLineBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressViewOnGesturer:)];
        [self addGestureRecognizer:_longPress];
    }
    
    return self;
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
