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
        
        self.redLineLayer.backgroundColor = [UIColor blueColor].CGColor;
    }
    
    return self;
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
    
    [self updateKLineLayer];
}

- (void)baseConfigKLineLayer
{
    self.redLineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * .6f);
    self.kLineScaler.rect = self.redLineLayer.frame;
    self.kLineScaler.shapeWidth = self.kLineScaler.rect.size.width / _kLineCountVisibale - _kInterval;
    self.kLineScaler.shapeInterval = _kInterval;
    self.scrollView.contentSize = self.kLineScaler.contentSize;
    
    self.redLineLayer.strokeColor = [UIColor redColor].CGColor;
    self.redLineLayer.fillColor = [UIColor redColor].CGColor;
    self.redLineLayer.gg_width = self.kLineScaler.contentSize.width;
    
    self.greenLineLayer.strokeColor = [UIColor greenColor].CGColor;
    self.greenLineLayer.fillColor = [UIColor greenColor].CGColor;
    self.greenLineLayer.frame = CGRectMake(0, 0, self.kLineScaler.contentSize.width, self.kLineScaler.contentSize.height);
}

- (void)updateKLineLayer
{
    NSInteger index = (self.scrollView.contentOffset.x - self.kLineScaler.rect.origin.x) / (self.kLineScaler.shapeInterval + self.kLineScaler.shapeWidth);
    NSInteger len = _kLineCountVisibale;
    
    if (index < 0) index = 0;
    if (index > _kLineArray.count) index = _kLineArray.count;
    if (index + _kLineCountVisibale > _kLineArray.count) { len = _kLineArray.count - index; }
    
    CGFloat max = 0;
    CGFloat min = 0;
    [_kLineArray getKLineMax:&max min:&min range:NSMakeRange(index, len)];
    
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

#pragma mark - Surper

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    [self updateKLineLayer];
}

#pragma mark - Lazy

GGLazyGetMethod(CAShapeLayer, redLineLayer);
GGLazyGetMethod(CAShapeLayer, greenLineLayer);
GGLazyGetMethod(DKLineScaler, kLineScaler);

@end
