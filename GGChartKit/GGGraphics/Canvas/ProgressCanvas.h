//
//  ProgressCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 17/10/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "ProgressAbstract.h"

@interface ProgressCanvas : GGCanvas

/**
 * 进度条配置
 */
@property (nonatomic, strong) id <ProgressAbstract> progressAbstract;

/**
 * 启动动画
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration;

@end
