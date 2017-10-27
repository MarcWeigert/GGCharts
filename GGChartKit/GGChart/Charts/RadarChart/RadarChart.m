//
//  RadarChart.m
//  GGCharts
//
//  Created by _ | Durex on 17/10/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarChart.h"

@implementation RadarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _radarCanvas = [[RadarCanvas alloc] init];
        _radarCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self.layer addSublayer:_radarCanvas];
    }
    
    return self;
}

- (void)setRadarData:(RadarDataSet *)radarData
{
    _radarData = radarData;
    
    _radarCanvas.radarDrawConfig = (id <RadarAbstract, RadarSetAbstract>)radarData;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _radarCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

- (void)drawRadarChart
{
    [_radarData updateChartConfigs:_radarCanvas.frame];
    [_radarCanvas drawChart];
}

@end
