//
//  GGShapeCanvas.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GGShapeCanvas : CAShapeLayer

/**
 * 旧路径
 */
@property (nonatomic, assign) CGPathRef oldRef;

/**
 * 路径变换动画
 *
 * @param duration 动画时间
 */
- (void)pathChangeAnimation:(NSTimeInterval)duration;

@end
