//
//  NTPieChart.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/10.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NTPieChart.h"
#import "GGChartGeometry.h"
#import "CGPathCategory.h"

#define PIE_ANIMATION_FRAME           1000

@interface NTPieChart ()

@end

@implementation NTPieChart

- (void)strockChart
{
    if (_sectorAry.count) [self strockSectorChart];
    
    if (_annularAry.count) [self strockAnnularChart];
}

- (void)strockSectorChart
{
    [PieChartData pieAry:_sectorAry enumerateObjectsUsingBlock:^(CGFloat arc, CGFloat transArc, PieChartData *data, NSUInteger idx) {
        
        GGShapeCanvas * shape = ChartPie(idx);
        shape.fillColor = data.color.CGColor;
        shape.strokeColor = data.color.CGColor;
        shape.lineWidth = 0;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPoint center = CGPointMake(shape.frame.size.width / 2, shape.frame.size.width / 2);
        GGSector sector = GGSectorCenterMake(center, 0, arc, _sectorRadius);
        GGPathAddSector(ref, sector);
        shape.path = ref;
        CGPathRelease(ref);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        shape.affineTransform = CGAffineTransformRotate(transform, transArc);
        
        [shape registerKeyAnimation:@"path"
                               name:@"pie_move"
                             values:GGPathAnimationArrayFor(sector, PIE_ANIMATION_FRAME)];
        
        [shape registerKeyAnimation:@"transform.scale"
                               name:@"pie_scale"
                             values:@[@0, @1]];
        
        [shape registerKeyAnimation:@"transform.rotation"
                               name:@"pie_rotation"
                             values:@[@0, @(transArc)]];
        
        [self.layer addSublayer:shape];
    }];
}

- (void)strockAnnularChart
{
    [PieChartData pieAry:_annularAry enumerateObjectsUsingBlock:^(CGFloat arc, CGFloat transArc, PieChartData *data, NSUInteger idx) {
        
        GGShapeCanvas * shape = ChartPie(idx + 1000);
        shape.fillColor = data.color.CGColor;
        shape.strokeColor = data.color.CGColor;
        shape.lineWidth = 0;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPoint center = CGPointMake(shape.frame.size.width / 2, shape.frame.size.width / 2);
        GGAnnular annular = GGAnnularCenterMake(center, 0, arc, _annularRadius, _annularWidth);
        GGPathAddAnnular(ref, annular);
        shape.path = ref;
        CGPathRelease(ref);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        shape.affineTransform = CGAffineTransformRotate(transform, transArc);
        
        [shape registerKeyAnimation:@"path"
                               name:@"annular_move"
                             values:GGPathAnnularAnimationArrayFor(annular, PIE_ANIMATION_FRAME)];
        
        [shape registerKeyAnimation:@"transform.scale"
                               name:@"annular_scale"
                             values:@[@0, @1]];
        
        [shape registerKeyAnimation:@"transform.rotation"
                               name:@"annular_rotation"
                             values:@[@0, @(transArc)]];
        
        [self.layer addSublayer:shape];
    }];
}

- (void)addAnimationWithDuration:(NSTimeInterval)duration
{
    for (NSInteger i = 0; i < _sectorAry.count; i++) {
        
        GGShapeCanvas * shape = ChartPie(i);
        
        [shape startAnimation:@"pie_move" duration:duration];
        [shape startAnimation:@"pie_scale" duration:duration];
        [shape startAnimation:@"pie_rotation" duration:duration];
    }
    
    for (NSInteger i = 0; i < _annularAry.count; i++) {
        
        GGShapeCanvas * shape = ChartPie(i + 1000);
        
        [shape startAnimation:@"annular_move" duration:duration];
        [shape startAnimation:@"annular_scale" duration:duration];
        [shape startAnimation:@"annular_rotation" duration:duration];
    }
}




@end
