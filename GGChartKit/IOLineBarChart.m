//
//  IOLineBarChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "IOLineBarChart.h"
#import "GGCanvas.h"
#import "GGAxisRenderer.h"
#import "BarChartData.h"
#import "DrawMath.h"
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

@interface IOLineBarChart ()

@property (nonatomic, strong) GGShapeCanvas * barLayer;
@property (nonatomic, strong) GGShapeCanvas * lineLayer;
@property (nonatomic, strong) GGShapeCanvas * pointLayer;
@property (nonatomic, strong) GGCanvas * backLayer;

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;
@property (nonatomic, strong) GGAxisRenderer * leftAxisRenderer;
@property (nonatomic, strong) GGAxisRenderer * rightAxisRenderer;
@property (nonatomic, strong) GGGridRenderer * gridRenderer;

@property (nonatomic, strong) UILabel * lbTop;
@property (nonatomic, strong) UILabel * lbBottom;

@property (nonatomic, assign) CGRect contentFrame;

@end

@implementation IOLineBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _backLayer = [[GGCanvas alloc] init];
        SET_FRAME(_backLayer, frame);
        [self.layer addSublayer:_backLayer];
        
        _barLayer = [[GGShapeCanvas alloc] init];
        SET_FRAME(_barLayer, frame);
        [self.layer addSublayer:_barLayer];
        
        _lineLayer = [[GGShapeCanvas alloc] init];
        SET_FRAME(_lineLayer, frame);
        [self.layer addSublayer:_lineLayer];
        
        _pointLayer = [[GGShapeCanvas alloc] init];
        SET_FRAME(_pointLayer, frame);
        [self.layer addSublayer:_pointLayer];
        
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
    _barWidth = 20;
    
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
    [_backLayer addRenderer:_axisRenderer];
    
    _leftAxisRenderer = [[GGAxisRenderer alloc] init];
    _leftAxisRenderer.color = _axisColor;
    _leftAxisRenderer.strColor = _axisColor;
    _leftAxisRenderer.width = 0.7;
    _leftAxisRenderer.textOffSet = CGSizeMake(-1, 0);
    _leftAxisRenderer.strFont = _axisFont;
    [_backLayer addRenderer:_leftAxisRenderer];
    
    _rightAxisRenderer = [[GGAxisRenderer alloc] init];
    _rightAxisRenderer.color = _axisColor;
    _rightAxisRenderer.strColor = _axisColor;
    _rightAxisRenderer.width = 0.7;
    _rightAxisRenderer.textOffSet = CGSizeMake(1, 0);
    _rightAxisRenderer.strFont = _axisFont;
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
    
    SET_FRAME(_barLayer, frame);
    SET_FRAME(_lineLayer, frame);
    SET_FRAME(_backLayer, frame);
    SET_FRAME(_pointLayer, frame);
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

