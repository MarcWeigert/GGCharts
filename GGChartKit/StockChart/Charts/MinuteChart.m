//
//  TimeChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MinuteChart.h"
#import "GGChartDefine.h"
#import "NSArray+Stock.h"
#import "GGGraphics.h"
#import "NSDate+GGDate.h"
#import "CrissCrossQueryView.h"

@interface MinuteChart ()

@property (nonatomic, strong) DBarScaler * barScaler;       ///< 成交量定标器
@property (nonatomic, strong) DLineScaler * lineScaler;     ///< 分时线定标器
@property (nonatomic, strong) DLineScaler * averageScaler;      ///< 均价线定标器

@property (nonatomic, strong) GGCanvas * backCanvas;        ///< 背景层
@property (nonatomic, strong) GGGridRenderer * gridRenderer;    ///< 网格层
@property (nonatomic, strong) GGAxisRenderer * bottomRenderer;  ///< 底部轴
@property (nonatomic, strong) GGAxisRenderer * leftRenderer;    ///< 左边轴
@property (nonatomic, strong) GGAxisRenderer * rightRenderer;   ///< 右边轴

@property (nonatomic, strong) GGAxisRenderer * volumRenderer;   ///< 成交量轴
@property (nonatomic, strong) GGGridRenderer * volumGridRenderer;   ///< 成交量网格

@property (nonatomic, strong) GGLineRenderer * lineRenderer;    ///< 虚线
@property (nonatomic, strong) GGStringRenderer * priceRenderer;    ///< 价格
@property (nonatomic, strong) GGStringRenderer * ratoRenderer;      ///< 涨跌幅

@property (nonatomic, strong) GGCircleRenderer * priceCircle;
@property (nonatomic, strong) GGCircleRenderer * avgCircle;

@property (nonatomic) CGFloat KTimeChartMaxPrice;   ///< 区域内最大值
@property (nonatomic) CGFloat KTimeChartMinPrice;   ///< 区域内最小值

@property (nonatomic, strong) CrissCrossQueryView * queryPriceView;     ///< 查价层

@property (nonatomic, strong) GGCanvas * animationCanvas;   ///< 动画层
@property (nonatomic, strong) GGCircleRenderer * circleGradeAnimation;
@property (nonatomic, assign) CGFloat base;

@end

@implementation MinuteChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _lineRatio = .55f;
        _lineColor = RGB(66, 112, 186);
        _redColor = RGB(216, 94, 101);
        _greenColor = RGB(150, 234, 166);
        _avgColor = RGB(204, 156, 101);
        _gridColor = RGB(225, 225, 225);
        _axisStringColor = C_HEX(0xaeb1b6);
        _posColor = RGB(234, 82, 78);
        _negColor = RGB(74, 154, 84);
        _axisFont = [UIFont fontWithName:@"ArialMT" size:10];
        
        [self.layer addSublayer:self.backCanvas];
        [self.layer addSublayer:self.animationCanvas];
        
        [self.animationCanvas addRenderer:self.circleGradeAnimation];
        
        [self.backCanvas addRenderer:self.gridRenderer];
        [self.backCanvas addRenderer:self.bottomRenderer];
        [self.backCanvas addRenderer:self.leftRenderer];
        [self.backCanvas addRenderer:self.rightRenderer];
        [self.backCanvas addRenderer:self.volumRenderer];
        [self.backCanvas addRenderer:self.volumGridRenderer];
        
        // 最新价格线
        [self.backCanvas addRenderer:self.lineRenderer];
        [self.backCanvas addRenderer:self.priceRenderer];
        [self.backCanvas addRenderer:self.ratoRenderer];
        
        [self setFrame:frame];
        
        [self configBackLayer];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressViewOnGesturer:)];
        [self addGestureRecognizer:longPress];
        
        _base = 1;
        
        CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAnimationCircle)];
        displayLink.frameInterval = 3;
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        displayLink.paused = NO;
    }
    
    return self;
}

