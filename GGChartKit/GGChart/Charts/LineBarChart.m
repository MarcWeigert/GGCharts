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
#import "GGChartGeometry.h"
#import "GGLineRenderer.h"
#import "Colors.h"
#import "CGPathCategory.h"
#import "GGShapeCanvas.h"
#import "GGGridRenderer.h"
#import "NSArray+Stock.h"

#define SET_FRAME(A, B)     A.frame = CGRectMake(0, 0, CGRectGetWidth(B), CGRectGetHeight(B))

#define BAR_SYSTEM_FONT     [UIFont systemFontOfSize:14]
#define BAR_AXIS_FONT       [UIFont systemFontOfSize:12]
#define BAR_SYSTEM_COLOR    [UIColor blackColor]

#define AXIS_C              RGB(140, 154, 163)

@interface LineBarChart ()

@property (nonatomic, strong) GGCanvas * backLayer;

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;
@property (nonatomic, strong) GGAxisRenderer * leftAxisRenderer;
@property (nonatomic, strong) GGAxisRenderer * rightAxisRenderer;
@property (nonatomic, strong) GGGridRenderer * gridRenderer;

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
        
        _lbTop = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTop.font = BAR_SYSTEM_FONT;
        _lbTop.textColor = BAR_SYSTEM_COLOR;
        _lbTop.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbTop];
        
        _lbBottom = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbBottom.font = BAR_SYSTEM_FONT;
        _lbBottom.textColor = BAR_SYSTEM_COLOR;
        _lbBottom.textAlignment = NSTextAlignmentRight;
        [self addSubview:_lbBottom];
        
        self.insets = UIEdgeInsetsMake(30, 40, 35, 40);
    }
    
    return self;
}

/**
 * 手指轻触视图
 *
 * @param point 点击屏幕的点
 */
- (void)onTapView:(CGPoint)point
{
    [_barDataAry enumerateObjectsUsingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj chartTouchesBegan:point];
    }];
    
    [_lineDataAry enumerateObjectsUsingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj chartTouchesBegan:point];
    }];
}

/**
 * 手指移动
 *
 * @param point 点击屏幕的点
 */
- (void)onPanView:(CGPoint)point
{
    [_barDataAry enumerateObjectsUsingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj chartTouchesMoved:point];
    }];
    
    [_lineDataAry enumerateObjectsUsingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj chartTouchesMoved:point];
    }];
}

- (void)defaultChartConfig
{
    _yAxisSplit = 2;
    _yAxisformat = @"%.2f";
    
    _axisColor = AXIS_C;
    _axisFont = BAR_SYSTEM_FONT;
    
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
        
        NSString * str_t = [NSString stringWithFormat:self.yAxisformat, max - split * i];
        
        if (_attachedString.length) {
            
            str_t = [NSString stringWithFormat:@"%@%@", str_t, _attachedString];
        }
        
        [array addObject:str_t];
    }
    
    NSString * str_t = [NSString stringWithFormat:self.yAxisformat, min];
    
    if (_attachedString.length) {
        
        str_t = [NSString stringWithFormat:@"%@%@", str_t, _attachedString];
    }
    
    [array addObject:str_t];
    
    return array;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    SET_FRAME(_backLayer, frame);
}

- (void)setXAxisTitles:(NSArray *)xAxisTitles
{
    _xAxisTitles = xAxisTitles;
    _axisRenderer.aryString = xAxisTitles;
    GGAxis axis = GGAxisLineMake(GGBottomLineRect(_contentFrame), 3, CGRectGetWidth(_contentFrame) / _xAxisTitles.count);
    _axisRenderer.axis = axis;
}

#define Bind

- (void)setInsets:(UIEdgeInsets)insets
{
    _insets = insets;
    CGRect sub_rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _contentFrame = UIEdgeInsetsInsetRect(sub_rect, insets);
    GGAxis axis = GGAxisLineMake(GGBottomLineRect(_contentFrame), 3, CGRectGetWidth(_contentFrame) / _xAxisTitles.count);
    _axisRenderer.axis = axis;
}

- (void)setGridLineWidth:(CGFloat)gridLineWidth
{
    _gridLineWidth = gridLineWidth;
    _gridRenderer.width = gridLineWidth;
}

