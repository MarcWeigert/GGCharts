//
//  PieData.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieData.h"

@interface PieData ()
{
    DPieScaler * _ggPieScaler;
}

@end

@implementation PieData

/**
 * 初始化
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.radiusRange = GGRadiusRangeMake(.0f, 100.0f);
    }
    
    return self;
}

/**
 * 扇形图开始角度默认12点钟方向
 */
- (void)setPieStartTransform:(CGFloat)pieStartTransform
{
    self.pieScaler.baseArc = pieStartTransform;
}

/**
 * 扇形图开始角度默认12点钟方向
 */
- (CGFloat)pieStartTransform
{
    return self.pieScaler.baseArc;
}

/**
 * 扇形图半径区间默认{.0f, 100.0f}
 */
- (void)setRadiusRange:(GGRadiusRange)radiusRange
{
    _radiusRange = radiusRange;
    
    self.pieScaler.inRadius = _radiusRange.inRadius;
    self.pieScaler.outRadius = _radiusRange.outRadius;
}

/**
 * 扇形图
 */
- (void)setDataAry:(NSArray<NSNumber *> *)dataAry
{
    _dataAry = dataAry;
    
    [self.pieScaler setObjAry:dataAry getSelector:@selector(floatValue)];
}

/**
 * 扇形图比例
 */
- (CGFloat *)ratios
{
    return self.pieScaler.ratios;
}

/**
 * 扇形图结构体
 */
- (GGPie *)pies
{
    return self.pieScaler.pies;
}

/**
 * 折线图总和
 */
- (CGFloat)sum
{
    return self.pieScaler.sum;
}

/**
 * 折线图定标器
 */
- (DPieScaler *)pieScaler
{
    if (_ggPieScaler == nil) {
        
        _ggPieScaler = [[DPieScaler alloc] init];
    }
    
    return _ggPieScaler;
}

/**
 * 扇形图外边文字
 */
- (OutSideLable *)outSideLable
{
    if (_outSideLable == nil) {
        
        _outSideLable = [[OutSideLable alloc] init];
    }
    
    return _outSideLable;
}

/**
 * 扇形图内边文字
 */
- (InnerLable *)innerLable
{
    if (_innerLable == nil) {
        
        _innerLable = [[InnerLable alloc] init];
    }
    
    return _innerLable;
}

@end
