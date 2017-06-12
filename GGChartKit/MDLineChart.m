//
//  MDLineChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MDLineChart.h"
#import "Colors.h"
#import "GGDataScaler.h"
#import "GGChartGeometry.h"
#import "CGPathCategory.h"
#import "GGGridRenderer.h"
#import "GGAxisRenderer.h"
#import "GGLineRenderer.h"
#import "GGCircleRenderer.h"
#import "GGStringRenderer.h"
#import "CALayer+GGLayer.h"

#define LINE_LAYER_TAG          1000
#define FILL_LAYER_TAG          2000
#define POINT_LAYER_TAG         3000
#define BACK_LAYER_TAG          4000
#define QUERY_LAYER_TAG         5000

@interface MDLineChart ()

@property (nonatomic, strong) GGAxisRenderer * y_axis;
@property (nonatomic, strong) GGAxisRenderer * x_axis;
@property (nonatomic, strong) GGGridRenderer * grid;

@property (nonatomic, strong) GGLineRenderer * x_query;
@property (nonatomic, strong) GGLineRenderer * y_query;
@property (nonatomic, strong) GGCircleRenderer * c_query;
@property (nonatomic, strong) GGStringRenderer * x_str;
@property (nonatomic, strong) GGStringRenderer * y_str;

@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, assign) CGFloat xSpilt;       ///< x 最小移动点

@end

@implementation MDLineChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self defaultChartConfig];
        
        _y_axis = [[GGAxisRenderer alloc] init];
        _x_axis = [[GGAxisRenderer alloc] init];
        _grid = [[GGGridRenderer alloc] init];
        
#pragma mark - 查价层
        
        _x_query = [[GGLineRenderer alloc] init];
        _x_query.width = 0.5;
        _x_query.color = [UIColor blackColor];
        
        _y_query = [[GGLineRenderer alloc] init];
        _y_query.width = 0.5;
        _y_query.color = [UIColor blackColor];
        
        _c_query = [[GGCircleRenderer alloc] init];
        _c_query.borderWidth = 0;
        _c_query.fillColor = [UIColor blackColor];
        
        _x_str = [[GGStringRenderer alloc] init];
        _x_str.font = [UIFont systemFontOfSize:8];
        _x_str.offSetRatio = CGPointMake(0, -.5);
        _x_str.color = [UIColor blackColor];
        
        _y_str = [[GGStringRenderer alloc] init];
        _y_str.font = [UIFont systemFontOfSize:8];
        _y_str.color = [UIColor blackColor];
        _y_str.offSetRatio = CGPointMake(0, 0);
        _y_str.offset = CGSizeMake(0, 2);
        
        [ChartBack(QUERY_LAYER_TAG) addRenderer:_x_query];
        [ChartBack(QUERY_LAYER_TAG) addRenderer:_y_query];
        [ChartBack(QUERY_LAYER_TAG) addRenderer:_c_query];
        [ChartBack(QUERY_LAYER_TAG) addRenderer:_x_str];
        [ChartBack(QUERY_LAYER_TAG) addRenderer:_y_str];
    }
    
    return self;
}

- (void)defaultChartConfig
{
    _color = __RGB_BLUE;
    _width = 0.7;
    _yAxisformat = @"%.2f";
    _yAxisSplit = 6;
    _axisFont = [UIFont systemFontOfSize:9];
    _xNdiv = 100;
}

- (CGFloat)getBase:(CGFloat)max min:(CGFloat)min
{
    return fabs(max - min) * 0.1;
}

- (NSArray <NSString *> *)splitWithMax:(CGFloat)max min:(CGFloat)min
{
    NSMutableArray * array = [NSMutableArray array];
    CGFloat split = fabs(max - min) / _yAxisSplit;
    
    for (int i = 0; i < _yAxisSplit; i++) {
        
        [array addObject:[NSString stringWithFormat:self.yAxisformat, max - split * i]];
    }
    
    [array addObject:[NSString stringWithFormat:self.yAxisformat, min]];
    
    return array;
}

- (void)strockBackLayer:(CGRect)contentRect max:(CGFloat)max min:(CGFloat)min
{
    GGCanvas * backLayer = ChartBack(BACK_LAYER_TAG);
    
    CGFloat y_spa = CGRectGetHeight(contentRect) / _yAxisSplit;
    GGAxis y_axis_geo = GGAxisLineMake(GGLeftLineRect(contentRect), -2, y_spa);
    _y_axis.axis = y_axis_geo;
    _y_axis.color = [UIColor grayColor];
    _y_axis.width = 0.3;
    _y_axis.strFont = [UIFont systemFontOfSize:8];
    _y_axis.showSep = NO;
    _y_axis.showLine = NO;
    _y_axis.offSetRatio = CGPointMake(0, -1);
    _y_axis.aryString = [self splitWithMax:max min:min];
    [backLayer addRenderer:_y_axis];
    
    _xSpilt = CGRectGetWidth(contentRect) / _dataSet.count;
    CGFloat x_spa = _xSpilt * _xNdiv;
    GGAxis x_axis_geo = GGAxisLineMake(GGBottomLineRect(contentRect), 2, x_spa);
    _x_axis.axis = x_axis_geo;
    _x_axis.color = [UIColor grayColor];
    _x_axis.width = 0.3;
    _x_axis.showLine = NO;
    _x_axis.strFont = [UIFont systemFontOfSize:8];
    [backLayer addRenderer:_x_axis];
    
    NSInteger count = _dataSet.count / _xNdiv;
    NSMutableArray * aryTitle = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        
        [aryTitle addObject:_dataSet[i * _xNdiv].title];
    }
    
    _x_axis.aryString = aryTitle;
    
    GGGrid grid_geo = GGGridRectMake(contentRect, y_spa, x_spa);
    _grid = [[GGGridRenderer alloc] init];
    _grid.grid = grid_geo;
    _grid.width = 0.2;
    _grid.color = [UIColor grayColor];
    _grid.dash = CGSizeMake(2, 2);
    [backLayer addRenderer:_grid];
    
    [backLayer setNeedsDisplay];
}