- (void)displayAnimationCircle
{
    if (self.objTimeAry.count) {
        
        self.circleGradeAnimation.circle = GGCirclePointMake(self.lineScaler.linePoints[_objTimeAry.count - 1], self.circleGradeAnimation.circle.radius + 10.0f / 60 * _base);
        
        if (self.circleGradeAnimation.circle.radius > 8) {
            
            _base = -1;
        }
        
        if (self.circleGradeAnimation.circle.radius < 2) {
            
            _base = 1;
        }

        [self.animationCanvas setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backCanvas.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.animationCanvas.frame = self.backCanvas.frame;
    
    CGRect lineRect = [self lineRect];
    CGFloat ySplit = lineRect.size.height / 4;
    self.leftRenderer.axis = GGAxisLineMake(GGLeftLineRect(lineRect), 0, ySplit);
    self.rightRenderer.axis = GGAxisLineMake(GGRightLineRect(lineRect), 0, ySplit);
    self.bottomRenderer.axis = GGAxisLineMake(GGBottomLineRect(lineRect), 1, frame.size.width / 8);
    self.gridRenderer.grid = GGGridRectMake(lineRect, ySplit, frame.size.width / 8);
    
    CGRect volumRect = [self volumRect];
    CGFloat yVolumSplit = volumRect.size.height / 2;
    self.volumRenderer.axis = GGAxisLineMake(GGLeftLineRect(volumRect), 0, yVolumSplit);
    self.volumGridRenderer.grid = GGGridRectMake(volumRect, yVolumSplit, frame.size.width / 8);
    
    self.queryPriceView.frame = CGRectMake(0, 15, frame.size.width, frame.size.height - 15);
}

#pragma mark - 手势

/** 长按十字星 */
- (void)longPressViewOnGesturer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        self.queryPriceView.hidden = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint velocity = [recognizer locationInView:self.queryPriceView];
        velocity.y += self.queryPriceView.gg_top;
        self.queryPriceView.hidden = NO;
        [self.queryPriceView.cirssLayer addRenderer:self.avgCircle];
        [self.queryPriceView.cirssLayer addRenderer:self.priceCircle];
        [self updateQueryLayerWithPoint:velocity];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [recognizer locationInView:self.queryPriceView];
        velocity.y += self.queryPriceView.gg_top;
        [self updateQueryLayerWithPoint:velocity];
    }
}

/** 更新十字星查价框 */
- (void)updateQueryLayerWithPoint:(CGPoint)velocity
{
    NSInteger index = velocity.x / (self.frame.size.width / 240);
    index = index >= self.objTimeAry.count - 1 ? self.objTimeAry.count - 1 : index;
    
    id <KLineAbstract, QueryViewAbstract> kData = self.objTimeAry[index];
    
    NSString * yString = @"";
    
    CGRect lineRect = [self lineRect];
    CGRect volumRect = [self volumRect];
    
    self.queryPriceView.xAxisOffsetY = CGRectGetMaxY(lineRect) - self.queryPriceView.gg_top + 2;
    
    if (CGRectContainsPoint(lineRect, velocity)) {
        
        yString = [NSString stringWithFormat:@"%.2f", [self.lineScaler getPriceWithYPixel:velocity.y]];
    }
    else if (CGRectContainsPoint(volumRect, velocity)) {
        
        yString = [NSString stringWithFormat:@"%.2f手", [self.barScaler getPriceWithYPixel:velocity.y]];
    }

    [self.queryPriceView setYString:yString setXString:[[self.objTimeAry[index] ggTimeDate] stringWithFormat:@"HH:mm"]];
    [self.queryPriceView.queryView setQueryData:kData];
    
    CGPoint point = self.lineScaler.linePoints[index];
    CGPoint avgPoint = self.averageScaler.linePoints[index];
    self.avgCircle.circle = GGCirclePointMake(CGPointMake(avgPoint.x, avgPoint.y - self.queryPriceView.gg_top), 2);
    self.priceCircle.circle = GGCirclePointMake(CGPointMake(point.x, point.y - self.queryPriceView.gg_top), 2);
    self.avgCircle.fillColor = self.avgColor;
    self.priceCircle.fillColor = self.lineColor;
    [self.queryPriceView setCenterPoint:CGPointMake(point.x, velocity.y - self.queryPriceView.gg_top)];
}

