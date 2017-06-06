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

#define SET_FRAME(A, B)     A.frame = CGRectMake(0, 0, CGRectGetWidth(B), CGRectGetHeight(B))

#define BAR_SYSTEM_FONT     [UIFont systemFontOfSize:14]
#define BAR_SYSTEM_COLOR    [UIColor blackColor]

#define AXIS_C              RGB(140, 154, 163)

#define POS_C               RGB(241, 73, 81)
#define NEG_C               RGB(30, 191, 97)

@interface IOBarChart ()

@property (nonatomic, strong) CAShapeLayer * pLayer;
@property (nonatomic, strong) CAShapeLayer * nLayer;
@property (nonatomic, strong) GGCanvas * backLayer;

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;
@property (nonatomic, strong) GGLineRenderer * lineRenderer;

@property (nonatomic, strong) UILabel *lbTop;
@property (nonatomic, strong) UILabel *lbBottom;

@property (nonatomic) CGPathRef nAniRef;
@property (nonatomic) CGPathRef pAniRef;

@end

@implementation IOBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _backLayer = [[GGCanvas alloc] init];
        SET_FRAME(_backLayer, frame);
        [self.layer addSublayer:_backLayer];
        
        _nLayer = [[CAShapeLayer alloc] init];
        SET_FRAME(_nLayer, frame);
        [self.layer addSublayer:_nLayer];
        
        _pLayer = [[CAShapeLayer alloc] init];
        SET_FRAME(_pLayer, frame);
        [self.layer addSublayer:_pLayer];
        
        _topFont = BAR_SYSTEM_FONT;
        _bottomFont = BAR_SYSTEM_FONT;
        _axisFont = BAR_SYSTEM_FONT;
        
        _axisColor = AXIS_C;
        _topColor = BAR_SYSTEM_COLOR;
        _bottomColor = BAR_SYSTEM_COLOR;
        
        _axisRenderer = [[GGAxisRenderer alloc] init];
        _axisRenderer.color = _axisColor;
        _axisRenderer.strColor = _axisColor;
        _axisRenderer.width = 0.7;
        _axisRenderer.showSep = NO;
        _axisRenderer.showLine = NO;
        [_backLayer addRenderer:_axisRenderer];
        
        _lineRenderer = [[GGLineRenderer alloc] init];
        _lineRenderer.width = 0.7;
        _lineRenderer.color = _axisColor;
        [_backLayer addRenderer:_lineRenderer];
        
        self.barWidth = 20;
        self.contentFrame = CGRectMake(20, 40, frame.size.width - 40, frame.size.height - 90);
        
        _pLayer.strokeColor = POS_C.CGColor;
        _pLayer.fillColor = POS_C.CGColor;
        _pLayer.lineWidth = 0;
        
        _nLayer.strokeColor = NEG_C.CGColor;
        _nLayer.fillColor = NEG_C.CGColor;
        _nLayer.lineWidth = 0;
        
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    SET_FRAME(_nLayer, frame);
    SET_FRAME(_pLayer, frame);
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

- (void)setAxisFont:(UIFont *)axisFont
{
    _axisFont = axisFont;
    _axisRenderer.strFont = axisFont;
}

- (void)setAxisColor:(UIColor *)axisColor
{
    _axisColor = axisColor;
    _axisRenderer.color = axisColor;
    _lineRenderer.color = axisColor;
}

- (void)setPositiveColor:(UIColor *)positiveColor
{
    _positiveColor = positiveColor;
    _pLayer.strokeColor = _positiveColor.CGColor;
    _pLayer.fillColor = _positiveColor.CGColor;
}

- (void)setNegativeColor:(UIColor *)negativeColor
{
    _negativeColor = negativeColor;
    _nLayer.strokeColor = _negativeColor.CGColor;
    _nLayer.fillColor = _negativeColor.CGColor;
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

- (void)setNAniRef:(CGPathRef)nAniRef
{
    if (_nAniRef) {
        
        CGPathRelease(nAniRef);
    }
    
    _nAniRef = nAniRef;
    CGPathRetain(_nAniRef);
}

- (void)setPAniRef:(CGPathRef)pAniRef
{
    if (_pAniRef) {
        
        CGPathRelease(pAniRef);
    }
    
    _pAniRef = pAniRef;
    CGPathRetain(_pAniRef);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_backLayer setNeedsDisplay];
    
    _lbBottom.frame = CGRectMake(self.frame.size.width - _lbBottom.frame.size.width, self.frame.size.height - _lbBottom.frame.size.height, _lbBottom.frame.size.width, _lbBottom.frame.size.height);
}

- (void)strockChart
{
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

    CGMutablePathRef ref_p = CGPathCreateMutable();
    CGMutablePathRef ref_n = CGPathCreateMutable();
    CGMutablePathRef ref_p_a = CGPathCreateMutable();
    CGMutablePathRef ref_n_a = CGPathCreateMutable();
    
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
            
            GGPathAddCGRect(ref_p, rect);
            GGPathAddCGRect(ref_n, rect_a);
        }
        else {
        
            GGPathAddCGRect(ref_n, rect);
            GGPathAddCGRect(ref_p, rect_a);
        }
    }
    
    _pLayer.path = ref_p;
    _nLayer.path = ref_n;
    self.pAniRef = ref_p_a;
    self.nAniRef = ref_n_a;
    CGPathRelease(ref_p);
    CGPathRelease(ref_n);
    CGPathRelease(ref_n_a);
    CGPathRelease(ref_p_a);
    
    _lineRenderer.line = GGLineMake(x, fig(.0), x + w, fig(.0));
    
    [_backLayer setNeedsDisplay];
}

- (void)animationSelector:(CADisplayLink *)link
{
    
}

- (void)addAnimation:(NSTimeInterval)duration
{
    CAKeyframeAnimation * pKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pKeyAnimation.duration = duration;
    pKeyAnimation.values = @[(__bridge id)self.pAniRef, (__bridge id)_pLayer.path];
    [_pLayer addAnimation:pKeyAnimation forKey:@"p"];
    
    CAKeyframeAnimation * nKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    nKeyAnimation.duration = duration;
    nKeyAnimation.values = @[(__bridge id)self.nAniRef, (__bridge id)_nLayer.path];
    [_nLayer addAnimation:nKeyAnimation forKey:@"n"];
}

@end
