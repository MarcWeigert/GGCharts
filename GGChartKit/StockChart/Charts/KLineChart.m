//
//  KLineChart.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KLineChart.h"
#import "CrissCrossQueryView.h"

#import "BaseIndexLayer.h"
#import "MAVOLLayer.h"

#import "NSDate+GGDate.h"
#import "NSObject+FireBlock.h"

#include <objc/runtime.h>

#define FONT_ARIAL	@"ArialMT"
#define SECOND                                  (1)
#define MINUTE                                  (60)
#define HOUR                                    (60 * 60)
#define DAY                                     (24 * 60 * 60)
#define WEEK                                    (7 * 24 * 60 * 60)

@interface KLineChart () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) DKLineScaler * kLineScaler;   ///< 定标器

@property (nonatomic, strong) CAShapeLayer * greenLineLayer;    ///< 绿色k线
@property (nonatomic, strong) CAShapeLayer * redLineLayer;      ///< 红色K线
@property (nonatomic, strong) CAShapeLayer * gridLayer;         ///< 网格层

@property (nonatomic, strong) GGAxisRenderer * axisRenderer;        ///< 轴渲染
@property (nonatomic, strong) GGAxisRenderer * kAxisRenderer;       ///< K线轴
@property (nonatomic, strong) GGAxisRenderer * vAxisRenderer;       ///< 成交量轴

@property (nonatomic, strong) CrissCrossQueryView * queryPriceView;     ///< 查价层

#pragma mark - 缩放手势

@property (nonatomic, assign) CGFloat currentZoom;  ///< 当前缩放比例
@property (nonatomic, assign) CGFloat zoomCenterSpacingLeft;    ///< 缩放中心K线位置距离左边的距离
@property (nonatomic, assign) NSUInteger zoomCenterIndex;     ///< 中心点k线

#pragma mark - 滑动手势

@property (nonatomic, assign) CGPoint lastPanPoint;     ///< 最后滑动的点
@property (nonatomic, assign) BOOL respondPanRecognizer;       ///< 是否相应滑动手势

@property (nonatomic, assign) BOOL disPlay;

#pragma mark - 指标

@property (nonatomic, strong) BaseIndexLayer * kLineIndexLayer;
@property (nonatomic, strong) BaseIndexLayer * volumIndexLayer;

@property (nonatomic, strong) UILabel * lableKLineIndex;
@property (nonatomic, strong) UILabel * lableVolumIndex;

@property (nonatomic, copy) void (^indexChangeBlk)(NSString *indexName);

@property (nonatomic, assign) BOOL isLoadingMore;       ///< 是否在刷新状态
@property (nonatomic, assign) BOOL isWaitPulling;       ///< 是否正在等待刷新

@end

@implementation KLineChart

+ (NSArray *)kLineIndexLayerClazzName
{
    return @[@"MA", @"EMA", @"MIKE", @"BOLL", @"BBI", @"TD"];
}

+ (NSArray *)kVolumIndexLayerClazzName
{
    return @[@"MAVOL", @"MACD", @"KDJ", @"RSI", @"ATR"];
}

#pragma mark - Setter

/** 指标切换回调 */
- (void)setIndexChangeBlock:(void(^)(NSString * indexName))block
{
    _indexChangeBlk = block;
}

/** 切换指标 */
- (void)setIndex:(NSString *)string
{
    NSArray * kLineAry = [KLineChart kLineIndexLayerClazzName];
    
    if ([kLineAry containsObject:string]) {
        
        _kLineIndexIndex = [kLineAry indexOfObject:string];
        [self updateKLineIndexLayer:_kLineIndexIndex];
    }
    
    NSArray * volumAry = [KLineChart kVolumIndexLayerClazzName];
    
    if ([volumAry containsObject:string]) {
        
        _volumIndexIndex = [volumAry indexOfObject:string];
        [self updateVolumIndexLayer:_volumIndexIndex];
    }
}

