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

#define SET_FRAME(A, B)     A.frame = CGRectMake(0, 0, CGRectGetWidth(B), CGRectGetHeight(B))

#define BAR_SYSTEM_FONT     [UIFont systemFontOfSize:14]
#define BAR_AXIS_FONT       [UIFont systemFontOfSize:12]
#define BAR_SYSTEM_COLOR    [UIColor blackColor]

#define AXIS_C              RGB(140, 154, 163)

#define POS_C               RGB(241, 73, 81)
#define NEG_C               RGB(30, 191, 97)

@interface IOBarChart ()

@property (nonatomic, strong) CAShapeLayer * pLayer;
@property (nonatomic, strong) CAShapeLayer * nLayer;
@property (nonatomic, strong) CAShapeLayer * lLayer;
@property (nonatomic, strong) GGCanvas * backLayer;

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;

@property (nonatomic, strong) UILabel *lbTop;
@property (nonatomic, strong) UILabel *lbBottom;

@property (nonatomic) CGPathRef nAniRef;
@property (nonatomic) CGPathRef pAniRef;
@property (nonatomic) CGPathRef startNAniRef;
@property (nonatomic) CGPathRef startPAniRef;

@property (nonatomic) GGLine zeroLine;

@property (nonatomic) NSMutableArray * aryCountLabels;

@end

@implementation IOBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _backLayer = [[GGCanvas alloc] init];
        SET_FRAME(_backLayer, frame);
        [self.layer addSublayer:_backLayer];
        
        _lLayer = [[CAShapeLayer alloc] init];
        SET_FRAME(_lLayer, frame);
        [self.layer addSublayer:_lLayer];
        
        _nLayer = [[CAShapeLayer alloc] init];
        SET_FRAME(_nLayer, frame);
        [self.layer addSublayer:_nLayer];
        
        _pLayer = [[CAShapeLayer alloc] init];
        SET_FRAME(_pLayer, frame);
        [self.layer addSublayer:_pLayer];
        
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
        [_backLayer addRenderer:_axisRenderer];
        
        self.barWidth = 20;
        self.contentFrame = CGRectMake(20, 40, frame.size.width - 40, frame.size.height - 90);
        
        _pLayer.strokeColor = POS_C.CGColor;
        _pLayer.fillColor = POS_C.CGColor;
        _pLayer.lineWidth = 0;
        
        _nLayer.strokeColor = NEG_C.CGColor;
        _nLayer.fillColor = NEG_C.CGColor;
        _nLayer.lineWidth = 0;
        
        _lLayer.lineWidth = 0.5;
        _lLayer.strokeColor = AXIS_C.CGColor;
        
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
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    SET_FRAME(_nLayer, frame);
    SET_FRAME(_pLayer, frame);
    SET_FRAME(_lLayer, frame);
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
    _lLayer.strokeColor = axisColor.CGColor;
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
    [self setCountLableFont:bottomFont];
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
        
        CGPathRelease(_nAniRef);
    }
    
    _nAniRef = nAniRef;
    CGPathRetain(_nAniRef);
}

- (void)setPAniRef:(CGPathRef)pAniRef
{
    if (_pAniRef) {
        
        CGPathRelease(_pAniRef);
    }
    
    _pAniRef = pAniRef;
    CGPathRetain(_pAniRef);
}

- (void)setStartNAniRef:(CGPathRef)startNAniRef
{
    if (_startNAniRef) {
        
        CGPathRelease(_startNAniRef);
    }
    
    _startNAniRef = startNAniRef;
    CGPathRetain(_startNAniRef);
}

