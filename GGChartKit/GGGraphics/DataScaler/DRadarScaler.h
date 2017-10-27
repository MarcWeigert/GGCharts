//
//  DRadarScaler.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGChartGeometry.h"

@interface DRadarScaler : NSObject

/**
 * 雷达图比例
 */
@property (nonatomic, strong) NSArray <NSNumber *> * radarProportions;

/**
 * 雷达结构体
 */
@property (nonatomic, assign) GGPolygon polygon;

/**
 * 雷达图关键点
 */
@property (nonatomic, readonly) CGPoint * radarPoints;

/** 
 * 更新点坐标 
 */
- (void)updateScaler;

@end