#pragma mark - Surper

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _disPlay = YES;
        _kLineIndexIndex = 0;
        _volumIndexIndex = 0;
        
        [self.backScrollView.layer addSublayer:self.gridLayer];
        [self.scrollView.layer addSublayer:self.redLineLayer];
        [self.scrollView.layer addSublayer:self.greenLineLayer];
        
        self.axisRenderer.width = 0.25;
        [self.stringLayer addRenderer:self.axisRenderer];
        self.kAxisRenderer.width = 0.25;
        [self.stringLayer addRenderer:self.kAxisRenderer];
        self.vAxisRenderer.width = 0.25;
        [self.stringLayer addRenderer:self.vAxisRenderer];
        
        [self addSubview:self.lableVolumIndex];
        [self addSubview:self.lableKLineIndex];
        
        _kAxisSplit = 7;
        _kInterval = 3;
        _kLineCountVisibale = 60;
        _kMaxCountVisibale = 120;
        _kMinCountVisibale = 20;
        _axisFont = [UIFont fontWithName:FONT_ARIAL size:10];
        _riseColor = RGB(234, 82, 83);
        _fallColor = RGB(77, 166, 73);
        _gridColor = RGB(225, 225, 225);
        _axisStringColor = C_HEX(0xaeb1b6);
        _currentZoom = -.001f;
        _kLineProportion = .6f;
        
        self.lableKLineIndex.font = [UIFont fontWithName:FONT_ARIAL size:8.5];
        self.lableVolumIndex.font = [UIFont fontWithName:FONT_ARIAL size:8.5];
        
        self.queryPriceView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.queryPriceView];
        
        UIPinchGestureRecognizer * pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchesViewOnGesturer:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressViewOnGesturer:)];
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchIndexLayer:)];
        [self addGestureRecognizer:tapRecognizer];
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
    return kLineObj.ggOpen > kLineObj.ggClose;
}

/**
 * 视图滚动
 */
- (void)scrollViewContentSizeDidChange
{
    [super scrollViewContentSizeDidChange];
    
    [self updateSubLayer];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

/** 结束刷新状态 */
- (void)endLoadingState
{
    self.isLoadingMore = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollViewContentSizeDidChange];
    
    if (scrollView.contentOffset.x < -40) {
        
        if (!self.isLoadingMore) {
            
            self.isWaitPulling = YES;
        }
    }
    
    if (self.isWaitPulling &&
        scrollView.contentOffset.x == 0) {
        
        self.isLoadingMore = YES;
        self.isWaitPulling = NO;
        
        if (self.RefreshBlock) {
            
            self.RefreshBlock();
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat minMove = self.kLineScaler.shapeWidth + self.kLineScaler.shapeInterval;
    self.scrollView.contentOffset = CGPointMake(round(self.scrollView.contentOffset.x / minMove) * minMove, 0);
    
    [self scrollViewContentSizeDidChange];
}

#pragma mark - K线手势

/** 长按十字星 */
- (void)longPressViewOnGesturer:(UILongPressGestureRecognizer *)recognizer
{
    self.scrollView.scrollEnabled = NO;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self updateSubLayer];
        
        self.scrollView.scrollEnabled = YES;
        self.queryPriceView.hidden = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint velocity = [recognizer locationInView:self];
        [self updateQueryLayerWithPoint:velocity];
        self.queryPriceView.hidden = NO;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [recognizer locationInView:self];
        [self updateQueryLayerWithPoint:velocity];
    }
}

/** 更新十字星查价框 */
- (void)updateQueryLayerWithPoint:(CGPoint)velocity
{
    CGPoint velocityInScroll = [self.scrollView convertPoint:velocity fromView:self.queryPriceView];
    NSInteger index = [self pointConvertIndex:velocityInScroll.x];
    id <KLineAbstract, QueryViewAbstract> kData = self.kLineArray[index];
    
    NSString * yString = @"";
    
    self.queryPriceView.xAxisOffsetY = self.redLineLayer.gg_height + 2;
    
    if (CGRectContainsPoint(self.redLineLayer.frame, velocity)) {
        
        yString = [NSString stringWithFormat:@"%.2f", [self.kLineScaler getPriceWithPoint:CGPointMake(0, velocity.y - self.redLineLayer.gg_top - self.queryPriceView.lineWidth + self.lableKLineIndex.gg_height)]];
    }
    else if (CGRectContainsPoint(self.redVolumLayer.frame, velocity)) {
        
        NSString * string = self.redVolumLayer.hidden ? @"" : @"万手";
        
        yString = [NSString stringWithFormat:@"%.2f%@", [self.volumScaler getPriceWithPoint:CGPointMake(0, velocity.y - self.queryPriceView.lineWidth - self.redVolumLayer.gg_top + self.lableVolumIndex.gg_height)], string];
    }
    
    [self updateIndexStringForIndex:index];
    
    NSString * title = [self getDateString:kData.ggKLineDate];
    [self.queryPriceView setYString:yString setXString:title];
    [self.queryPriceView.queryView setQueryData:kData];
    
    GGKShape shape = self.kLineScaler.kShapes[index];
    CGPoint queryVelocity = [self.scrollView convertPoint:shape.top toView:self.queryPriceView];
    [self.queryPriceView setCenterPoint:CGPointMake(queryVelocity.x, velocity.y)];
}