- (void)setStartPAniRef:(CGPathRef)startPAniRef
{
    if (_startPAniRef) {
        
        CGPathRelease(_startPAniRef);
    }
    
    _startPAniRef = startPAniRef;
    CGPathRetain(_startPAniRef);
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
            GGPathAddCGRect(ref_p, rect);
            GGPathAddCGRect(ref_n, rect_a);

        }
        else {
            GGPathAddCGRect(ref_n, rect);
            GGPathAddCGRect(ref_p, rect_a);
            isAllPositive = NO;
        }
    }
    
    for (NSInteger i = 0; i < _barData.dataSet.count; i++) {
    
        CGFloat data = [_barData.dataSet[i] floatValue];
        CGFloat y2 = fig(.0f);
        CGFloat y1 = fig(data);

        UILabel * lb = [self getLable:i];
        lb.font = _axisFont;
        
        if (isAllPositive) {
            
            lb.frame = CGRectMake(lb_w * i + CGRectGetMinX(_contentFrame), y1 - lb_h, lb_w, lb_h);
            lb.textColor = _positiveColor;
        }
        else {
        
            if (data > 0) {
                
                lb.frame = CGRectMake(lb_w * i + CGRectGetMinX(_contentFrame), y2, lb_w, lb_h);
                lb.textColor = _positiveColor;
                
            }
            else {
                
                lb.frame = CGRectMake(lb_w * i + CGRectGetMinX(_contentFrame), y2 - lb_h, lb_w, lb_h);
                lb.textColor = _negativeColor;
            }
        }
    }
    
    _zeroLine = GGLineMake(x, fig(.0), x + w, fig(.0));
    GGPathAddLine(l_ref, _zeroLine);
    
    _pLayer.path = ref_p;
    _nLayer.path = ref_n;
    _lLayer.path = l_ref;
    self.startPAniRef = ref_p_a;
    self.startNAniRef = ref_n_a;
    CGPathRelease(ref_p);
    CGPathRelease(ref_n);
    CGPathRelease(ref_n_a);
    CGPathRelease(ref_p_a);
    CGPathRelease(l_ref);
    
    [_backLayer setNeedsDisplay];
}

- (void)updateChart
{
    self.pAniRef = _pLayer.path;
    self.nAniRef = _nLayer.path;
    
    [self strockChart];
    
    CAKeyframeAnimation * pKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pKeyAnimation.duration = 0.5;
    pKeyAnimation.values = @[(__bridge id)self.pAniRef, (__bridge id)_pLayer.path];
    [_pLayer addAnimation:pKeyAnimation forKey:@"p"];
    
    CAKeyframeAnimation * nKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    nKeyAnimation.duration = 0.5;
    nKeyAnimation.values = @[(__bridge id)self.nAniRef, (__bridge id)_nLayer.path];
    [_nLayer addAnimation:nKeyAnimation forKey:@"n"];
    
    CGMutablePathRef l_f_ref = CGPathCreateMutable();
    GGPathAddLine(l_f_ref, _zeroLine);
    CGMutablePathRef l_t_ref = CGPathCreateMutable();
    CGPoint mid_p = CGPointMake(_zeroLine.start.x + GGLineGetWidth(_zeroLine) / 2, _zeroLine.start.y);
    GGPathAddLine(l_t_ref, GGPointLineMake(mid_p, mid_p));
    
    CAKeyframeAnimation * lKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    lKeyAnimation.duration = 0.5;
    lKeyAnimation.values = @[(__bridge id)l_t_ref, (__bridge id)l_f_ref];
    [_lLayer addAnimation:lKeyAnimation forKey:@"l"];
    CGPathRelease(l_t_ref);
    CGPathRelease(l_f_ref);
    
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
        countLable.format = @"%.1f";
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
    CAKeyframeAnimation * pKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pKeyAnimation.duration = duration;
    pKeyAnimation.values = @[(__bridge id)self.startPAniRef, (__bridge id)_pLayer.path];
    [_pLayer addAnimation:pKeyAnimation forKey:@"p"];
    
    CAKeyframeAnimation * nKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    nKeyAnimation.duration = duration;
    nKeyAnimation.values = @[(__bridge id)self.startNAniRef, (__bridge id)_nLayer.path];
    [_nLayer addAnimation:nKeyAnimation forKey:@"n"];
    
    CGMutablePathRef l_f_ref = CGPathCreateMutable();
    GGPathAddLine(l_f_ref, _zeroLine);
    CGMutablePathRef l_t_ref = CGPathCreateMutable();
    CGPoint mid_p = CGPointMake(_zeroLine.start.x + GGLineGetWidth(_zeroLine) / 2, _zeroLine.start.y);
    GGPathAddLine(l_t_ref, GGPointLineMake(mid_p, mid_p));
    
    CAKeyframeAnimation * lKeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    lKeyAnimation.duration = duration;
    lKeyAnimation.values = @[(__bridge id)l_t_ref, (__bridge id)l_f_ref];
    [_lLayer addAnimation:lKeyAnimation forKey:@"l"];
    CGPathRelease(l_t_ref);
    CGPathRelease(l_f_ref);
    
    CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"opacity"];
    base.fromValue = @0;
    base.toValue = @1;
    base.duration = duration;
    [_backLayer addAnimation:base forKey:@"o"];
    
    for (NSInteger i = 0; i < _barData.dataSet.count; i++) {
        
        UICountingLabel * countLb = [self getLable:i];
        [countLb countFrom:0 to:_barData.dataSet[i].floatValue withDuration:duration];
    }
}

@end
