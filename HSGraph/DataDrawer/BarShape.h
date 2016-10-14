//
//  BarShape.h
//  HCharts
//
//  Created by _ | Durex on 16/6/18.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface BarShape : NSObject

/** 初始化 */
- (id)initWithLayer:(CALayer *)layer;

/** 绘制传入的层 */
- (NSArray *)stockLayer:(CAShapeLayer *)shapeLayer;

/** 设置绘制数组 */
- (BarShape * (^)(NSArray <NSNumber *> *drawAry))drawAry;

/** 设置线颜色 */
- (BarShape * (^)(UIColor *color))color;

/** 线宽 */
- (BarShape * (^)(CGFloat width))witdth;

/** 组 */
- (BarShape * (^)(NSInteger index))index;

/** 总组数 */
- (BarShape * (^)(NSInteger row))row;

@end