/** 日期转字符串 */
- (NSString *)getDateString:(NSDate *)date
{
    NSDateFormatter * showFormatter = [[NSDateFormatter alloc] init];
    showFormatter.dateFormat = @"yyyy-MM-dd";
    return [showFormatter stringFromDate:date];
}

/** 获取点对应的数据 */
- (NSInteger)pointConvertIndex:(CGFloat)x
{
    NSInteger idx = x / (self.kLineScaler.shapeWidth + self.kLineScaler.shapeInterval);
    return idx >= self.kLineScaler.kLineObjAry.count ? self.kLineScaler.kLineObjAry.count - 1 : idx;
}

/** 放大手势 */
-(void)pinchesViewOnGesturer:(UIPinchGestureRecognizer *)recognizer
{
    self.scrollView.scrollEnabled = NO;     // 放大禁用滚动手势
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        _currentZoom = recognizer.scale;
        
        self.scrollView.scrollEnabled = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateBegan && _currentZoom != 0.0f) {
        
        recognizer.scale = _currentZoom;
        
        CGPoint touch1 = [recognizer locationOfTouch:0 inView:self];
        CGPoint touch2 = [recognizer locationOfTouch:1 inView:self];
        
        // 放大开始记录位置等数据
        CGFloat center_x = (touch1.x + touch2.x) / 2.0f;
        _zoomCenterIndex = [self pointConvertIndex:self.scrollView.contentOffset.x + center_x];
        GGKShape shape = self.kLineScaler.kShapes[_zoomCenterIndex];
        _zoomCenterSpacingLeft = shape.top.x - self.scrollView.contentOffset.x;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat tmpZoom;
        tmpZoom = recognizer.scale / _currentZoom;
        _currentZoom = recognizer.scale;
        NSInteger showNum = round(_kLineCountVisibale / tmpZoom);
        
        // 避免没必要计算
        if (showNum == _kLineCountVisibale) { return; }
        if (showNum >= _kLineCountVisibale && _kLineCountVisibale == _kMaxCountVisibale) return;
        if (showNum <= _kLineCountVisibale && _kLineCountVisibale == _kMinCountVisibale) return;
        
        // 极大值极小值
        _kLineCountVisibale = showNum;
        _kLineCountVisibale = _kLineCountVisibale < _kMinCountVisibale ? _kMinCountVisibale : _kLineCountVisibale;
        _kLineCountVisibale = _kLineCountVisibale > _kMaxCountVisibale ? _kMaxCountVisibale : _kLineCountVisibale;
        
        [self kLineSubLayerRespond];
        
        // 定位中间的k线
        CGFloat shape_x = (_zoomCenterIndex + .5) * self.kLineScaler.shapeInterval + (_zoomCenterIndex + .5) * self.kLineScaler.shapeWidth;
        CGFloat offsetX = shape_x - _zoomCenterSpacingLeft;
        
        if (offsetX < 0) { offsetX = 0; }
        if (offsetX > self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
            offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
        }
        
        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    }
}

