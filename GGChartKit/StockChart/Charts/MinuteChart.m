//
//  TimeChart.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MinuteChart.h"
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
@property (nonatomic, strong) CADisplayLink * displayLink;

@property (nonatomic, assign) TimeChartType timeType;

@property (nonatomic, strong) NSArray * bottomTitleArray;       ///< 底部轴

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
        _dirAxisSplitCount = 2;
        _axisFont = [UIFont fontWithName:@"ArialMT" size:10];
        
        [self.layer addSublayer:self.backCanvas];
        [self.layer addSublayer:self.animationCanvas];
        self.animationCanvas.hidden = YES;
        
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
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayAnimationCircle)];
        self.displayLink.frameInterval = 3;
        self.displayLink.paused = YES;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
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


/** 是否正在交易 */
- (void)setTrading:(BOOL)trading
{
    self.displayLink.paused = !trading;
    self.animationCanvas.hidden = !trading;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.backCanvas.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.animationCanvas.frame = self.backCanvas.frame;
    self.queryPriceView.frame = CGRectMake(0, 15, frame.size.width, frame.size.height - 15);
}

- (void)updateRenderers
{
    CGFloat bottomSplit = self.timeType == TimeDay ? self.bottomRenderer.aryString.count : (self.bottomRenderer.aryString.count - 1);
    
    CGRect lineRect = [self lineRect];
    CGFloat ySplit = lineRect.size.height / (_dirAxisSplitCount * 2);
    CGFloat split = bottomSplit > 0 ? self.frame.size.width / bottomSplit : self.frame.size.width;
    
    self.leftRenderer.axis = GGAxisLineMake(GGLeftLineRect(lineRect), 0, ySplit);
    self.rightRenderer.axis = GGAxisLineMake(GGRightLineRect(lineRect), 0, ySplit);
    self.bottomRenderer.axis = GGAxisLineMake(GGBottomLineRect(lineRect), 1, split);
    self.gridRenderer.grid = GGGridRectMake(lineRect, ySplit, split);
    
    CGRect volumRect = [self volumRect];
    CGFloat yVolumSplit = volumRect.size.height / 2;
    self.volumRenderer.axis = GGAxisLineMake(GGLeftLineRect(volumRect), 0, yVolumSplit);
    self.volumGridRenderer.grid = GGGridRectMake(volumRect, yVolumSplit, split);
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
    NSInteger count = self.timeType == TimeDay ? _bottomTitleArray.count * 240 : 240;
    NSInteger index = velocity.x / (self.frame.size.width / count);
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
    
    NSString * format = self.timeType == TimeDay ? @"yyyy:MM:dd HH:mm" : @"HH:mm";
    [self.queryPriceView setYString:yString setXString:[[self.objTimeAry[index] ggTimeDate] stringWithFormat:format]];
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
    NSMutableArray * colorAry = [NSMutableArray array];
    
    CGFloat base = [[NSString stringWithFormat:@"%.2f", [self.objTimeAry.lastObject ggTimeClosePrice]] floatValue];
    
    [self.leftRenderer.aryString enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (base > obj.floatValue) {
            
            [colorAry addObject:_negColor];
        }
        else if (base < obj.floatValue) {
            
            [colorAry addObject:_posColor];
        }
        else {
            
            [colorAry addObject:_axisStringColor];
        }
    }];
    
    self.leftRenderer.strFont = _axisFont;
    self.leftRenderer.offSetRatio = GGRatioTopRight;
    self.leftRenderer.colorAry = colorAry;
    
    self.rightRenderer.strFont = _axisFont;
    self.rightRenderer.offSetRatio = GGRatioTopLeft;
    self.rightRenderer.colorAry = colorAry;
    
    self.bottomRenderer.strFont = _axisFont;
    self.bottomRenderer.strColor = _axisStringColor;
    self.bottomRenderer.offSetRatio = self.timeType == TimeDay ? GGRatioBottomCenter : GGRatioBottomRight;
    self.bottomRenderer.isStringFirstLastindent = YES;
    
    self.volumRenderer.strFont = _axisFont;
    self.volumRenderer.strColor = _axisStringColor;
    
    self.gridRenderer.width = .25f;
    self.gridRenderer.color = _gridColor;
    self.volumGridRenderer.width = .25f;
    self.volumGridRenderer.color = _gridColor;
    
    self.lineRenderer.width = .7f;
    self.lineRenderer.color = RGB(198, 119, 63);
    self.lineRenderer.dashPattern = @[@4, @2];
    
    self.priceRenderer.fillColor = RGB(248, 221, 203);
    self.priceRenderer.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    self.priceRenderer.offSetRatio = GGRatioCenterRight;
    self.priceRenderer.font = _axisFont;
    
    self.ratoRenderer.fillColor = RGB(248, 221, 203);
    self.ratoRenderer.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    self.ratoRenderer.offSetRatio = GGRatioCenterLeft;
    self.ratoRenderer.font = _axisFont;
}

