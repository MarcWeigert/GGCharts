//
//  IOLineBarChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineBarChart.h"
#import "GGCanvas.h"
#import "GGAxisRenderer.h"
#import "BarChartData.h"
#import "GGDataScaler.h"
#import "GGChartGeometry.h"
#import "GGLineRenderer.h"
#import "Colors.h"
#import "CGPathCategory.h"
#import "GGShapeCanvas.h"
#import "GGGridRenderer.h"

#define SET_FRAME(A, B)     A.frame = CGRectMake(0, 0, CGRectGetWidth(B), CGRectGetHeight(B))

#define BAR_SYSTEM_FONT     [UIFont systemFontOfSize:14]
#define BAR_AXIS_FONT       [UIFont systemFontOfSize:12]
#define BAR_SYSTEM_COLOR    [UIColor blackColor]

#define AXIS_C              RGB(140, 154, 163)
#define POS_C               RGB(241, 73, 81)
#define NEG_C               RGB(30, 191, 97)

@interface LineBarChart ()

@property (nonatomic, strong) GGCanvas * backLayer;

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;
@property (nonatomic, strong) GGAxisRenderer * leftAxisRenderer;
@property (nonatomic, strong) GGAxisRenderer * rightAxisRenderer;
@property (nonatomic, strong) GGGridRenderer * gridRenderer;

@property (nonatomic, strong) UILabel * lbTop;
@property (nonatomic, strong) UILabel * lbBottom;

@property (nonatomic, assign) CGRect contentFrame;

@end

@implementation LineBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _backLayer = [[GGCanvas alloc] init];
        SET_FRAME(_backLayer, frame);
        [self.layer addSublayer:_backLayer];
        
        [self defaultChartConfig];
        
        self.contentFrame = CGRectMake(30, 40, frame.size.width - 60, frame.size.height - 90);
        
        _lbTop = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTop.font = _topFont;
        _lbTop.textColor = _topColor;
        [self addSubview:_lbTop];
        
        _lbBottom = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbBottom.font = _bottomFont;
        _lbBottom.textColor = _bottomColor;
        [self addSubview:_lbBottom];
    }
    
    return self;
}

- (void)defaultChartConfig
{
    _yAxisSplit = 2;
    _yAxisformat = @"%.2f";
    
    _topFont = BAR_SYSTEM_FONT;
    _bottomFont = BAR_SYSTEM_FONT;
    _axisFont = BAR_AXIS_FONT;
    
    _axisColor = AXIS_C;
    _topColor = BAR_SYSTEM_COLOR;
    _bottomColor = BAR_SYSTEM_COLOR;
    
    _axisRenderer = [[GGAxisRenderer alloc] init];
    _axisRenderer.color = _axisColor;
    _axisRenderer.strColor = _axisColor;
    _axisRenderer.width = 0.7;
    _axisRenderer.strFont = _axisFont;
    _axisRenderer.drawAxisCenter = YES;
    _axisRenderer.offSetRatio = CGPointMake(-.5f, 0);
    [_backLayer addRenderer:_axisRenderer];
    
    _leftAxisRenderer = [[GGAxisRenderer alloc] init];
    _leftAxisRenderer.color = _axisColor;
    _leftAxisRenderer.strColor = _axisColor;
    _leftAxisRenderer.width = 0.7;
    _leftAxisRenderer.textOffSet = CGSizeMake(-1, 0);
    _leftAxisRenderer.strFont = _axisFont;
    _leftAxisRenderer.offSetRatio = CGPointMake(-1, -.5);
    [_backLayer addRenderer:_leftAxisRenderer];
    
    _rightAxisRenderer = [[GGAxisRenderer alloc] init];
    _rightAxisRenderer.color = _axisColor;
    _rightAxisRenderer.strColor = _axisColor;
    _rightAxisRenderer.width = 0.7;
    _rightAxisRenderer.textOffSet = CGSizeMake(1, 0);
    _rightAxisRenderer.strFont = _axisFont;
    _rightAxisRenderer.offSetRatio = CGPointMake(0, -.5);
    [_backLayer addRenderer:_rightAxisRenderer];
    
    _gridRenderer = [[GGGridRenderer alloc] init];
    _gridRenderer.color = _axisColor;
    _gridRenderer.width = 0.7;
    _gridRenderer.dash = CGSizeMake(2, 2);
    [_backLayer addRenderer:_gridRenderer];
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    SET_FRAME(_backLayer, frame);
}

- (void)setContentFrame:(CGRect)contentFrame
{
    _contentFrame = contentFrame;
    GGAxis axis = GGAxisLineMake(GGBottomLineRect(_contentFrame), 3, CGRectGetWidth(_contentFrame) / _axisTitles.count);
    _axisRenderer.axis = axis;
}

- (void)setAxisTitles:(NSArray *)axisTitles
{
    _axisTitles = axisTitles;
    _axisRenderer.aryString = axisTitles;
    GGAxis axis = GGAxisLineMake(GGBottomLineRect(_contentFrame), 3, CGRectGetWidth(_contentFrame) / _axisTitles.count);
    _axisRenderer.axis = axis;
}

#define Bind

- (void)setAxisFont:(UIFont *)axisFont
{
    _axisFont = axisFont;
    _axisRenderer.strFont = axisFont;
    _leftAxisRenderer.strFont = axisFont;
    _rightAxisRenderer.strFont = axisFont;
}

- (void)setAxisColor:(UIColor *)axisColor
{
    _axisColor = axisColor;
    _axisRenderer.color = axisColor;
}

- (void)setTopColor:(UIColor *)topColor
{
    _topColor = topColor;
    _lbTop.textColor = topColor;
}