- (void)drawChartWithLableAnimation:(BOOL)isAnimation
{
    // 网格
    GGGrid grid = GGGridRectMake(_contentFrame, 2, 0);
    _gridRenderer.grid = grid;
    
    if (_barDataAry.count == 0) return;
    
    /** 柱 */
    CGFloat x = CGRectGetMinX(_contentFrame);
    CGFloat y = CGRectGetMinY(_contentFrame);
    CGFloat w = CGRectGetWidth(_contentFrame);
    CGFloat h = CGRectGetHeight(_contentFrame);
    CGRect chartFrame = CGRectMake(x, y, w, h);
    
    CGFloat barMax = 0;
    CGFloat barMin = 0;
    [BaseChartData getChartDataAry:_barDataAry max:&barMax min:&barMin];
    CGFloat barBase = [self getBase:barMax min:barMin];
    barMin -= barBase;
    barMax += barBase;
    
    NSInteger splitBase = _barDataAry.count + 1;
    GGLineChatScaler bar_fig = figScaler(barMax, barMin, chartFrame);
    
     GGAxis leftAxis = GGAxisLineMake(GGLeftLineRect(_contentFrame), 2.5, CGRectGetHeight(_contentFrame) / _yAxisSplit);
    _leftAxisRenderer.axis = leftAxis;
    _leftAxisRenderer.aryString = [self splitWithMax:barMax min:barMin];
    
    for (NSInteger i = 0; i < _barDataAry.count; i++) {
        
        BarChartData * barData = _barDataAry[i];
        
        GGLineChatScaler bar_axis = axiScaler(barData.dataSet.count, chartFrame, 1.0f / splitBase * (i + 1));
        
        CGMutablePathRef ref_p = CGPathCreateMutable();
        CGMutablePathRef ref_p_a = CGPathCreateMutable();
        
        for (NSInteger i = 0; i < barData.dataSet.count; i++) {
            
            CGFloat data = [barData.dataSet[i] floatValue];
            CGFloat x = bar_axis(i);
            CGFloat y1 = bar_fig(data);
            CGFloat y2 = bar_fig(barMin);
            CGRect rect = GGLineRectMake(CGPointMake(x, y1), CGPointMake(x, y2), _barWidth);
            CGRect rect_a = GGLineRectMake(CGPointMake(x, y2), CGPointMake(x, y2), _barWidth);
            
            GGPathAddCGRect(ref_p_a, rect_a);
            GGPathAddCGRect(ref_p, rect);
        }
        
        GGShapeCanvas * barLayer = ChartShape(i);
        barLayer.path = ref_p;
        barLayer.fillColor = barData.barColor.CGColor;
        barLayer.lineWidth = 0;
        barLayer.strokeColor = barData.barColor.CGColor;
        
        [barLayer registerKeyAnimation:@"path"
                                  name:@"barStart"
                                values:@[(__bridge id)ref_p_a, (__bridge id)ref_p]];
        
        CGPathRelease(ref_p);
        CGPathRelease(ref_p_a);
    }
    
    if (_lineDataAry.count == 0) return;
    
    /** 线 */
    CGFloat lineMax = 0;
    CGFloat lineMin = 0;
    [BaseChartData getChartDataAry:_lineDataAry max:&lineMax min:&lineMin];
    
    CGFloat lineBase = [self getBase:lineMax min:lineMin];
    lineMax += lineBase;
    lineMin -= lineBase;
    
    NSInteger splitLineBase = _lineDataAry.count + 1;
    GGLineChatScaler line_fig = figScaler(lineMax, lineMin, chartFrame);
    
    GGAxis rightAxis = GGAxisLineMake(GGRightLineRect(_contentFrame), -2.5, CGRectGetHeight(_contentFrame) / _yAxisSplit);
    _rightAxisRenderer.axis = rightAxis;
    _rightAxisRenderer.aryString = [self splitWithMax:lineMax min:lineMin];
    
    CGFloat baseY = bar_fig(barMin < 0 ? 0 : barMin);
    
    for (NSInteger l = 0; l < _lineDataAry.count; l++) {
        
        NSMutableArray * aryLineAnimationRefs = [NSMutableArray array];
        NSMutableArray * aryPointAnimationRefs = [NSMutableArray array];
        
        LineChartData * lineData = _lineDataAry[l];
        GGLineChatScaler line_axis = axiScaler(lineData.dataSet.count, chartFrame, 1.0f / splitLineBase * (l + 1));
        
        CGMutablePathRef ref_line = CGPathCreateMutable();
        CGMutablePathRef ref_point = CGPathCreateMutable();
        
        CGPoint points[lineData.dataSet.count];
        CGPoint basePoints[lineData.dataSet.count];
        
        for (NSInteger i = 0; i < lineData.dataSet.count; i++) {
            
            CGFloat data = [lineData.dataSet[i] floatValue];
            CGPoint line_point = CGPointMake(line_axis(i), line_fig(data));
            points[i] = line_point;
            basePoints[i] = CGPointMake(line_axis(i), baseY);
            
            i == 0 ? CGPathMoveToPoint(ref_line, NULL, line_point.x, line_point.y) : CGPathAddLineToPoint(ref_line, NULL, line_point.x, line_point.y);
            GGPathAddCircle(ref_point, GGCirclePointMake(line_point, 3));
        }
        
        // line 动画
        for (NSInteger i = 0; i < lineData.dataSet.count; i++) {
            
            CGPoint base_ref_p[lineData.dataSet.count];
            
            for (NSInteger j = 0; j < lineData.dataSet.count; j++) {
                
                base_ref_p[j] = basePoints[j];
            }
            
            for (NSInteger z = 0; z < i; z++) {
                
                base_ref_p[z] = points[z];
            }
            
            CGMutablePathRef lineRef = CGPathCreateMutable();
            CGPathAddLines(lineRef, NULL, base_ref_p, lineData.dataSet.count);
            [aryLineAnimationRefs addObject:(__bridge id)lineRef];
            CGPathRelease(lineRef);
            
            CGMutablePathRef pointRef = CGPathCreateMutable();
            CGPathAddRangeCircles(pointRef, base_ref_p, 3, 0, (int)i);
            CGPathAddRangeCircles(pointRef, base_ref_p, 0, (int)i, (int)lineData.dataSet.count);
            [aryPointAnimationRefs addObject:(__bridge id)pointRef];
            CGPathRelease(pointRef);
        }
        
        [aryLineAnimationRefs addObject:(__bridge id)ref_line];
        [aryPointAnimationRefs addObject:(__bridge id)ref_point];
        
        GGShapeCanvas * shapeLine = ChartShape(l + 10);
        shapeLine.path = ref_line;
        shapeLine.fillColor = [UIColor clearColor].CGColor;
        shapeLine.lineWidth = _lineWidth;
        shapeLine.strokeColor = lineData.lineColor.CGColor;
        CGPathRelease(ref_line);
        
        // 注册动画
        [shapeLine registerKeyAnimation:@"path"
                                   name:@"lineStart"
                                 values:aryLineAnimationRefs];
        
        GGShapeCanvas * pointShape = ChartShape(l + 100);
        pointShape.path = ref_point;
        pointShape.fillColor = [UIColor whiteColor].CGColor;
        pointShape.lineWidth = _lineWidth;
        pointShape.strokeColor = lineData.lineColor.CGColor;
        CGPathRelease(ref_point);
        
        // 注册动画
        [pointShape registerKeyAnimation:@"path"
                                    name:@"lineStart"
                                  values:aryPointAnimationRefs];
    }
}

