//
//  QueryCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "QueryAbstract.h"

@interface QueryCanvas : GGCanvas

/**
 * 查价配置
 */
@property (nonatomic, strong) id <QueryAbstract> queryDrawConfig;

/**
 * 更新查价层
 * 
 * touchPoint 显示中心点
 */
- (void)updateWithPoint:(CGPoint)touchPoint;

@end
