//
//  IOBarChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "IOBarChart.h"
#import "GGCanvas.h"
#import "GGAxisRenderer.h"
#import "BarChartData.h"
#import "DrawMath.h"
#import "GGDataScaler.h"
#import "GGChartGeometry.h"
#import "GGLineRenderer.h"
#import "Colors.h"
#import "CGPathCategory.h"
#import "UICountingLabel.h"
#import "GGShapeCanvas.h"
#import "LineChartData.h"
#import "DBarScaler.h"

#define BAR_SYSTEM_FONT     [UIFont systemFontOfSize:14]
#define BAR_AXIS_FONT       [UIFont systemFontOfSize:12]

#define BAR_SYSTEM_COLOR    [UIColor blackColor]
#define AXIS_C              RGB(140, 154, 163)
#define POS_C               RGB(241, 73, 81)
#define NEG_C               RGB(30, 191, 97)

#define PosLayer            1000
#define NegLayer            2000
#define LineLayer           3000
#define BackLayer           4000
#define LineDataLayer       5000

@interface IOBarChart ()

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;

@property (nonatomic, strong) UILabel *lbTop;
@property (nonatomic, strong) UILabel *lbBottom;

@property (nonatomic) NSMutableArray * aryCountLabels;

@end

@implementation IOBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self defaultChartConfig];
        [self makeTitleViews];
        
        self.contentFrame = CGRectMake(20, 40, frame.size.width - 40, frame.size.height - 90);
    }
    
    return self;
}

- (void)defaultChartConfig
{
    _barWidth = 20;
    
    _topFont = BAR_SYSTEM_FONT;
    _bottomFont = BAR_SYSTEM_FONT;
    _axisFont = BAR_AXIS_FONT;
    
    _axisColor = AXIS_C;
    _topColor = BAR_SYSTEM_COLOR;
    _bottomColor = BAR_SYSTEM_COLOR;
    _negativeColor = NEG_C;
    _positiveColor = POS_C;
    
    _axisRenderer = [[GGAxisRenderer alloc] init];
    _axisRenderer.color = _axisColor;
    _axisRenderer.strColor = _axisColor;
    _axisRenderer.width = 0.7;
    _axisRenderer.showSep = NO;
    _axisRenderer.showLine = NO;
    _axisRenderer.strFont = _axisFont;
    _axisRenderer.offSetRatio = CGPointMake(0.5, 0);
    [ChartBack(BackLayer) addRenderer:_axisRenderer];
    
    _format = @"%.2f";
}