/** 设置分时线数组 */
- (void)setMinuteTimeArray:(NSArray <MinuteAbstract, VolumeAbstract> *)objTimeArray timeChartType:(TimeChartType)type
{
    self.timeType = type;
    _objTimeAry = objTimeArray;
    
    // 更新底部轴文字
    if (self.timeType == TimeHalfAnHour) {
        
        _bottomTitleArray = @[@"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"13:30", @"14:00", @"14:30", @"15:00"];
    }
    else if (self.timeType == TimeMiddle) {
        
        _bottomTitleArray = @[@"9:30", @"11:30", @"15:30"];
    }
    else if (self.timeType == TimeDay) {
        
        NSMutableArray * aryBottomTitles = [NSMutableArray array];
        
        __block NSInteger day = 0;
        
        [self.objTimeAry enumerateObjectsUsingBlock:^(id <MinuteAbstract> obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSInteger currentDay = [[obj ggTimeDate] day];
            
            if (day != currentDay) {
                
                [aryBottomTitles addObject:[[obj ggTimeDate] stringWithFormat:@"yy-MM-dd"]];
                
                day = currentDay;
            }
        }];
        
        _bottomTitleArray = [NSArray arrayWithArray:aryBottomTitles];
    }
    
    if (self.timeType != TimeDay) {
        
        CGFloat max = FLT_MIN;
        CGFloat min = FLT_MAX;
        CGFloat closePrice = [self.objTimeAry.firstObject ggTimeClosePrice];
        [objTimeArray getMax:&max min:&min selGetter:@selector(ggTimePrice) base:0];
        
        CGFloat upBase = ABS(closePrice - max);
        CGFloat downBase = ABS(closePrice - min);
        CGFloat base = upBase > downBase ? upBase : downBase;
        
        _KTimeChartMaxPrice = closePrice + base;
        _KTimeChartMinPrice = closePrice - base;
        
        if (_KTimeChartMinPrice == _KTimeChartMaxPrice || closePrice == 0) {
            
            _KTimeChartMinPrice = [self.objTimeAry.firstObject ggTimePrice] * .98f;
            _KTimeChartMaxPrice = [self.objTimeAry.firstObject ggTimePrice] * 1.02f;
        }
    }
    else {
        
        CGFloat max = FLT_MIN;
        CGFloat min = FLT_MAX;
        [objTimeArray getMax:&max min:&min selGetter:@selector(ggTimePrice) base:.05f];
        _KTimeChartMaxPrice = max;
        _KTimeChartMinPrice = min;
    }
    
    if (!_objTimeAry.count) {
        
        _KTimeChartMaxPrice = 0;
        _KTimeChartMinPrice = 0;
    }
    
    [self configLineScaler];
    [self configBarScaler];
}

- (void)updateAxisStringPrice
{
    self.leftRenderer.aryString = [NSArray splitWithMax:_KTimeChartMaxPrice min:_KTimeChartMinPrice split:_dirAxisSplitCount * 2 format:@"%.2f" attached:@""];
    self.rightRenderer.aryString = [self.leftRenderer.aryString percentageStringWithBase:[self.objTimeAry.firstObject ggTimeClosePrice]];
    self.bottomRenderer.aryString = _bottomTitleArray;
    self.bottomRenderer.drawAxisCenter = self.timeType == TimeDay;
    
    CGFloat barMax;
    CGFloat barMin;
    [_objTimeAry getMax:&barMax min:&barMin selGetter:@selector(ggVolume) base:0];
    self.volumRenderer.aryString = [NSArray splitWithMax:barMax min:0 split:2 format:@"%.f" attached:@"手"];
}

- (void)configLineScaler
{
    self.lineScaler.max = _KTimeChartMaxPrice;
    self.lineScaler.min = _KTimeChartMinPrice;
    self.lineScaler.xMaxCount = self.timeType == TimeDay ? _bottomTitleArray.count * 240 : 240;
    self.lineScaler.xRatio = 0;
    [self.lineScaler setObjAry:_objTimeAry getSelector:@selector(ggTimePrice)];
    
    self.averageScaler.max = _KTimeChartMaxPrice;
    self.averageScaler.min = _KTimeChartMinPrice;
    self.averageScaler.xMaxCount = self.timeType == TimeDay ? _bottomTitleArray.count * 240 : 240;
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
    self.circleGradeAnimation.gradentColors = @[(__bridge id)_lineColor.CGColor, (__bridge id)[UIColor whiteColor].CGColor];
}

- (void)configBarScaler
{
    CGFloat lineMax;
    CGFloat lineMin;
    [_objTimeAry getMax:&lineMax min:&lineMin selGetter:@selector(ggVolume) base:0];
    
    self.barScaler.max = lineMax;
    self.barScaler.min = 0;
    self.barScaler.xMaxCount = self.timeType == TimeDay ? _bottomTitleArray.count * 240 : 240;
    self.barScaler.xRatio = 0;
    self.barScaler.barWidth = self.timeType == TimeDay ? .3f : 1;
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
    
    if (!self.objTimeAry.count) {
        
        [self updateAxisStringPrice];
        [self updateRenderers];
        [self configBackLayer];
        [self.backCanvas setNeedsDisplay];
        return;
    }
    
    [self drawLineChart];
    [self drawBarChart];
    
    [self updateAxisStringPrice];
    [self updateRenderers];
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