#pragma mark - Rect

- (CGRect)lineRect
{
    return CGRectMake(0, 15, self.frame.size.width, self.frame.size.height * _lineRatio);
}

- (CGRect)volumRect
{
    CGRect lineRect = [self lineRect];
    
    return CGRectMake(0, CGRectGetMaxY(lineRect) + 13, self.frame.size.width, self.frame.size.height - CGRectGetMaxY(lineRect) - 13);
}

- (void)configBackLayer
{
    self.leftRenderer.strFont = _axisFont;
    self.leftRenderer.offSetRatio = CGPointMake(0, -1);
    self.leftRenderer.colorAry = @[_posColor, _posColor, _axisStringColor, _negColor, _negColor];
    
    self.rightRenderer.strFont = _axisFont;
    self.rightRenderer.offSetRatio = CGPointMake(-1, -1);
    self.rightRenderer.colorAry = @[_posColor, _posColor, _axisStringColor, _negColor, _negColor];
    
    self.bottomRenderer.strFont = _axisFont;
    self.bottomRenderer.strColor = _axisStringColor;
    self.bottomRenderer.isStringFirstLastindent = YES;
    
    self.volumRenderer.strFont = _axisFont;
    self.volumRenderer.strColor = _axisStringColor;
    
    self.gridRenderer.width = .25f;
    self.gridRenderer.color = _gridColor;
    self.volumGridRenderer.width = .25f;
    self.volumGridRenderer.color = _gridColor;
    
    self.lineRenderer.width = .7f;
    self.lineRenderer.color = RGB(198, 119, 63);
    self.lineRenderer.dash = CGSizeMake(4, 2);
    
    self.priceRenderer.fillColor = RGB(248, 221, 203);
    self.priceRenderer.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    self.priceRenderer.offSetRatio = CGPointMake(0, -0.5);
    self.priceRenderer.font = _axisFont;
    
    self.ratoRenderer.fillColor = RGB(248, 221, 203);
    self.ratoRenderer.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    self.ratoRenderer.offSetRatio = CGPointMake(-1, -.5f);
    self.ratoRenderer.font = _axisFont;
}

