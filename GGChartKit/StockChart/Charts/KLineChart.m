//
//  KLineChart.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KLineChart.h"
#import "GGChartDefine.h"
#import "NSArray+Stock.h"

#define FONT_ARIAL	@"ArialMT"

@interface KLineChart ()

@property (nonatomic, strong) DKLineScaler * kLineScaler;   ///< 定标器

@property (nonatomic, strong) CAShapeLayer * greenLineLayer;    ///< 绿色k线
@property (nonatomic, strong) CAShapeLayer * redLineLayer;      ///< 红色K线

@property (nonatomic, strong) GGGridRenderer * kLineGrid;       ///< k线网格渲染器
@property (nonatomic, strong) GGGridRenderer * volumGrid;       ///< k线网格渲染器

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;        ///< 轴渲染
@property (nonatomic, strong) GGAxisRenderer * kAxisRenderer;       ///< K线轴
@property (nonatomic, strong) GGAxisRenderer * vAxisRenderer;       ///< 成交量轴

@property (nonatomic, assign) CGFloat currentZoom;  ///< 当前缩放比例
@property (nonatomic, assign) CGFloat zoomCenterSpacingLeft;    ///< 缩放中心K线位置距离左边的距离
@property (nonatomic, assign) NSUInteger zoomCenterIndex;     ///< 中心点k线

@end

@implementation KLineChart

#pragma mark - Surper

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        [self.scrollView.layer addSublayer:self.redLineLayer];
        [self.scrollView.layer addSublayer:self.greenLineLayer];
        
        self.volumGrid.width = 0.25;
        [self.kLineBackLayer addRenderer:self.volumGrid];
        self.kLineGrid.width = 0.25;
        [self.kLineBackLayer addRenderer:self.kLineGrid];
        
        self.axisRenderer.width = 0.25;
        [self.kLineBackLayer addRenderer:self.axisRenderer];
        
        self.kAxisRenderer.width = 0.25;
        [self.stringLayer addRenderer:self.kAxisRenderer];
        self.vAxisRenderer.width = 0.25;
        [self.stringLayer addRenderer:self.vAxisRenderer];
        
        _kAxisSplit = 7;
        _kInterval = 3;
        _kLineCountVisibale = 60;
        _kMaxCountVisibale = 120;
        _kMinCountVisibale = 20;
        _axisFont = [UIFont fontWithName:FONT_ARIAL size:10];
        _riseColor = RGB(216, 94, 101);
        _fallColor = RGB(150, 234, 166);
        _gridColor = RGB(225, 225, 225);
        _axisStringColor = C_HEX(0xaeb1b6);
        _currentZoom = -.001f;
        
        /*create the pinch Gesture Recognizer*/
        UIPinchGestureRecognizer * pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
        
        [self addGestureRecognizer:pinchGestureRecognizer];
    }
    
    return self;
}

/** 成交量是否为红 */
- (BOOL)volumIsRed:(id)obj
{
    return [self isRed:obj];
}

/** k线是否为红 */
- (BOOL)isRed:(id <KLineAbstract>)kLineObj
{
    return kLineObj.ggOpen >= kLineObj.ggClose;
}

/** 滚动 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    [self updateSubLayer];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollViewContentSizeDidChange:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat minMove = self.kLineScaler.shapeWidth + self.kLineScaler.shapeInterval;
    self.scrollView.contentOffset = CGPointMake(round(self.scrollView.contentOffset.x / minMove) * minMove, 0);
    
    [self scrollViewContentSizeDidChange:nil];
}

#pragma mark - K线捏合

-(void)handlePinches:(UIPinchGestureRecognizer *)paramSender
{
    self.scrollView.scrollEnabled = NO;     // 放大禁用滚动手势
    
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        
        _currentZoom = paramSender.scale;
        
        self.scrollView.scrollEnabled = YES;
    }
    else if (paramSender.state == UIGestureRecognizerStateBegan && _currentZoom != 0.0f) {
        
        paramSender.scale = _currentZoom;
        
        CGPoint touch1 = [paramSender locationOfTouch:0 inView:self];
        CGPoint touch2 = [paramSender locationOfTouch:1 inView:self];

        // 放大开始记录位置等数据
        CGFloat center_x = (touch1.x + touch2.x) / 2.0f;
        _zoomCenterIndex = (self.scrollView.contentOffset.x + center_x) / (self.kLineScaler.shapeWidth + self.kLineScaler.shapeInterval);
        GGKShape shape = self.kLineScaler.kShapes[_zoomCenterIndex];
        _zoomCenterSpacingLeft = shape.top.x - self.scrollView.contentOffset.x;
    }
    else if (paramSender.state == UIGestureRecognizerStateChanged) {
    
        CGFloat tmpZoom;
        tmpZoom = paramSender.scale / _currentZoom;
        _currentZoom = paramSender.scale;
        NSInteger showNum = round(_kLineCountVisibale / tmpZoom);
        
        // 避免没必要计算
        if (showNum == _kLineCountVisibale) { return; }
        if (showNum >= _kLineCountVisibale  && _kLineCountVisibale == _kMaxCountVisibale) return;
        if (showNum <= _kLineCountVisibale  && _kLineCountVisibale == _kMinCountVisibale) return;
        
        // 极大值极小值
        _kLineCountVisibale = showNum;
        _kLineCountVisibale = _kLineCountVisibale < 20 ? 20 : _kLineCountVisibale;
        _kLineCountVisibale = _kLineCountVisibale > 120 ? 120 : _kLineCountVisibale;
        
        [self updateChart];
        
        GGKShape shape = self.kLineScaler.kShapes[_zoomCenterIndex];
        CGFloat offsetX = shape.top.x - _zoomCenterSpacingLeft;
        
        if (offsetX < 0) { offsetX = 0; }
        if (offsetX > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
            offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
        }
        
        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    }
}

#pragma mark - Setter

/** 设置k线方法 */
- (void)setKLineArray:(NSArray<id<KLineAbstract, VolumeAbstract>> *)kLineArray
{
    _kLineArray = kLineArray;
    
    [self.kLineScaler setObjArray:kLineArray
                          getOpen:@selector(ggOpen)
                         getClose:@selector(ggClose)
                          getHigh:@selector(ggHigh)
                           getLow:@selector(ggLow)];
}

