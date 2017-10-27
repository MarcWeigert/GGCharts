//
//  RadarIndicatorData.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarIndicatorData.h"

@implementation RadarIndicatorData

+ (RadarIndicatorData *)indicatorWithTitle:(NSString *)title max:(CGFloat)max
{
    RadarIndicatorData * radar = [[RadarIndicatorData alloc] init];
    radar.title = title;
    radar.max = max;
    return radar;
}

@end
