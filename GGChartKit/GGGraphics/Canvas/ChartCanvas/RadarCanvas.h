//
//  RadarCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "RadarAbstract.h"
#import "RadarSetAbstract.h"

@interface RadarCanvas : GGCanvas

@property (nonatomic, strong) id <RadarSetAbstract> radarDrawConfig;     ///< 绘制配置

@property (nonatomic, strong, readonly) GGCanvas * topCanvas;

/** 更新子视图 */
- (void)updateSubLayers;

/** 动画 */
- (void)addAnimationWithDuration:(NSTimeInterval)time;

/** 增加渲染器 */
- (void)addGGNumberRenderer:(GGNumberRenderer *)renderer;

/** 清除渲染器 */
- (void)removeAllGGNumberRenderer;

@end