- (void)touchIndexLayer:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint velocity = [recognizer locationInView:self];
    CGPoint velocityInScroll = [self.scrollView convertPoint:velocity fromView:self.queryPriceView];
    
    if (CGRectContainsPoint(self.greenLineLayer.frame, velocityInScroll)) {
        
        _kLineIndexIndex++;
        
        if (_kLineIndexIndex > [[KLineChart kLineIndexLayerClazzName] count] - 1) {
            
            _kLineIndexIndex = 0;
        }
        
        [self updateKLineIndexLayer:_kLineIndexIndex];
    }
    
    if (CGRectContainsPoint(self.volumIndexLayer.frame, velocityInScroll)) {
        
        _volumIndexIndex++;
        
        if (_volumIndexIndex > [[KLineChart kVolumIndexLayerClazzName] count] - 1) {
            
            _volumIndexIndex = 0;
        }
        
        [self updateVolumIndexLayer:_volumIndexIndex];
    }
}

- (void)updateVolumIndexLayer:(NSInteger)index
{
    runMainThreadWithBlock(^{
        
        [_volumIndexLayer removeFromSuperlayer];
        
        _volumIndexIndexName = [KLineChart kVolumIndexLayerClazzName][index];
        Class clazz = NSClassFromString([_volumIndexIndexName stringByAppendingString:@"Layer"]);
        
        _volumIndexLayer = [[clazz alloc] init];
        _volumIndexLayer.frame = self.redVolumLayer.frame;
        [_volumIndexLayer setKLineArray:_kLineArray];
        _volumIndexLayer.currentKLineWidth = self.kLineScaler.shapeWidth;
        [self.scrollView.layer addSublayer:_volumIndexLayer];
        [self updateSubLayer];
        
        if (_indexChangeBlk) { _indexChangeBlk([KLineChart kVolumIndexLayerClazzName][index]); }
    });
}

- (void)updateKLineIndexLayer:(NSInteger)index
{
    runMainThreadWithBlock(^{
        
        [_kLineIndexLayer removeFromSuperlayer];
        
        _kLineIndexIndexName = [KLineChart kLineIndexLayerClazzName][index];
        Class clazz = NSClassFromString([_kLineIndexIndexName stringByAppendingString:@"Layer"]);
        
        _kLineIndexLayer = [[clazz alloc] init];
        _kLineIndexLayer.frame = self.redLineLayer.frame;
        _kLineIndexLayer.gg_width = self.kLineScaler.contentSize.width;
        [_kLineIndexLayer setKLineArray:_kLineArray];
        _kLineIndexLayer.currentKLineWidth = self.kLineScaler.shapeWidth;
        [self.scrollView.layer addSublayer:_kLineIndexLayer];
        [self updateSubLayer];
        
        if (_indexChangeBlk) { _indexChangeBlk([KLineChart kLineIndexLayerClazzName][index]); }
    });
}

#pragma mark - Setter

/** 设置k线方法 */
- (void)setKLineArray:(NSArray<id<KLineAbstract, VolumeAbstract, QueryViewAbstract>> *)kLineArray
{
    _kLineArray = kLineArray;
    
    [self.kLineScaler setObjArray:kLineArray
                          getOpen:@selector(ggOpen)
                         getClose:@selector(ggClose)
                          getHigh:@selector(ggHigh)
                           getLow:@selector(ggLow)];
    
    self.volumScaler = [[DBarScaler alloc] init];
    [self.volumScaler setObjAry:kLineArray
                    getSelector:@selector(ggVolume)];
    
    [_kLineIndexLayer setKLineArray:kLineArray];
    [_volumIndexLayer setKLineArray:kLineArray];
    
    [self updateKLineTitles:_kLineArray];
}

/** 设置k线以及类型 */
- (void)setKLineArray:(NSArray<id<KLineAbstract,VolumeAbstract,QueryViewAbstract>> *)kLineArray type:(KLineStyle)kType
{
    _kStyle = kType;
    
    [self setKLineArray:kLineArray];
}

#pragma mark - 背景网格层文字与轴线设置

static void * kLineTitle = "keyTitle";

