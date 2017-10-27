//
//  BaseLineBarChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/5.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseLineBarChart : UIView

/**
 * 手势
 */
@property (nonatomic, strong) UILongPressGestureRecognizer * longPress;

/**
 * 长按相应时间
 */
- (NSTimeInterval)minimumPressDuration;

/**
 * 即将响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateBegan:(CGPoint)point;

/**
 * 即将结束响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateEnded:(CGPoint)point;

/**
 * 响应长按手势点变换
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateChanged:(CGPoint)point;

@end
