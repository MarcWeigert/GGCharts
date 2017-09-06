//
//  QueryCanvas.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "QueryAbstract.h"

@interface QueryCanvas : GGCanvas

@property (nonatomic, strong) id <QueryAbstract> queryDrawConfig;       ///< 查价配置

/**
 * 更新查价层
 * 
 * touchPoint 显示中心点
 */
- (void)updateWithPoint:(CGPoint)touchPoint;

@end
