//
//  RadarSetAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef RadarSetAbstract_h
#define RadarSetAbstract_h

#import "RadarAbstract.h"
#import "RadarBackAbstract.h"

@protocol RadarSetAbstract <RadarBackAbstract>

/**
 * 雷达图设置数组
 */
@property (nonatomic, strong) NSArray <id <RadarAbstract>> * radarSet;

@end

#endif /* RadarSetAbstract_h */
