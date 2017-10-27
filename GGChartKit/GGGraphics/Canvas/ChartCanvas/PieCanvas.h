//
//  PieCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "PieCanvasAbstract.h"
#import "PieAnimationManager.h"

@interface PieCanvas : GGCanvas

/**
 * 扇形图配置类
 */
@property (nonatomic, strong) id <PieCanvasAbstract> pieCanvasConfig;

/**
 * 动画管理类
 */
@property (nonatomic, strong) PieAnimationManager * pieAnimation;

/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(PieAnimationType)pieAnimationType duration:(NSTimeInterval)duration;

@end
