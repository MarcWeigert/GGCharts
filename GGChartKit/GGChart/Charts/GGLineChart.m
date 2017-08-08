//
//  GGLineChart.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGLineChart.h"
#import "LineCanvas.h"
#import "GridBackCanvas.h"

@interface GGLineChart ()

@property (nonatomic, strong) LineCanvas * lineCanvas;

@property (nonatomic, strong) GridBackCanvas * gridCanvas;

@end

@implementation GGLineChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _gridCanvas = [[GridBackCanvas alloc] init];
        _gridCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self.layer addSublayer:_gridCanvas];
        
        _lineCanvas = [[LineCanvas alloc] init];
        _lineCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self.layer addSublayer:_lineCanvas];
    }
    
    return self;
}

- (void)setLineDataSet:(LineDataSet *)lineDataSet
{
    _lineDataSet = lineDataSet;
    _lineCanvas.lineDrawConfig = (id <LineCanvasAbstract>)lineDataSet;
    _gridCanvas.gridDrawConfig = (id <GridAbstract>)lineDataSet;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _lineCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    _gridCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

- (void)drawLineChart
{
    [_lineDataSet drawOnLineCanvas:_lineCanvas];
    [_lineCanvas drawChart];
    
    [_gridCanvas drawChart];
}

- (void)startAnimation:(NSTimeInterval)duration
{
    [_lineCanvas startAnimation:duration];
}

@end