- (void)updateKLineTitles:(NSArray<id<KLineAbstract, VolumeAbstract, QueryViewAbstract>> *)kLineArray
{
    if (_kStyle == KLineTypeDay) {
        
        __block NSInteger flag = 0;
        
        [kLineArray enumerateObjectsUsingBlock:^(id <KLineAbstract, VolumeAbstract, QueryViewAbstract> obj, NSUInteger idx, BOOL * stop) {
            
            NSString * title = nil;
            
            if (flag != obj.ggKLineDate.month) {
                
                title = [obj.ggKLineDate stringWithFormat:@"MM"];
                flag = obj.ggKLineDate.month;
            }
            
            if (title.integerValue == 1) {
                
                title = [obj.ggKLineDate stringWithFormat:@"yyyy/MM"];
            }
            
            objc_setAssociatedObject(obj, kLineTitle, title, OBJC_ASSOCIATION_COPY);
        }];
    }
    else if (_kStyle == KLineTypeWeek) {
        
        __block NSInteger flag = -2;
        
        [kLineArray enumerateObjectsUsingBlock:^(id <KLineAbstract, VolumeAbstract, QueryViewAbstract> obj, NSUInteger idx, BOOL * stop) {
            
            NSString * title = nil;
            
            if (2 < labs(flag - obj.ggKLineDate.month)) {
                
                title = [obj.ggKLineDate stringWithFormat:@"MM"];
                flag = obj.ggKLineDate.month;
            }
            
            if (title.integerValue == 1) {
                
                title = [obj.ggKLineDate stringWithFormat:@"yyyy/MM"];
            }
            
            objc_setAssociatedObject(obj, kLineTitle, title, OBJC_ASSOCIATION_COPY);
        }];
    }
    else if (_kStyle == KLineTypeMonth) {
        
        __block NSInteger flag = 0;
        
        [kLineArray enumerateObjectsUsingBlock:^(id <KLineAbstract, VolumeAbstract, QueryViewAbstract> obj, NSUInteger idx, BOOL * stop) {
            
            NSString * title = nil;
            
            if (flag < obj.ggKLineDate.year) {
                
                title = [obj.ggKLineDate stringWithFormat:@"yyyy/MM"];
                flag = obj.ggKLineDate.year + 1;
            }
            
            objc_setAssociatedObject(obj, kLineTitle, title, OBJC_ASSOCIATION_COPY);
        }];
    }
}

#pragma mark - 更新视图

- (void)updateChart
{
    if (_kLineArray.count == 0) { return; }
    
    [self baseConfigRendererAndLayer];
    
    [self kLineSubLayerRespond];
    
    // 指标层
    [self updateKLineIndexLayer:_kLineIndexIndex];
    [self updateVolumIndexLayer:_volumIndexIndex];
}

- (void)kLineSubLayerRespond
{
    [self baseConfigKLineLayer];
    
    [self updateSubLayer];
}

- (void)updateIndexStringForIndex:(NSInteger)index
{
    self.lableVolumIndex.attributedText = [self.volumIndexLayer attrStringWithIndex:index];
    self.lableKLineIndex.attributedText = [self.kLineIndexLayer attrStringWithIndex:index];
}

#pragma mark - rect

#define INDEX_STRING_INTERVAL   12
#define KLINE_VOLUM_INTERVAL    15

- (CGRect)kLineFrame
{
    return CGRectMake(0, INDEX_STRING_INTERVAL, self.frame.size.width, self.frame.size.height * _kLineProportion - INDEX_STRING_INTERVAL);
}

- (CGRect)volumFrame
{
    CGFloat highKLine = self.kLineFrame.size.height;
    CGFloat volumTop = INDEX_STRING_INTERVAL * 2 + highKLine + KLINE_VOLUM_INTERVAL;
    
    return CGRectMake(0, volumTop, self.kLineScaler.contentSize.width, self.frame.size.height - volumTop);
}

#pragma mark - 基础设置层