- (void)makeTitleViews
{
    _lbTop = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbTop.font = _topFont;
    _lbTop.textColor = _topColor;
    [self addSubview:_lbTop];
    
    _lbBottom = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbBottom.font = _bottomFont;
    _lbBottom.textColor = _bottomColor;
    [self addSubview:_lbBottom];
    
    _aryCountLabels = [NSMutableArray array];
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

- (void)setAxisFont:(UIFont *)axisFont
{
    _axisFont = axisFont;
    _axisRenderer.strFont = axisFont;
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
    [self setCountLableFont:bottomFont];
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
    
    [ChartBack(BackLayer) setNeedsDisplay];
    
    _lbBottom.frame = CGRectMake(self.frame.size.width - _lbBottom.frame.size.width, self.frame.size.height - _lbBottom.frame.size.height, _lbBottom.frame.size.width, _lbBottom.frame.size.height);
}

- (void)drawChartWithLableAnimation:(BOOL)isAnimation
{
    GGShapeCanvas * pos_shape = ChartShape(PosLayer);
    pos_shape.strokeColor = _positiveColor.CGColor;
    pos_shape.fillColor = _positiveColor.CGColor;
    pos_shape.lineWidth = 0;
    
    GGShapeCanvas * neg_shape = ChartShape(NegLayer);
    neg_shape.strokeColor = _negativeColor.CGColor;
    neg_shape.fillColor = _negativeColor.CGColor;
    neg_shape.lineWidth = 0;
    
    GGShapeCanvas * line_shape = ChartShape(LineLayer);
    line_shape.strokeColor = _axisColor.CGColor;
    line_shape.lineWidth = 0.5;
    line_shape.fillColor = [UIColor clearColor].CGColor;
    
    CGFloat max = getMax(_barData.dataSet);
    CGFloat min = getMin(_barData.dataSet);
    min = min < 0 ? min : 0;
    
    CGFloat x = CGRectGetMinX(_contentFrame);
    CGFloat y = CGRectGetMinY(_contentFrame) + 10;
    CGFloat w = CGRectGetWidth(_contentFrame);
    CGFloat h = CGRectGetHeight(_contentFrame) - 20;
    CGFloat lb_w = w / _barData.dataSet.count;
    CGFloat lb_h = [@"1" sizeWithAttributes:@{NSFontAttributeName : _axisFont}].height;
    CGRect barFrame = CGRectMake(x, y, w, h);
    
    GGLineChatScaler fig = figScaler(max, min, barFrame);
    GGLineChatScaler axis = axiScaler(_barData.dataSet.count, barFrame, 0.5);
    
    CGMutablePathRef ref_p = CGPathCreateMutable();
    CGMutablePathRef ref_n = CGPathCreateMutable();
    CGMutablePathRef ref_p_a = CGPathCreateMutable();
    CGMutablePathRef ref_n_a = CGPathCreateMutable();
    CGMutablePathRef l_ref = CGPathCreateMutable();
    CGMutablePathRef l_c_ref = CGPathCreateMutable();
    
    DBarScaler * barScaler = [[DBarScaler alloc] init];
    barScaler.max = max;
    barScaler.min = min;
    barScaler.barWidth = _barWidth;
    barScaler.dataAry = _barData.dataSet;
    barScaler.rect = barFrame;
    barScaler.bottomPrice = 0;
    [barScaler updateScaler];
    
    [barScaler getPositiveData:^(CGRect *rects, size_t size) {
        
        GGpathAddCGRects(ref_p, rects, size);
    }];
    
    [barScaler getNegativeData:^(CGRect *rects, size_t size) {
        
        GGpathAddCGRects(ref_n, rects, size);
    }];
    
    BOOL isAllPositive = YES;
    
    for (NSInteger i = 0; i < _barData.dataSet.count; i++) {
        
        CGFloat data = [_barData.dataSet[i] floatValue];
        CGFloat x = axis(i);
        CGFloat y1 = fig(data);
        CGFloat y2 = fig(.0f);
        CGRect rect = GGLineRectMake(CGPointMake(x, y1), CGPointMake(x, y2), _barWidth);
        CGRect rect_a = GGLineRectMake(CGPointMake(x, y2), CGPointMake(x, y2), _barWidth);
        
        GGPathAddCGRect(ref_p_a, rect_a);
        GGPathAddCGRect(ref_n_a, rect_a);
        
        if (data > 0) {
            //GGPathAddCGRect(ref_p, rect);
            //GGPathAddCGRect(ref_n, rect_a);
            
        }
        else {
            //GGPathAddCGRect(ref_n, rect);
            //GGPathAddCGRect(ref_p, rect_a);
            isAllPositive = NO;
        }
    }
    
    for (NSInteger i = 0; i < _barData.dataSet.count; i++) {
        
        CGFloat data = [_barData.dataSet[i] floatValue];
        CGFloat y2 = fig(.0f);
        CGFloat y1 = fig(data);
        
        UICountingLabel * lb = [self getLable:i];
        lb.format = _format;
        lb.text = [NSString stringWithFormat:lb.format, _barData.dataSet[i].floatValue];
        lb.font = _axisFont;
        
        CGRect frame;
        
        if (isAllPositive) {
            
            frame = CGRectMake(lb_w * i + CGRectGetMinX(_contentFrame), y1 - lb_h, lb_w, lb_h);
            lb.textColor = _positiveColor;
        }
        else {
            
            if (data > 0) {
                
                frame = CGRectMake(lb_w * i + CGRectGetMinX(_contentFrame), y2, lb_w, lb_h);
                lb.textColor = _positiveColor;
                
            }
            else {
                
                frame = CGRectMake(lb_w * i + CGRectGetMinX(_contentFrame), y2 - lb_h, lb_w, lb_h);
                lb.textColor = _negativeColor;
            }
        }
        
        if (isAnimation) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                
                lb.frame = frame;
            }];
        }
        else {
        
            lb.frame = frame;
        }
    }
    
    GGLine zeroLine = GGLineMake(x, fig(.0), x + w, fig(.0));
    CGPoint center = GGCenterPoint(zeroLine);
    
    GGPathAddLine(l_ref, zeroLine);
    GGPathAddLine(l_c_ref, GGPointLineMake(center, center));
    
    // 无数据到有数据动画
    [neg_shape registerKeyAnimation:@"path"
                               name:@"start"
                             values:@[(__bridge id)ref_n_a, (__bridge id)ref_n]];
    
    [pos_shape registerKeyAnimation:@"path"
                             name:@"start"
                           values:@[(__bridge id)ref_p_a, (__bridge id)ref_p]];
    
    [line_shape registerKeyAnimation:@"path"
                             name:@"start"
                           values:@[(__bridge id)l_c_ref, (__bridge id)l_ref]];
    
    pos_shape.path = ref_p;
    neg_shape.path = ref_n;
    line_shape.path = l_ref;
    
    CGPathRelease(ref_p);
    CGPathRelease(ref_n);
    CGPathRelease(ref_n_a);
    CGPathRelease(ref_p_a);
    CGPathRelease(l_ref);
    CGPathRelease(l_c_ref);
    
    [ChartBack(BackLayer) setNeedsDisplay];
}