- (void)strockLineLayer
{
    CGFloat lb_h = [@"1" sizeWithAttributes:@{NSFontAttributeName : _axisFont}].height;
    CGRect drawRect = CGRectMake(1, lb_h, self.frame.size.width - 2, self.frame.size.height - lb_h * 2);
    _contentFrame = drawRect;
    
    CGFloat max;
    CGFloat min;
    [MassChartData masDataAry:_dataSet max:&max min:&min];
    CGFloat base = [self getBase:max min:min];
    max += base;
    min -= base;
    
    [self strockBackLayer:drawRect max:max min:min];
    
    GGShapeCanvas * line_shape = ChartShape(LINE_LAYER_TAG);
    line_shape.lineWidth = _width;
    line_shape.strokeColor = _color.CGColor;
    line_shape.fillColor = [UIColor clearColor].CGColor;
    
    GGShapeCanvas * fill_shape = ChartShape(FILL_LAYER_TAG);
    fill_shape.lineWidth = 0;
    fill_shape.fillColor = [_color colorWithAlphaComponent:0.3].CGColor;
    
    GGShapeCanvas * point_shape = ChartShape(POINT_LAYER_TAG);
    point_shape.lineWidth = 0;
    point_shape.fillColor = __RGB_RED.CGColor;
    
    GGLineChatScaler yScaler = figScaler(max, min, drawRect);
    GGLineChatScaler xScaler = axiScaler(_dataSet.count, drawRect, 0);
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGMutablePathRef pt_ref = CGPathCreateMutable();
    CGMutablePathRef fill_ref = CGPathCreateMutable();
    
    for (int i = 0; i < _dataSet.count; i++) {
        
        // 线
        MassChartData * data = _dataSet[i];
        CGPoint point = CGPointMake(xScaler(i), yScaler(data.value));
        data.dataPoint = point;
        i == 0 ? CGPathMoveToPoint(ref, NULL, point.x, point.y) : CGPathAddLineToPoint(ref, NULL, point.x, point.y);
        i == 0 ? CGPathMoveToPoint(fill_ref, NULL, point.x, point.y) : CGPathAddLineToPoint(fill_ref, NULL, point.x, point.y);
        
        // 圆
        if (data.isKeyNote) {
            GGCircle circle = GGCirclePointMake(point, 1.5);
            GGPathAddCircle(pt_ref, circle);
        }
    }
    
    CGPathAddLineToPoint(fill_ref, NULL, CGRectGetMaxX(drawRect), CGRectGetMaxY(drawRect));
    CGPathAddLineToPoint(fill_ref, NULL, CGRectGetMinX(drawRect), CGRectGetMaxY(drawRect));
    CGPathCloseSubpath(fill_ref);
    
    line_shape.path = ref;
    CGPathRelease(ref);
    
    point_shape.path = pt_ref;
    CGPathRelease(pt_ref);
    
    fill_shape.path = fill_ref;
    CGPathRelease(fill_ref);
    
    [self.layer bringSublayerToFront:ChartBack(QUERY_LAYER_TAG)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger index = (point.x - _contentFrame.origin.x) / _xSpilt;
   
    if (index < 0) index = 0;
    else if (index > _dataSet.count - 1) index = _dataSet.count - 1;
    
    MassChartData * data = _dataSet[index];
    
    GGLine x_line = GGLineMake(CGRectGetMinX(_contentFrame), data.dataPoint.y, CGRectGetMaxX(_contentFrame), data.dataPoint.y);
    _x_query.line = x_line;
    
    GGLine y_line = GGLineMake(data.dataPoint.x, CGRectGetMinY(_contentFrame), data.dataPoint.x, CGRectGetMaxY(_contentFrame));
    _y_query.line = y_line;
    
    GGCircle circle = GGCirclePointMake(data.dataPoint, 1.5);
    _c_query.circle = circle;
    
    _x_str.point = CGPointMake(_contentFrame.origin.x, data.dataPoint.y);
    _x_str.string = [NSString stringWithFormat:@"%.2f", data.value];
    
    _y_str.point = CGPointMake(data.dataPoint.x, CGRectGetMaxY(_contentFrame));
    _y_str.string = data.title;
    
    [ChartBack(QUERY_LAYER_TAG) setNeedsDisplay];
}

- (void)strockChart
{
    [self strockLineLayer];
}

@end


















