//
//  RadarData.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarData.h"
#import "RadarAbstract.h"

@interface RadarData () <RadarAbstract>
{
    DRadarScaler * gg_radarScaler;
}

@end

@implementation RadarData

- (CGPoint *)points
{
    return self.radarScaler.radarPoints;
}

- (DRadarScaler *)radarScaler
{
    if (gg_radarScaler == nil) {
        
        gg_radarScaler = [[DRadarScaler alloc] init];
    }
    
    return gg_radarScaler;
}

@end
