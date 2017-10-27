//
//  BarCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "BarCanvasAbstract.h"

@interface BarCanvas : GGCanvas

/**
 * 柱状图配置类
 */
@property (nonatomic, strong) id <BarCanvasAbstract> barDrawConfig;

/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(BarAnimationsType)type duration:(NSTimeInterval)duration;

@end
