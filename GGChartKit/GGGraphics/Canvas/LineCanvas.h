//
//  LineCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "LineCanvasAbstract.h"

@interface LineCanvas : GGCanvas

/**
 * 折线配置接口
 */
@property (nonatomic, strong) id <LineCanvasAbstract> lineDrawConfig;

/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(LineAnimationsType)type duration:(NSTimeInterval)duration;

@end