- (void)setObjTimeAry:(NSArray<VolumeAbstract, MinuteAbstract> *)objTimeAry
{
    _objTimeAry = objTimeAry;
    
    CGFloat max = FLT_MIN;
    [objTimeAry getAbsMax:&max selGetter:@selector(ggTimePrice)];
    _KTimeChartMaxPrice = max;
    _KTimeChartMinPrice = [objTimeAry.firstObject ggTimeClosePrice] - (max - [objTimeAry.firstObject ggTimeClosePrice]);
    
    self.leftRenderer.aryString = [NSArray splitWithMax:_KTimeChartMaxPrice min:_KTimeChartMinPrice split:4 format:@"%.2f" attached:@""];
    self.rightRenderer.aryString = [self.leftRenderer.aryString percentageStringWithBase:[objTimeAry.firstObject ggTimeClosePrice]];
    self.bottomRenderer.aryString = @[@"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"13:30", @"14:00", @"14:30", @"15:00"];
    
    CGFloat barMax;
    CGFloat barMin;
    [_objTimeAry getMax:&barMax min:&barMin selGetter:@selector(ggVolume) base:0];
    self.volumRenderer.aryString = [NSArray splitWithMax:barMax min:0 split:2 format:@"%.f" attached:@"手"];
    
    [self configLineScaler];
    [self configBarScaler];
}

- (void)configLineScaler
{
    self.lineScaler.max = _KTimeChartMaxPrice;
    self.lineScaler.min = _KTimeChartMinPrice;
    self.lineScaler.xMaxCount = 240;
    self.lineScaler.xRatio = 0;
    [self.lineScaler setObjAry:_objTimeAry getSelector:@selector(ggTimePrice)];
    
    self.averageScaler.max = _KTimeChartMaxPrice;
    self.averageScaler.min = _KTimeChartMinPrice;
    self.averageScaler.xMaxCount = 240;
    self.averageScaler.xRatio = 0;
    [self.averageScaler setObjAry:_objTimeAry getSelector:@selector(ggTimeAveragePrice)];
}

- (void)drawLineChart
{
    // 分时线
    CGRect lineRect = [self lineRect];
    self.lineScaler.rect = lineRect;
    [self.lineScaler updateScaler];
    
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddLines(ref, NULL, self.lineScaler.linePoints, self.lineScaler.lineObjAry.count);
    GGShapeCanvas * shape = [self getGGCanvasEqualFrame];
    shape.strokeColor = _lineColor.CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.path = ref;
    CGPathRelease(ref);
    
    // 填充价格层
    CGMutablePathRef refFill = CGPathCreateMutable();
    CGPathAddLines(refFill, NULL, self.lineScaler.linePoints, self.lineScaler.lineObjAry.count);
    CGPathAddLineToPoint(refFill, NULL, self.lineScaler.linePoints[_objTimeAry.count - 1].x, CGRectGetMaxY(lineRect));
    CGPathAddLineToPoint(refFill, NULL, 0, CGRectGetMaxY(lineRect));
    CGPathAddLineToPoint(refFill, NULL, 0, self.lineScaler.linePoints[0].y);
    
    GGShapeCanvas * fillShape = [self getGGCanvasEqualFrame];
    fillShape.lineWidth = 0;
    fillShape.fillColor = [_lineColor colorWithAlphaComponent:.2f].CGColor;
    fillShape.path = refFill;
    CGPathRelease(refFill);
    
    self.averageScaler.rect = lineRect;
    [self.averageScaler updateScaler];
    
    // 均价线
    CGMutablePathRef avg_ref = CGPathCreateMutable();
    CGPathAddLines(avg_ref, NULL, self.averageScaler.linePoints, self.averageScaler.lineObjAry.count);
    GGShapeCanvas * avgShape = [self getGGCanvasEqualFrame];
    avgShape.strokeColor = _avgColor.CGColor;
    avgShape.fillColor = [UIColor clearColor].CGColor;
    avgShape.path = avg_ref;
    CGPathRelease(avg_ref);
    
    // 最新价格线
    CGPoint lastPricePoint = self.lineScaler.linePoints[self.objTimeAry.count - 1];
    self.lineRenderer.line = GGLineMake(0, lastPricePoint.y, CGRectGetMaxX(lineRect), lastPricePoint.y);
    self.priceRenderer.string = [NSString stringWithFormat:@"%.2f", [self.objTimeAry.lastObject ggTimePrice]];
    self.priceRenderer.color = [self.objTimeAry.lastObject ggTimePrice] > [self.objTimeAry.lastObject ggTimeClosePrice] ? _posColor : _negColor;
    self.priceRenderer.point = CGPointMake(0, lastPricePoint.y);
    
    
    CGFloat baseFloat = [self.objTimeAry.lastObject ggTimeClosePrice];
    CGFloat rato = [self.objTimeAry.lastObject ggTimePrice] - baseFloat;
    rato = ( (float) ( (int) (rato * 10000))) / 10000;
    self.ratoRenderer.string = [NSString stringWithFormat:@"%.2f%%", rato / baseFloat * 100];
    self.ratoRenderer.color = [self.objTimeAry.lastObject ggTimePrice] > [self.objTimeAry.lastObject ggTimeClosePrice] ? _posColor : _negColor;
    self.ratoRenderer.point = CGPointMake(CGRectGetMaxX(lineRect), lastPricePoint.y);
    
    // 设置动画点
    self.circleGradeAnimation.gradentColors = @[(__bridge id)_redColor.CGColor, (__bridge id)[UIColor whiteColor].CGColor];
}

- (void)configBarScaler
{
    CGFloat lineMax;
    CGFloat lineMin;
    [_objTimeAry getMax:&lineMax min:&lineMin selGetter:@selector(ggVolume) base:0];
    
    self.barScaler.max = lineMax;
    self.barScaler.min = 0;
    self.barScaler.xMaxCount = 240;
    self.barScaler.xRatio = 0;
    self.barScaler.barWidth = 1;
    [self.barScaler setObjAry:_objTimeAry getSelector:@selector(ggVolume)];
}

- (void)drawBarChart
{
    // 成交量
    CGRect barRect = [self volumRect];
    self.barScaler.rect = barRect;
    [self.barScaler updateScaler];
    
    CGMutablePathRef redBar = CGPathCreateMutable();
    CGMutablePathRef greenBar = CGPathCreateMutable();
    
    [self.objTimeAry enumerateObjectsUsingBlock:^(id <MinuteAbstract> obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUInteger before = idx == 0 ? 0 : idx - 1;
        CGFloat cur_price = [obj ggTimePrice];
        CGFloat before_price = [self.objTimeAry[before] ggTimePrice];
        
        CGRect barRect = self.barScaler.barRects[idx];
        cur_price >= before_price ? GGPathAddCGRect(redBar, barRect) : GGPathAddCGRect(greenBar, barRect);
    }];
    
    GGShapeCanvas * barRedShape = [self getGGCanvasEqualFrame];
    barRedShape.lineWidth = 0;
    barRedShape.strokeColor = _redColor.CGColor;
    barRedShape.fillColor = _redColor.CGColor;
    barRedShape.path = redBar;
    CGPathRelease(redBar);
    
    GGShapeCanvas * barGreenShape = [self getGGCanvasEqualFrame];
    barGreenShape.lineWidth = 0;
    barGreenShape.strokeColor = _greenColor.CGColor;
    barGreenShape.fillColor = _greenColor.CGColor;
    barGreenShape.path = greenBar;
    CGPathRelease(greenBar);
}

- (void)drawChart
{
    [super drawChart];
    
    [self drawLineChart];
    [self drawBarChart];
    
    [self configBackLayer];
    
    [self.backCanvas setNeedsDisplay];
    [self.animationCanvas setNeedsDisplay];
    [self addSubview:self.queryPriceView];
}

#pragma mark - Lazy

GGLazyGetMethod(DLineScaler, lineScaler);
GGLazyGetMethod(DLineScaler, averageScaler);
GGLazyGetMethod(DBarScaler, barScaler);

GGLazyGetMethod(GGCanvas, backCanvas);
GGLazyGetMethod(GGCanvas, animationCanvas);
GGLazyGetMethod(GGGridRenderer, gridRenderer);
GGLazyGetMethod(GGAxisRenderer, leftRenderer);
GGLazyGetMethod(GGAxisRenderer, rightRenderer);
GGLazyGetMethod(GGAxisRenderer, bottomRenderer);

GGLazyGetMethod(GGLineRenderer, lineRenderer);
GGLazyGetMethod(GGStringRenderer, priceRenderer);
GGLazyGetMethod(GGStringRenderer, ratoRenderer);

GGLazyGetMethod(GGGridRenderer, volumGridRenderer);
GGLazyGetMethod(GGAxisRenderer, volumRenderer);

GGLazyGetMethod(GGCircleRenderer, priceCircle);
GGLazyGetMethod(GGCircleRenderer, avgCircle);

GGLazyGetMethod(CrissCrossQueryView, queryPriceView);
GGLazyGetMethod(GGCircleRenderer, circleGradeAnimation);

@end