- (void)strockLineData
{
    CGMutablePathRef ref_line = CGPathCreateMutable();
    
    GGShapeCanvas * line_shape = ChartShape(LineDataLayer);
    line_shape.lineWidth = _lineWidth;
    line_shape.fillColor = _lineData.lineColor.CGColor;
    line_shape.strokeColor = _lineData.lineColor.CGColor;
    
    CGFloat max = getMax(_barData.dataSet);
    CGFloat min = getMin(_barData.dataSet);
    min = min < 0 ? min : 0;
    
    CGFloat x = CGRectGetMinX(_contentFrame);
    CGFloat y = CGRectGetMinY(_contentFrame) + 10;
    CGFloat w = CGRectGetWidth(_contentFrame);
    CGFloat h = CGRectGetHeight(_contentFrame) - 20;
    CGRect barFrame = CGRectMake(x, y, w, h);
    
    GGLineChatScaler fig = figScaler(max, min, barFrame);
    GGLineChatScaler axis = axiScaler(_barData.dataSet.count, barFrame, 0.5);
    
    for (NSInteger i = 0; i < _lineData.dataSet.count; i++) {
        
        CGFloat data = [_lineData.dataSet[i] floatValue];
        CGFloat x = axis(i);
        CGFloat y = fig(data);
        
        CGPoint point = CGPointMake(x, y);
        GGCircle circle = GGCirclePointMake(point, 2);
        
        if (i == 0) {
            
            CGPathMoveToPoint(ref_line, NULL, x, y);
        }
        else {
        
            CGPathAddLineToPoint(ref_line, NULL, x, y);
        }
        
        GGPathAddCircle(ref_line, circle);
    }
    
    line_shape.path = ref_line;
    CGPathRelease(ref_line);
}

- (void)strockChart
{
    [self drawChartWithLableAnimation:NO];
    
    if (_lineData) {
        
        [self strockLineData];
    }
}

- (void)updateChart
{
    [self drawChartWithLableAnimation:YES];
    
    [ChartShape(PosLayer) startAnimation:@"oldPush" duration:0.5];
    [ChartShape(NegLayer) startAnimation:@"oldPush" duration:0.5];
    [ChartShape(LineLayer) startAnimation:@"oldPush" duration:0.5];
    [ChartShape(LineDataLayer) startAnimation:@"oldPush" duration:0.5];
    
    for (NSInteger i = 0; i < _barData.dataSet.count; i++) {
        
        UICountingLabel * countLb = [self getLable:i];
        [countLb countFromCurrentValueTo:_barData.dataSet[i].floatValue withDuration:0.5];
    }
}

- (UICountingLabel *)getLable:(NSInteger)index
{
    if (_aryCountLabels.count <= index) {
        
        UICountingLabel * countLable = [[UICountingLabel alloc] initWithFrame:CGRectZero];
        countLable.font = _bottomFont;
        countLable.method = UILabelCountingMethodLinear;
        countLable.format = _format;
        countLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countLable];
        [_aryCountLabels addObject:countLable];
    }
    
    return _aryCountLabels[index];
}

- (void)setCountLableFont:(UIFont *)font
{
    for (UICountingLabel * countLable in _aryCountLabels) {
        
        countLable.font = font;
    }
}

- (void)addAnimation:(NSTimeInterval)duration
{
    [ChartShape(PosLayer) startAnimation:@"start" duration:duration];
    [ChartShape(NegLayer) startAnimation:@"start" duration:duration];
    [ChartShape(LineLayer) startAnimation:@"start" duration:duration];
    
    CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"opacity"];
    base.fromValue = @0;
    base.toValue = @1;
    base.duration = duration;
    [ChartBack(BackLayer) addAnimation:base forKey:@"o"];
    
    for (NSInteger i = 0; i < _barData.dataSet.count; i++) {
        
        UICountingLabel * countLb = [self getLable:i];
        [countLb countFrom:0 to:_barData.dataSet[i].floatValue withDuration:duration];
    }
}

@end
