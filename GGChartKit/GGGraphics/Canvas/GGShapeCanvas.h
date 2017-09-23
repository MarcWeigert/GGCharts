//
//  GGShapeCanvas.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GGShapeCanvas : CAShapeLayer

- (void)pathChangeAnimation:(NSTimeInterval)duration;

- (CAAnimation *)animationForName:(NSString *)name;

- (void)startAnimation:(NSString *)name duration:(NSTimeInterval)duration;

- (CAKeyframeAnimation *)registerKeyAnimation:(NSString *)key name:(NSString *)name values:(NSArray *)values;

@end
