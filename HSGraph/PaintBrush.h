//
//  Brush.h
//  HCharts
//
//  Created by 黄舜 on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface PaintBrush : NSObject

@property (nonatomic) UIColor *stockClr;

@property (nonatomic) UIColor *fillClr;

@property (nonatomic) UIFont *font;

@property (nonatomic) CGFloat width;

@property (nonatomic, readonly) NSArray *brushAry;

- (void)drawEllipseWithPoint:(CGPoint)point radius:(CGFloat)radius;

/** 根据起始点重点绘制一条线 */
- (void)drawStart:(CGPoint)start end:(CGPoint)end;

/** 在点的中心绘制文字 */
- (void)drawTxt:(NSString *)txt at:(CGPoint)point;

/** 点的左边绘制文字 */
- (void)drawTxt:(NSString *)txt atLeft:(CGPoint)point;

/** 点的右边绘制文字 */
- (void)drawTxt:(NSString *)txt atRight:(CGPoint)point;

/** 点的底部绘制文字 */
- (void)drawTxt:(NSString *)txt atBottom:(CGPoint)point;

@end
