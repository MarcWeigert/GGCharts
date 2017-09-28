//
//  PieCanvas.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
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

@end