- (void)setIsNeedDash:(BOOL)isNeedDash
{
    _isNeedDash = isNeedDash;
    _gridRenderer.dash = isNeedDash ? CGSizeMake(2, 2) : CGSizeZero;
}

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_lbTop sizeToFit];
    [_lbBottom sizeToFit];
    
    _lbTop.frame = CGRectMake(0, 0, self.frame.size.width, _lbTop.frame.size.height);
    _lbBottom.frame = CGRectMake(0, self.frame.size.height - _lbBottom.frame.size.height, self.frame.size.width, _lbBottom.frame.size.height);
}

#pragma mark - 绘制

- (void)strockBarChart
{
    NSMutableArray * datasArray = [NSMutableArray array];
    
    [_barDataAry enumerateObjectsUsingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        [datasArray addObject:obj.datas];
    }];
    
    // 堆叠
    if (_barPile) { datasArray = [datasArray aryAddUp]; }
    
    CGFloat barMax = 0;
    CGFloat barMin = 0;
    [datasArray getTwoDimensionaMax:&barMax min:&barMin selGetter:@selector(doubleValue) base:.2f];
    
    GGAxis leftAxis = GGAxisLineMake(GGLeftLineRect(_contentFrame), 2.5, CGRectGetHeight(_contentFrame) / _yAxisSplit);
    _leftAxisRenderer.axis = leftAxis;
    _leftAxisRenderer.aryString = [self splitWithMax:barMax min:barMin];
    
    [_barDataAry enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BarData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.barScaler.dataAry = datasArray[idx];
        obj.barScaler.max = barMax;
        obj.barScaler.min = barMin;
        obj.barScaler.rect = _contentFrame;
        obj.barScaler.xRatio = _barPile ? .5f : 1.0 / (_barDataAry.count + 1) * (idx + 1);
        obj.attachedString = _attachedString;
        [obj drawBarWithCanvas:self.getGGCanvasEqualFrame];
        
        if (obj.isShowString) {
            
            [obj drawStringWithCanvas:self.getGGStaticCanvasEqualFrame];
        }
    }];
}

- (void)strockLineChart
{
    NSMutableArray * datasArray = [NSMutableArray array];
    
    [_lineDataAry enumerateObjectsUsingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        [datasArray addObject:obj.datas];
    }];
    
    // 堆叠
    if (_linePile) { datasArray = [datasArray aryAddUp]; }
    
    CGFloat lineMax = 0;
    CGFloat lineMin = 0;
    [datasArray getTwoDimensionaMax:&lineMax min:&lineMin selGetter:@selector(doubleValue) base:.2f];
    
    GGAxis leftAxis = GGAxisLineMake(GGLeftLineRect(_contentFrame), 2.5, CGRectGetHeight(_contentFrame) / _yAxisSplit);
    GGAxis rightAxis = GGAxisLineMake(GGRightLineRect(_contentFrame), -2.5, CGRectGetHeight(_contentFrame) / _yAxisSplit);
    
    GGAxisRenderer * drawAxis = _barDataAry.count > 0 ? _rightAxisRenderer : _leftAxisRenderer;
    drawAxis.axis = _barDataAry.count > 0 ? rightAxis : leftAxis;
    drawAxis.aryString = [self splitWithMax:lineMax min:lineMin];
    
    [_lineDataAry enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.lineScaler.dataAry = datasArray[idx];
        obj.lineScaler.max = lineMax;
        obj.lineScaler.min = lineMin;
        obj.lineScaler.rect = _contentFrame;
        obj.attachedString = _attachedString;
        obj.lineScaler.xRatio = _linePile ? .5f : 1.0 / (_lineDataAry.count + 1) * (idx + 1);
        
        GGShapeCanvas * line = self.getGGCanvasEqualFrame;
        GGShapeCanvas * shape = obj.isShowShape ? self.getGGCanvasEqualFrame : nil;
        [obj drawLineWithCanvas:line shapeCanvas:shape];
        
        if (obj.isShowString) {
            
            [obj drawStringWithCanvas:self.getGGStaticCanvasEqualFrame];
        }
    }];
}

- (void)drawChart
{
    [super drawChart];
    
    CGFloat xAxisSplit = _isNeedSplitX ? CGRectGetWidth(_contentFrame) / _xAxisTitles.count : CGRectGetWidth(_contentFrame);
    GGGrid grid = GGGridRectMake(_contentFrame, CGRectGetHeight(_contentFrame) / _yAxisSplit, xAxisSplit);
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