- (void)strockChart
{
    [self drawChartWithLableAnimation:NO];
    
    [_backLayer setNeedsDisplay];
}

- (void)updateChart
{
    [self drawChartWithLableAnimation:YES];
    
    [_backLayer setNeedsDisplay];
    
    for (NSInteger i = 0; i < _barDataAry.count; i++) {
        
        [ChartShape(i) startAnimation:@"oldPush" duration:0.5];
    }
    
    for (NSInteger i = 0; i < _lineDataAry.count; i++) {
        
        [ChartShape(10 + i) startAnimation:@"oldPush" duration:0.5];
        [ChartShape(100 + i) startAnimation:@"oldPush" duration:0.5];
    }
}

- (void)addAnimation:(NSTimeInterval)duration
{
    for (NSInteger i = 0; i < _barDataAry.count; i++) {
    
        [ChartShape(i) startAnimation:@"barStart" duration:duration];
    }
    
    for (NSInteger i = 0; i < _lineDataAry.count; i++) {
        
        [ChartShape(10 + i) startAnimation:@"lineStart" duration:duration];
        [ChartShape(100 + i) startAnimation:@"lineStart" duration:duration];
    }
    
    CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"opacity"];
    base.fromValue = @0;
    base.toValue = @1;
    base.duration = duration;
    [_backLayer addAnimation:base forKey:@"o"];
}

@end