/** K线(主图)frame */
- (void)baseConfigKLineLayer
{
    // 设置K线
    self.redLineLayer.frame = self.kLineFrame;
    self.kLineScaler.rect = CGRectMake(0, 0, self.redLineLayer.gg_width, self.redLineLayer.gg_height);
    self.kLineScaler.shapeWidth = self.kLineScaler.rect.size.width / _kLineCountVisibale - _kInterval;
    self.kLineScaler.shapeInterval = _kInterval;
    
    // 设置附图宽度
    self.volumIndexLayer.currentKLineWidth = self.kLineScaler.shapeWidth;
    self.kLineIndexLayer.currentKLineWidth = self.kLineScaler.shapeWidth;
    
    CGSize contentSize = self.kLineScaler.contentSize;
    contentSize.width = contentSize.width < self.gg_width ? self.gg_width : contentSize.width;
    
    // 设置滚动位置关闭隐士动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.gridLayer.frame = CGRectMake(0, 0, contentSize.width, self.frame.size.height);
    
    // 滚动大小
    self.scrollView.contentSize = contentSize;
    self.backScrollView.contentSize = contentSize;
    
    // K线与K线指标大小
    self.redLineLayer.gg_size = contentSize;
    self.greenLineLayer.frame = self.redLineLayer.frame;
    self.kLineIndexLayer.frame = self.redLineLayer.frame;
    self.kLineIndexLayer.gg_width = self.kLineScaler.contentSize.width;
    
    self.lableKLineIndex.frame = CGRectMake(0, 0, self.gg_width, INDEX_STRING_INTERVAL);
    self.queryPriceView.frame = CGRectMake(0, self.redLineLayer.gg_top, self.gg_width, self.gg_height - self.redLineLayer.gg_top);
    
    // 量能区域的指标
    CGRect volumRect = self.volumFrame;
    [self setVolumRect:volumRect];
    self.volumScaler.rect = CGRectMake(0, 0, self.redVolumLayer.gg_width, self.redVolumLayer.gg_height);
    self.volumScaler.barWidth = self.kLineScaler.shapeWidth;
    self.lableVolumIndex.frame = CGRectMake(0, self.redLineLayer.gg_bottom + KLINE_VOLUM_INTERVAL, self.gg_width, INDEX_STRING_INTERVAL);
    
    // 量能区域的指标
    _volumIndexLayer.frame = volumRect;
    
    [CATransaction commit];
}

/** 基础配置渲染器 */
- (void)baseConfigRendererAndLayer
{
    // 成交量颜色设置
    self.redVolumLayer.strokeColor = _riseColor.CGColor;
    self.redVolumLayer.fillColor = _riseColor.CGColor;
    
    self.greenVolumLayer.strokeColor = _fallColor.CGColor;
    self.greenVolumLayer.fillColor = _fallColor.CGColor;
    
    // k线图颜色设置
    self.redLineLayer.strokeColor = _riseColor.CGColor;
    self.redLineLayer.fillColor = _riseColor.CGColor;
    
    self.greenLineLayer.strokeColor = _fallColor.CGColor;
    self.greenLineLayer.fillColor = _fallColor.CGColor;
    
    // 绘制文字网格层
    self.gridLayer.strokeColor = _gridColor.CGColor;
    self.gridLayer.fillColor = [UIColor clearColor].CGColor;
    self.gridLayer.lineWidth = .25f;
    
    // 成交量Y轴设置
    self.vAxisRenderer.strColor = _axisStringColor;
    self.vAxisRenderer.showLine = NO;
    self.vAxisRenderer.strFont = _axisFont;
    self.vAxisRenderer.offSetRatio = GGRatioTopRight;
    
    // K线Y轴设置
    self.kAxisRenderer.strColor = _axisStringColor;
    self.kAxisRenderer.showLine = NO;
    self.kAxisRenderer.strFont = _axisFont;
    self.kAxisRenderer.offSetRatio = GGRatioTopRight;
    
    // X横轴设置
    self.axisRenderer.strColor = _axisStringColor;
    self.axisRenderer.showLine = NO;
    self.axisRenderer.strFont = _axisFont;
    
    // 纵轴
    __weak KLineChart * weakSelf = self;
    
    [self.vAxisRenderer setStringBlock:^NSString *(CGPoint point, NSInteger index, NSInteger max) {
        if (index == 0) { return @""; }
        point.y = point.y - weakSelf.redVolumLayer.gg_top;
        NSString * string = weakSelf.redVolumLayer.hidden ? @"" : @"万手";
        return [NSString stringWithFormat:@"%.2f%@", [weakSelf.volumScaler getPriceWithYPixel:point.y], string];
    }];
    
    [self.kAxisRenderer setStringBlock:^NSString *(CGPoint point, NSInteger index, NSInteger max) {
        if (index == 0) { return @""; }
        point.y = point.y - weakSelf.redLineLayer.gg_top;
        return [NSString stringWithFormat:@"%.2f", [weakSelf.kLineScaler getPriceWithPoint:point]];
    }];
}

