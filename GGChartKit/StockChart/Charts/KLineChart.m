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

@interface KLineChart ()

@property (nonatomic, strong) DKLineScaler * kLineScaler;   ///< 定标器

@property (nonatomic, strong) CAShapeLayer * greenLineLayer;    ///< 绿色k线
@property (nonatomic, strong) CAShapeLayer * redLineLayer;      ///< 红色K线

@end

@implementation KLineChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self.scrollView.layer addSublayer:self.redLineLayer];
        [self.scrollView.layer addSublayer:self.greenLineLayer];
        
        _kInterval = 3;
        _kLineCountVisibale = 60;
    }
    
    return self;
}

- (BOOL)volumIsRed:(id)obj
{
    return [self isRed:obj];
}

- (BOOL)isRed:(id <KLineAbstract>)kLineObj
{
    return kLineObj.ggOpen >= kLineObj.ggClose;
}

- (void)setKLineArray:(NSArray<id<KLineAbstract, VolumeAbstract>> *)kLineArray
{
    _kLineArray = kLineArray;
    
    [self.kLineScaler setObjArray:kLineArray
                          getOpen:@selector(ggOpen)
                         getClose:@selector(ggClose)
                          getHigh:@selector(ggHigh)
                           getLow:@selector(ggLow)];
}

- (void)updateChart
{
    [self baseConfigKLineLayer];
    
    [self updateSubLayer];
}

- (void)baseConfigKLineLayer
{
    self.redLineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * .6f);
    self.kLineScaler.rect = self.redLineLayer.frame;
    self.kLineScaler.shapeWidth = self.kLineScaler.rect.size.width / _kLineCountVisibale - _kInterval;
    self.kLineScaler.shapeInterval = _kInterval;
    self.scrollView.contentSize = self.kLineScaler.contentSize;
    
    self.redLineLayer.strokeColor = RGB(216, 94, 101).CGColor;
    self.redLineLayer.fillColor = RGB(216, 94, 101).CGColor;
    self.redLineLayer.gg_width = self.kLineScaler.contentSize.width;
    
    self.greenLineLayer.strokeColor = RGB(150, 234, 166).CGColor;
    self.greenLineLayer.fillColor = RGB(150, 234, 166).CGColor;
    self.greenLineLayer.frame = CGRectMake(0, 0, self.kLineScaler.contentSize.width, self.kLineScaler.contentSize.height);
    
    // 成交量
    self.redVolumLayer.strokeColor = RGB(216, 94, 101).CGColor;
    self.redVolumLayer.fillColor = RGB(216, 94, 101).CGColor;
    
    self.greenVolumLayer.strokeColor = RGB(150, 234, 166).CGColor;
    self.greenVolumLayer.fillColor = RGB(150, 234, 166).CGColor;
    
    CGRect volumRect = CGRectMake(0, self.redLineLayer.gg_bottom + 10, self.kLineScaler.contentSize.width, self.frame.size.height - self.redLineLayer.gg_bottom - 10);
    
    [self setVolumRect:volumRect];
    self.volumScaler.rect = CGRectMake(_kInterval / 2, 0, self.redVolumLayer.gg_width - _kInterval, self.redVolumLayer.gg_height);
    self.volumScaler.barWidth = self.kLineScaler.shapeWidth;
    [self.volumScaler setObjAry:_kLineArray getSelector:@selector(ggVolume)];
}

- (void)updateSubLayer
{
    NSInteger index = (self.scrollView.contentOffset.x - self.kLineScaler.rect.origin.x) / (self.kLineScaler.shapeInterval + self.kLineScaler.shapeWidth);
    NSInteger len = _kLineCountVisibale;
    
    if (index < 0) index = 0;
    if (index > _kLineArray.count) index = _kLineArray.count;
    if (index + _kLineCountVisibale > _kLineArray.count) { len = _kLineArray.count - index; }
    
    NSRange range = NSMakeRange(index, len);
    
    [self updateKLineLayerWithRange:range];
    [self updateVolumLayerWithRange:range];
}

- (void)updateKLineLayerWithRange:(NSRange)range
{
    CGFloat max = 0;
    CGFloat min = 0;
    [_kLineArray getKLineMax:&max min:&min range:range];
    
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
}

- (void)updateVolumLayerWithRange:(NSRange)range
{
    // 柱状图
    CGFloat barMax = 0;
    CGFloat barMin = 0;
    [_kLineArray getMax:&barMax min:&barMin selGetter:@selector(ggVolume) range:range];
    
    self.volumScaler.min = 0;
    self.volumScaler.max = barMax;
    [self.volumScaler updateScaler];
    [self updateVolumLayer];
}

#pragma mark - Surper

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    [self updateSubLayer];
}

#pragma mark - Lazy

GGLazyGetMethod(CAShapeLayer, redLineLayer);
GGLazyGetMethod(CAShapeLayer, greenLineLayer);
GGLazyGetMethod(DKLineScaler, kLineScaler);

@end
