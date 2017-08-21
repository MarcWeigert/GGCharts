//
//  LineAnimation.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineAnimation.h"
#import "DLineScaler.h"
#import "CGPathCategory.h"

@implementation LineAnimation

+ (void)addLineRectFoldAnimationWithDuration:(NSTimeInterval)duration
                              lineShapeLater:(CAShapeLayer *)shapeLayer
                                  lineScaler:(DLineScaler *)scaler
{
    CAKeyframeAnimation * fillAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = duration;
    fillAnimation.values = GGPathFillLinesUpspringAnimation(scaler.linePoints, scaler.pointSize, scaler.aroundY);
    [shapeLayer addAnimation:fillAnimation forKey:@"fillAnimation"];
}

+ (void)addLineFoldAnimationWithDuration:(NSTimeInterval)duration
                          lineShapeLater:(CAShapeLayer *)shapeLayer
                              lineScaler:(DLineScaler *)scaler
{
    CAKeyframeAnimation * lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    lineAnimation.duration = duration;
    lineAnimation.values = GGPathLinesUpspringAnimation(scaler.linePoints, scaler.pointSize, scaler.aroundY);
    [shapeLayer addAnimation:lineAnimation forKey:@"lineAnimation"];
}

+ (void)addLineCircleAnimationWithDuration:(NSTimeInterval)duration
                            lineShapeLater:(CAShapeLayer *)shapeLayer
                                lineScaler:(DLineScaler *)scaler
                                fromRadius:(CGFloat)fromRadius
                                  toRadius:(CGFloat)toRadius
{
    CAKeyframeAnimation * pointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pointAnimation.duration = duration;
    pointAnimation.values = GGPathCirclesUpspringAnimation(scaler.linePoints, fromRadius, scaler.pointSize, scaler.aroundY);
    [shapeLayer addAnimation:pointAnimation forKey:@"pointAnimation"];
}

@end
