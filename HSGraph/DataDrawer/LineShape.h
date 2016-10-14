//
//  LineShape.h
//  HCharts
//
//  Created by 黄舜 on 16/6/16.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface LineShape : NSObject

/** 初始化 */
- (id)initWithLayer:(CALayer *)layer;

/** 绘制传入的层 */
- (NSArray *)stockLayer:(CAShapeLayer *)shapeLayer;

/** 设置绘制数组 */
- (LineShape * (^)(NSArray <NSNumber *> *drawAry))drawAry;

/** 设置线颜色 */
- (LineShape * (^)(UIColor *color))color;

/** 填充颜色 */
- (LineShape * (^)(UIColor *color))fillColor;

/** 线宽 */
- (LineShape * (^)(CGFloat width))witdth;

/** 围绕某一个价位填充 */
- (LineShape * (^)(CGFloat rounder))rounder;

/** 组 */
- (LineShape * (^)(NSInteger index))index;

/** 总组数 */
- (LineShape * (^)(NSInteger row))row;

@end