- (GGLine)lineWithX:(CGFloat)x rect:(CGRect)rect
{
    return GGLineMake(x, CGRectGetMinY(rect), x, CGRectGetMaxY(rect));
}

#pragma mark - 实时更新

- (void)updateSubLayer
{
    // 计算显示的在屏幕中的k线
    NSInteger index = round((self.scrollView.contentOffset.x - self.kLineScaler.rect.origin.x) / (self.kLineScaler.shapeInterval + self.kLineScaler.shapeWidth));
    NSInteger len = _kLineCountVisibale;
    
    if (index < 0) index = 0;
    if (index > _kLineArray.count) index = _kLineArray.count;
    if (index + _kLineCountVisibale > _kLineArray.count) { len = _kLineArray.count - index; }
    
    NSRange range = NSMakeRange(index, len);
    
    // 更新视图
    [self updateKLineLayerWithRange:range];
    [self updateVolumLayerWithRange:range];
    [self updateGridBackLayerWithRange:range];
    
    [self updateIndexStringForIndex:NSMaxRange(range) - 1];
}

/** 实时更新背景层 */
- (void)updateGridBackLayerWithRange:(NSRange)range
{
    CGMutablePathRef ref = CGPathCreateMutable();
    
    // 成交量网格
    CGFloat v_spe = self.redLineLayer.gg_height / _kAxisSplit;
    CGRect volumRect = self.redLineLayer.frame;
    volumRect.size.height = self.redVolumLayer.gg_height;
    volumRect.origin.y = self.redVolumLayer.gg_top;
    GGGrid gridVolum = GGGridRectMake(volumRect, v_spe, 0);
    GGPathAddGrid(ref, gridVolum);
    
    // k线网格
    CGRect lineRect = self.redLineLayer.frame;
    lineRect.size.width = self.gg_width;
    lineRect.origin.x = 0;
    GGGrid gridKLine = GGGridRectMake(self.redLineLayer.frame, v_spe, 0);
    GGPathAddGrid(ref, gridKLine);
    
    NSInteger maxCount = NSMaxRange(range);
    
    // 成交量Y轴设置
    GGLine leftLine = GGLeftLineRect(self.redVolumLayer.frame);
    self.vAxisRenderer.axis = GGAxisLineMake(leftLine, 0, v_spe);
    
    // K线Y轴设置
    leftLine = GGLeftLineRect(self.redLineLayer.frame);
    self.kAxisRenderer.axis = GGAxisLineMake(leftLine, 0, GGLengthLine(leftLine) / _kAxisSplit);
    
    // X横轴设置
    [self.axisRenderer removeAllPointString];
    self.axisRenderer.axis = GGAxisLineMake(GGBottomLineRect(self.frame), 1.5, 0);
    
    for (NSInteger i = range.location; i < maxCount; i++) {
        
        NSString * title = objc_getAssociatedObject(_kLineArray[i], kLineTitle);
        
        if (title.length) {
            
            CGFloat x = self.kLineScaler.kShapes[i].top.x;
            GGLine kline = [self lineWithX:x rect:self.greenLineLayer.frame];
            GGLine vline = [self lineWithX:x rect:self.redVolumLayer.frame];
            GGPathAddLine(ref, kline);
            GGPathAddLine(ref, vline);
            
            [self.axisRenderer addString:title point:CGPointMake(x - self.scrollView.contentOffset.x, CGRectGetMaxY(self.greenLineLayer.frame))];
        }
    }
    
    // K线不足屏幕仍然绘制剩余分割线
    CGSize size = self.kLineScaler.contentSize;
    
    if (size.width + self.greenLineLayer.gg_left < self.gg_width) {
        
        CGFloat drawX = size.width + self.greenLineLayer.gg_left;
        NSDate * before = [self.kLineArray.lastObject ggKLineDate];
        
        while (drawX < self.gg_width) {
            
            NSDate * date;
            NSInteger count = 0;
            
            if (_kStyle == KLineTypeDay) {
                
                date = [before dateAddMonthScalerFirstDay:1];
                count = [before interValDayWithoutWeekEndDay:date];
            }
            else if (_kStyle == KLineTypeWeek) {
                
                date = [before dateAddMonthScalerFirstDay:3];
                count = [before interValWeek:date];
            }
            else if (_kStyle == KLineTypeMonth) {
                
                date = [before dateAddYearScalerFistMonthDay:2];
                count = [before interValMonth:date];
            }
            else {
                
                break;
            }
            
            if (count == 0 || before == nil) {      // 没有日期判断
                
                break;
            }
            
            drawX += count * self.kLineScaler.interval;
            
            NSString * title = [date stringWithFormat:@"MM"];
            title = date.month == 1 || _kStyle == KLineTypeMonth ? [date stringWithFormat:@"yyyy/MM"] : title;
            
            [self.axisRenderer addString:title point:CGPointMake(drawX, CGRectGetMaxY(self.greenLineLayer.frame))];
            
            GGLine kline = [self lineWithX:drawX rect:self.greenLineLayer.frame];
            GGLine vline = [self lineWithX:drawX rect:self.redVolumLayer.frame];
            
            GGPathAddLine(ref, kline);
            GGPathAddLine(ref, vline);
            
            before = date;
        }
    }
    
    self.gridLayer.path = ref;
    CGPathRelease(ref);
    
    [self.stringLayer setNeedsDisplay];
}

