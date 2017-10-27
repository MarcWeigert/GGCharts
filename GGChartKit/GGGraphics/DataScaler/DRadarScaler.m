//
//  DRadarScaler.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "DRadarScaler.h"

@implementation DRadarScaler

- (void)setPolygon:(GGPolygon)polygon
{
    _polygon = polygon;
    CGPoint * points = malloc(polygon.side * sizeof(CGPoint));
    [self updateRadarPoints:points];
}

- (void)updateRadarPoints:(CGPoint *)linePoints
{
    if (_radarPoints != nil) {
        
        free(_radarPoints);
    }
    
    _radarPoints = linePoints;
}

- (void)dealloc
{
    if (_radarPoints != nil) {
        
        free(_radarPoints);
        _radarPoints = nil;
    }
}

/** 更新点坐标 */
- (void)updateScaler
{
    NSInteger count = _polygon.side > _radarProportions.count ? _radarProportions.count : _polygon.side;
    
    for (NSInteger i = 0; i < count; i++) {
        
        GGLine line = GGPolygonGetLine(_polygon, i);
        line = GGLineMoveStart(line, GGLengthLine(line) * _radarProportions[i].floatValue);
        _radarPoints[i] = CGPointMake(line.start.x, line.start.y);
    }
}

@end
