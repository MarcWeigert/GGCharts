//
//  IOBarChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PNBarChart.h"
#import "GGCanvas.h"
#import "GGAxisRenderer.h"
#import "BarChartData.h"
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

@interface PNBarChart ()

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;    ///< x轴渲染器

@property (nonatomic, strong) GGShapeCanvas * lineCanvas;   ///< 分割线层
@property (nonatomic, strong) GGCanvas * backLayer;         ///< 背景层

@property (nonatomic, strong) UILabel *lbTop;
@property (nonatomic, strong) UILabel *lbBottom;

@end

@implementation PNBarChart

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

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [_pnBarData chartTouchesMoved:point];
}

#pragma mark - 初始化设置

- (void)defaultChartConfig
{
    _topFont = BAR_SYSTEM_FONT;
    _bottomFont = BAR_SYSTEM_FONT;
    _axisFont = BAR_AXIS_FONT;
    
    _axisColor = AXIS_C;
    _topColor = BAR_SYSTEM_COLOR;
    _bottomColor = BAR_SYSTEM_COLOR;
    _negativeColor = NEG_C;
    _positiveColor = POS_C;
    
    _backLayer = [[GGCanvas alloc] init];
    
    _axisRenderer = [[GGAxisRenderer alloc] init];
    _axisRenderer.color = _axisColor;
    _axisRenderer.strColor = _axisColor;
    _axisRenderer.width = 0.7;
    _axisRenderer.showSep = NO;
    _axisRenderer.showLine = NO;
    _axisRenderer.strFont = _axisFont;
    _axisRenderer.offSetRatio = CGPointMake(0.5, 0);
    [_backLayer addRenderer:_axisRenderer];
    
    _format = @"%.2f";
}

/**
 * 初始化标题和底部
 */
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
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backLayer setNeedsDisplay];
    
    _lbBottom.frame = CGRectMake(self.frame.size.width - _lbBottom.frame.size.width, self.frame.size.height - _lbBottom.frame.size.height, _lbBottom.frame.size.width, _lbBottom.frame.size.height);
}

#pragma mark - 绘制图表

/** 绘制图表 */
- (void)drawChart
{
    [super drawChart];
    
    _backLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    GGShapeCanvas * pCanvas = [self getGGCanvasEqualFrame];
    GGShapeCanvas * nCanvas = [self getGGCanvasEqualFrame];
    self.pnBarData.barScaler.rect = self.contentFrame;
    [self.pnBarData drawPNBarWithCanvas:pCanvas negativeCanvas:nCanvas];
    
    [self drawCountLable];
    [self drawLine];
}

/** 绘制分割线 */
- (void)drawLine
{
    CGFloat y = [self.pnBarData.barScaler getYPixelWithData:0];
    GGLine zeroLine = GGLineMake(CGRectGetMinX(_contentFrame), y, CGRectGetMaxX(_contentFrame), y);
    
    CGMutablePathRef ref = CGPathCreateMutable();
    GGShapeCanvas * line_shape = [self getGGCanvasEqualFrame];
    line_shape.strokeColor = _axisColor.CGColor;
    line_shape.lineWidth = 0.5;
    line_shape.fillColor = [UIColor clearColor].CGColor;
    GGPathAddLine(ref, zeroLine);
    line_shape.path = ref;
    _lineCanvas = line_shape;
    CGPathRelease(ref);
}

/** 数字标题 */
- (void)drawCountLable
{
    BOOL isAllPositive = self.pnBarData.isAllPositive;
    CGFloat lb_w = CGRectGetWidth(_contentFrame) / _pnBarData.datas.count;
    CGFloat lb_h = [@"1" sizeWithAttributes:@{NSFontAttributeName : _axisFont}].height;
    
    [self.pnBarData.datas enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        CGRect frame;
        CGFloat barData = obj.floatValue;
        CGRect barRect = self.pnBarData.barScaler.barRects[idx];
        UICountingLabel * lb = [self getGGCountLable];
        lb.format = _format;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = [NSString stringWithFormat:lb.format, barData];
        lb.font = _axisFont;
        
        if (isAllPositive) {
            frame = CGRectMake(lb_w * idx + CGRectGetMinX(_contentFrame), barRect.origin.y - lb_h, lb_w, lb_h);
            lb.textColor = _positiveColor;
        }
        else {
            if (barData > 0) {
                frame = CGRectMake(lb_w * idx + CGRectGetMinX(_contentFrame), CGRectGetMaxY(barRect), lb_w, lb_h);
                lb.textColor = _positiveColor;
                
            }
            else {
                frame = CGRectMake(lb_w * idx + CGRectGetMinX(_contentFrame), barRect.origin.y - lb_h, lb_w, lb_h);
                lb.textColor = _negativeColor;
            }
        }
        
        lb.frame = frame;
    }];
}

/** 更新图表 */
- (void)updateChart
{
    [self drawChart];
    [_pnBarData.nBarCanvas pathChangeAnimation:0.5];
    [_pnBarData.pBarCanvas pathChangeAnimation:0.5];
    [_lineCanvas pathChangeAnimation:.5f];
    [self.visibleLables enumerateObjectsUsingBlock:^(UICountingLabel * obj, NSUInteger idx, BOOL * stop) {
        [obj changeRectAnimation:0.5];
        [obj countFromCurrentValueTo:_pnBarData.datas[idx].floatValue withDuration:0.5];
    }];
}

#pragma mark - 动画

- (void)addAnimation:(NSTimeInterval)duration
{
    CGFloat y = [self.pnBarData.barScaler getYPixelWithData:0];
    
    CAKeyframeAnimation * pAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    pAnimation.duration = duration;
    
    [self.pnBarData.barScaler getPositiveData:^(CGRect *rects, size_t size) {
        pAnimation.values = GGPathRectsStretchAnimation(rects, size, y);
    }];
    
    [self.pnBarData.pBarCanvas addAnimation:pAnimation forKey:@"pAnimation"];
    
    CAKeyframeAnimation * nAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    nAnimation.duration = duration;
    
    [self.pnBarData.barScaler getNegativeData:^(CGRect *rects, size_t size) {
        nAnimation.values = GGPathRectsStretchAnimation(rects, size, y);
    }];
    
    [self.pnBarData.nBarCanvas addAnimation:nAnimation forKey:@"nAnimation"];
    
    [self.visibleLables enumerateObjectsUsingBlock:^(UICountingLabel * obj, NSUInteger idx, BOOL * stop) {
        
        [obj countFrom:0 to:_pnBarData.datas[idx].floatValue withDuration:duration];
    }];
}

#pragma mark - Setter && Getter

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
}

- (void)setBottomTitle:(NSString *)bottomTitle
{
    _bottomTitle = bottomTitle;
    _lbBottom.text = bottomTitle;
    [_lbBottom sizeToFit];
}

@end