#pragma mark - 更新视图

- (void)updateChart
{
    [self baseConfigKLineLayer];
    [self baseConfigVolumLayer];
    //[self updateKLineGridLayer];
    
    [self updateSubLayer];
}

#pragma mark - 基础设置层

/** K线 */
- (void)baseConfigKLineLayer
{
    self.redLineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * .6f);
    self.kLineScaler.rect = self.redLineLayer.frame;
    self.kLineScaler.shapeWidth = self.kLineScaler.rect.size.width / _kLineCountVisibale - _kInterval;
    self.kLineScaler.shapeInterval = _kInterval;
    
    CGSize contentSize = self.kLineScaler.contentSize;
    self.scrollView.contentSize = contentSize;
    self.backScrollView.contentSize = contentSize;
    
    self.redLineLayer.strokeColor = _riseColor.CGColor;
    self.redLineLayer.fillColor = _riseColor.CGColor;
    self.redLineLayer.gg_width = contentSize.width;
    
    self.greenLineLayer.strokeColor = _fallColor.CGColor;
    self.greenLineLayer.fillColor = _fallColor.CGColor;
    self.greenLineLayer.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
}

/** 成交量 */
- (void)baseConfigVolumLayer
{
    self.redVolumLayer.strokeColor = _riseColor.CGColor;
    self.redVolumLayer.fillColor = _riseColor.CGColor;
    
    self.greenVolumLayer.strokeColor = _fallColor.CGColor;
    self.greenVolumLayer.fillColor = _fallColor.CGColor;
    
    CGFloat volumKLineSep = 15;
    CGRect volumRect = CGRectMake(0, self.redLineLayer.gg_bottom + volumKLineSep, self.kLineScaler.contentSize.width, self.frame.size.height - self.redLineLayer.gg_bottom - volumKLineSep);
    
    [self setVolumRect:volumRect];
    self.volumScaler.rect = CGRectMake(_kInterval / 2, 0, self.redVolumLayer.gg_width - _kInterval, self.redVolumLayer.gg_height);
    self.volumScaler.barWidth = self.kLineScaler.shapeWidth;
    [self.volumScaler setObjAry:_kLineArray getSelector:@selector(ggVolume)];
}

/** 更新k线背景层 */
- (void)updateKLineGridLayer
{
    // 纵向分割高度
    CGFloat v_spe = self.greenLineLayer.gg_height / _kAxisSplit;
    
    // 成交量网格设置
    self.volumGrid.color = _gridColor;
    self.volumGrid.grid = GGGridRectMake(self.redVolumLayer.frame, v_spe, 0);
    
    // 成交量Y轴设置
    GGLine leftLine = GGLeftLineRect(self.redVolumLayer.frame);
    self.vAxisRenderer.strColor = _axisStringColor;
    self.vAxisRenderer.showLine = NO;
    self.vAxisRenderer.strFont = _axisFont;
    self.vAxisRenderer.axis = GGAxisLineMake(leftLine, 0, v_spe);
    self.vAxisRenderer.offSetRatio = CGPointMake(0, -1);
    
    // K线Y轴设置
    leftLine = GGLeftLineRect(self.greenLineLayer.frame);
    self.kAxisRenderer.strColor = _axisStringColor;
    self.kAxisRenderer.showLine = NO;
    self.kAxisRenderer.strFont = _axisFont;
    self.kAxisRenderer.axis = GGAxisLineMake(leftLine, 0, GGLengthLine(leftLine) / _kAxisSplit);
    self.kAxisRenderer.offSetRatio = CGPointMake(0, -1);
    
    // X横轴设置
    self.axisRenderer.strColor = _axisStringColor;
    self.axisRenderer.showLine = NO;
    self.axisRenderer.strFont = _axisFont;
    self.axisRenderer.axis = GGAxisLineMake(GGBottomLineRect(self.greenLineLayer.frame), 1.5, 0);
    
    // K线网格设置
    self.kLineGrid.color = _gridColor;
    self.kLineGrid.grid = GGGridRectMake(self.greenLineLayer.frame, v_spe, 0);
    
    [self.kLineGrid removeAllLine];
    
    [_kLineArray enumerateObjectsUsingBlock:^(id<KLineAbstract,VolumeAbstract> obj, NSUInteger idx, BOOL * stop) {
        
        if ([obj isShowTitle]) {
            
            CGFloat x = self.kLineScaler.kShapes[idx].top.x;
            [self.axisRenderer addString:obj.ggKLineTitle point:CGPointMake(x, CGRectGetMaxY(self.greenLineLayer.frame))];
            
            if (idx == 0) { return; }
            
            GGLine kline = [self lineWithX:x rect:self.greenLineLayer.frame];
            GGLine vline = [self lineWithX:x rect:self.redVolumLayer.frame];
            [self.kLineGrid addLine:kline];
            [self.kLineGrid addLine:vline];
        }
    }];
    
    self.kLineBackLayer.frame =CGRectMake(0, 0, self.greenLineLayer.gg_width, self.backScrollView.frame.size.height);
    [self.kLineBackLayer setNeedsDisplay];
}