- (void)setTopFont:(UIFont *)topFont
{
    _topFont = topFont;
    _lbTop.font = topFont;
}

- (void)setTopTitle:(NSString *)topTitle
{
    _topTitle = topTitle;
    _lbTop.text = topTitle;
    [_lbTop sizeToFit];
}

- (void)setBottomColor:(UIColor *)bottomColor
{
    _bottomColor = bottomColor;
    _lbBottom.textColor = bottomColor;
}

- (void)setBottomFont:(UIFont *)bottomFont
{
    _bottomFont = bottomFont;
    _lbBottom.font = bottomFont;
}

- (void)setBottomTitle:(NSString *)bottomTitle
{
    _bottomTitle = bottomTitle;
    _lbBottom.text = bottomTitle;
    [_lbBottom sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_backLayer setNeedsDisplay];
    
    _lbBottom.frame = CGRectMake(self.frame.size.width - _lbBottom.frame.size.width, self.frame.size.height - _lbBottom.frame.size.height, _lbBottom.frame.size.width, _lbBottom.frame.size.height);
}

#pragma mark - 绘制

- (void)strockBarChart
{
    CGFloat barMax = 0;
    CGFloat barMin = 0;
    [BarData getChartDataAry:_barDataAry max:&barMax min:&barMin];
    CGFloat barBase = [self getBase:barMax min:barMin];
    barMin -= barBase;
    barMax += barBase;
    
    GGAxis leftAxis = GGAxisLineMake(GGLeftLineRect(_contentFrame), 2.5, CGRectGetHeight(_contentFrame) / _yAxisSplit);
    _leftAxisRenderer.axis = leftAxis;
    _leftAxisRenderer.aryString = [self splitWithMax:barMax min:barMin];
    
    [_barDataAry enumerateObjectsUsingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.barScaler.max = barMax;
        obj.barScaler.min = barMin;
        obj.barScaler.rect = _contentFrame;
        obj.barScaler.xRatio = 1.0 / (_barDataAry.count + 1) * (idx + 1);
        [obj drawBarWithCanvas:self.getGGCanvasEqualFrame];
    }];
}

- (void)strockLineChart
{
    CGFloat lineMax = 0;
    CGFloat lineMin = 0;
    [LineData getChartDataAry:_lineDataAry max:&lineMax min:&lineMin];
    
    CGFloat lineBase = [self getBase:lineMax min:lineMin];
    lineMax += lineBase;
    lineMin -= lineBase;
    
    GGAxis rightAxis = GGAxisLineMake(GGRightLineRect(_contentFrame), -2.5, CGRectGetHeight(_contentFrame) / _yAxisSplit);
    _rightAxisRenderer.axis = rightAxis;
    _rightAxisRenderer.aryString = [self splitWithMax:lineMax min:lineMin];
    
    [_lineDataAry enumerateObjectsUsingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.lineScaler.max = lineMax;
        obj.lineScaler.min = lineMin;
        obj.lineScaler.rect = _contentFrame;
        obj.lineScaler.xRatio = 1.0 / (_lineDataAry.count + 1) * (idx + 1);
        [obj drawLineWithCanvas:self.getGGCanvasEqualFrame shapeCanvas:self.getGGCanvasEqualFrame];
    }];
}

- (void)drawChart
{
    [super drawChart];
    
    GGGrid grid = GGGridRectMake(_contentFrame, CGRectGetHeight(_contentFrame) / _yAxisSplit, CGRectGetWidth(_contentFrame));
    _gridRenderer.grid = grid;
    
    if (_barDataAry.count != 0) [self strockBarChart];
    
    if (_lineDataAry.count != 0) [self strockLineChart];
    
    [_backLayer setNeedsDisplay];
}


- (void)updateChart
{
    [self drawChart];

    [_barDataAry enumerateObjectsUsingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.barCanvas pathChangeAnimation:.5f];
    }];
    
    [_lineDataAry enumerateObjectsUsingBlock:^(LineData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj.lineCanvas pathChangeAnimation:.5f];
        [obj.shapeCanvas pathChangeAnimation:.5f];
    }];
}

- (void)addAnimation:(NSTimeInterval)duration
{
    [_barDataAry enumerateObjectsUsingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        CGFloat y = [obj.barScaler getYPixelWithData:obj.barScaler.min];
        
        CAKeyframeAnimation * barAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        barAnimation.duration = duration;
        barAnimation.values = GGPathRectsStretchAnimation(obj.barScaler.barRects, obj.datas.count, y);
        [obj.barCanvas addAnimation:barAnimation forKey:@"barAnimation"];
    }];
    
    [_lineDataAry enumerateObjectsUsingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        CGFloat y = [obj.lineScaler getYPixelWithData:obj.lineScaler.min];
        
        CAKeyframeAnimation * lineAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        lineAnimation.duration = duration;
        lineAnimation.values = GGPathLinesStretchAnimation(obj.lineScaler.linePoints, obj.datas.count, y);
        [obj.lineCanvas addAnimation:lineAnimation forKey:@"lineAnimation"];
        
        CAKeyframeAnimation * pointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pointAnimation.duration = duration;
        pointAnimation.values = GGPathCirclesStretchAnimation(obj.lineScaler.linePoints, 2, obj.datas.count, y);
        [obj.shapeCanvas addAnimation:pointAnimation forKey:@"pointAnimation"];

    }];
    
    CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"opacity"];
    base.fromValue = @0;
    base.toValue = @1;
    base.duration = duration;
    [_backLayer addAnimation:base forKey:@"o"];
}

@end
