//
//  LineAnimation.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLineScaler;

@interface LineAnimation : NSObject

+ (void)addLineRectFoldAnimationWithDuration:(NSTimeInterval)duration
                              lineShapeLater:(CAShapeLayer *)shapeLayer
                                  lineScaler:(DLineScaler *)scaler;

+ (void)addLineFoldAnimationWithDuration:(NSTimeInterval)duration
                          lineShapeLater:(CAShapeLayer *)shapeLayer
                              lineScaler:(DLineScaler *)scaler;

+ (void)addLineCircleAnimationWithDuration:(NSTimeInterval)duration
                            lineShapeLater:(CAShapeLayer *)shapeLayer
                                lineScaler:(DLineScaler *)scaler
                                fromRadius:(CGFloat)fromRadius
                                  toRadius:(CGFloat)toRadius;

@end
