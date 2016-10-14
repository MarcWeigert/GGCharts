//
//  RoundShape.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/13.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface RoundShape : NSObject

/** 设置填充颜色 */
- (RoundShape * (^)(UIColor *color))fillColor;

/** 设置边缘颜色 */
- (RoundShape * (^)(UIColor *color))edgeColor;

/** 设置边缘颜色 */
- (RoundShape * (^)(NSArray *drawAry, NSInteger drawIndex))drawAry;

/** 设置边缘颜色 */
- (RoundShape * (^)(CGPoint center))centerPoint;

/** 设置边缘颜色 */
- (RoundShape * (^)(CGFloat width))edgeWidth;

/** 设置边缘颜色 */
- (RoundShape * (^)(CGFloat radius))radius;

/** 初始化 */
- (id)initWithLayer:(CALayer *)layer;

/** 绘制传入的层 */
- (NSArray *)stockLayer:(CAShapeLayer *)shapeLayer;

@end