/** K线图实时更新 */
- (void)updateKLineLayerWithRange:(NSRange)range
{
    // 计算k线最大最小
    CGFloat max = FLT_MIN;
    CGFloat min = FLT_MAX;
    [_kLineArray getKLineMax:&max min:&min range:range];
    
    // k线指标
    [_kLineIndexLayer getIndexWithRange:range max:&max min:&min];
    [_kLineIndexLayer updateLayerWithRange:range max:max min:min];
    
    // 更新k线层
    self.kLineScaler.max = max;
    self.kLineScaler.min = min;
    [self.kLineScaler updateScalerWithRange:range];
    
    CGMutablePathRef refRed = CGPathCreateMutable();
    CGMutablePathRef refGreen = CGPathCreateMutable();
    
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        
        id obj = _kLineArray[i];
        GGKShape shape = self.kLineScaler.kShapes[i];
        
        [self isRed:obj] ? GGPathAddKShape(refRed, shape) : GGPathAddKShape(refGreen, shape);
    }
    
    self.redLineLayer.path = refRed;
    CGPathRelease(refRed);
    self.greenLineLayer.path = refGreen;
    CGPathRelease(refGreen);
    
    [self.stringLayer setNeedsDisplay];
}

/** 柱状图实时更新 */
- (void)updateVolumLayerWithRange:(NSRange)range
{
    self.redVolumLayer.hidden = ![self.volumIndexLayer isKindOfClass:[MAVOLLayer class]];
    self.greenVolumLayer.hidden = ![self.volumIndexLayer isKindOfClass:[MAVOLLayer class]];
    
    // 计算柱状图最大最小
    CGFloat max = FLT_MIN;
    CGFloat min = FLT_MAX;
    NSString * attached = @"";
    
    if ([self.volumIndexLayer isKindOfClass:[MAVOLLayer class]]) {
        
        [_kLineArray getMax:&max min:&min selGetter:@selector(ggVolume) range:range base:0.1];
        min = 0;
        attached = @"万手";
    }
    
    [self.volumIndexLayer getIndexWithRange:range max:&max min:&min];
    [self.volumIndexLayer updateLayerWithRange:range max:max min:min];
    
    // 更新成交量
    self.volumScaler.min = 0;
    self.volumScaler.max = max;
    [self.volumScaler updateScalerWithRange:range];
    [self updateVolumLayer:range];
    
    [self.stringLayer setNeedsDisplay];
}

#pragma mark - Lazy

GGLazyGetMethod(CAShapeLayer, redLineLayer);
GGLazyGetMethod(CAShapeLayer, greenLineLayer);
GGLazyGetMethod(CAShapeLayer, gridLayer);

GGLazyGetMethod(UILabel, lableKLineIndex);
GGLazyGetMethod(UILabel, lableVolumIndex);

GGLazyGetMethod(GGAxisRenderer, axisRenderer);
GGLazyGetMethod(GGAxisRenderer, kAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, vAxisRenderer);

GGLazyGetMethod(DKLineScaler, kLineScaler);

GGLazyGetMethod(CrissCrossQueryView, queryPriceView);

@end