- (GGLine)lineWithX:(CGFloat)x rect:(CGRect)rect
{
    return GGLineMake(x, CGRectGetMinY(rect), x, CGRectGetMaxY(rect));
}

#pragma mark - 实时更新

- (void)updateSubLayer
{
    // 计算显示的在屏幕中的k线
    NSInteger index = (self.scrollView.contentOffset.x - self.kLineScaler.rect.origin.x) / (self.kLineScaler.shapeInterval + self.kLineScaler.shapeWidth);
    NSInteger len = _kLineCountVisibale;
    
    if (index < 0) index = 0;
    if (index > _kLineArray.count) index = _kLineArray.count;
    if (index + _kLineCountVisibale > _kLineArray.count) { len = _kLineArray.count - index; }
    
    NSRange range = NSMakeRange(index, len);
    
    // 更新视图
    [self updateKLineLayerWithRange:range];
    [self updateVolumLayerWithRange:range];
}

/** K线图实时更新 */
- (void)updateKLineLayerWithRange:(NSRange)range
{
    // 计算k线最大最小
    CGFloat max = 0;
    CGFloat min = 0;
    [_kLineArray getKLineMax:&max min:&min range:range];
    
    // 更新k线层
    self.kLineScaler.max = max;
    self.kLineScaler.min = min;
    [self.kLineScaler updateScaler];
    
    CGMutablePathRef refRed = CGPathCreateMutable();
    CGMutablePathRef refGreen = CGPathCreateMutable();
    
    [_kLineArray enumerateObjectsUsingBlock:^(id<KLineAbstract, VolumeAbstract> obj, NSUInteger idx, BOOL * stop) {
        
        GGKShape shape = self.kLineScaler.kShapes[idx];
        
        [self isRed:obj] ? GGPathAddKShape(refRed, shape) : GGPathAddKShape(refGreen, shape);
    }];
    
    self.redLineLayer.path = refRed;
    CGPathRelease(refRed);
    self.greenLineLayer.path = refGreen;
    CGPathRelease(refGreen);
    
    // 更新k线Y轴
    self.kAxisRenderer.aryString = [NSArray splitWithMax:max min:min split:_kAxisSplit + 1 format:@"%.2f" attached:@""];
    self.vAxisRenderer.range = NSMakeRange(1, _kAxisSplit);
    [self.stringLayer setNeedsDisplay];
}

/** 柱状图实时更新 */
- (void)updateVolumLayerWithRange:(NSRange)range
{
    // 计算柱状图最大最小
    CGFloat barMax = 0;
    CGFloat barMin = 0;
    [_kLineArray getMax:&barMax min:&barMin selGetter:@selector(ggVolume) range:range base:0.1];
    
    // 更新成交量
    self.volumScaler.min = 0;
    self.volumScaler.max = barMax;
    [self.volumScaler updateScaler];
    [self updateVolumLayer];
    
    // 更新成交量Y轴
    CGFloat v_spe = self.greenLineLayer.gg_height / _kAxisSplit;
    CGFloat high = CGRectGetHeight(self.redVolumLayer.frame);
    NSUInteger volumCount = high / v_spe;
    self.vAxisRenderer.aryString = [NSArray splitWithMax:barMax min:0 split:volumCount format:@"%.1f" attached:@"万手"];
    self.vAxisRenderer.range = NSMakeRange(1, volumCount - 1);
    [self.stringLayer setNeedsDisplay];
}

#pragma mark - Lazy

GGLazyGetMethod(CAShapeLayer, redLineLayer);
GGLazyGetMethod(CAShapeLayer, greenLineLayer);

GGLazyGetMethod(GGGridRenderer, kLineGrid);
GGLazyGetMethod(GGGridRenderer, volumGrid);

GGLazyGetMethod(GGAxisRenderer, axisRenderer);
GGLazyGetMethod(GGAxisRenderer, kAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, vAxisRenderer);

GGLazyGetMethod(DKLineScaler, kLineScaler);

@end
