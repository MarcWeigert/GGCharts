//
//  RadarSetAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef RadarSetAbstract_h
#define RadarSetAbstract_h

#import "RadarAbstract.h"
#import "RadarBackAbstract.h"

@protocol RadarSetAbstract <RadarBackAbstract>

@property (nonatomic, strong) NSArray <id <RadarAbstract>> * radarSet;

@end

#endif /* RadarSetAbstract_h */
