//
//  BaseIndexLayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseIndexLayer.h"
#import "DLineScaler.h"
#import "KLineIndexManager.h"
#import "GGGraphics.h"

@interface BaseIndexLayer ()

#pragma mark - 线

@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> * aryLineLayer;
@property (nonatomic, strong) NSMutableArray <DLineScaler *> * aryLineScalar;

#pragma mark - 柱

@property (nonatomic, strong) DBarScaler * barScaler;
@property (nonatomic, strong) CAShapeLayer * positiveLayer;
@property (nonatomic, strong) CAShapeLayer * negativeLayer;

@end

@implementation BaseIndexLayer

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    for (NSUInteger idx = 0; idx < self.aryLineLayer.count; idx++) {
        
        CAShapeLayer * obj = self.aryLineLayer[idx];
        
        obj.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    
    _positiveLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _negativeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

/**
 * 绘制折线
 *
 * @param array 绘制数据格式 @[@{@"MA5" : xxx, @"MA10" : xxx}, ...]
 * @param keys 数据对象 @[@"MA5", @"MA10", ...]
 * @param colorForKeys 绘制数据对应颜色 @{@"MA5" : [UIColor red], @"MA10", ...};
 */
- (void)registerLinesForDictionary:(NSArray <NSDictionary *> *)array
                              keys:(NSArray *)keys
                      colorForKeys:(NSDictionary *)colorForKeys
{
    // 删除所有层
    for (NSUInteger idx = 0; idx < self.aryLineLayer.count; idx++) {
        CAShapeLayer * layer = self.aryLineLayer[idx];
        [layer removeFromSuperlayer];
    }
    
    // 重置所有数据
    [self.aryLineLayer removeAllObjects];
    [self.aryLineScalar removeAllObjects];
    
    // 数据格式转换
    NSMutableDictionary * dictionaryIndexs = [NSMutableDictionary dictionary];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
        
        [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL * stop) {
            
            NSMutableArray * aryNumber = dictionaryIndexs[key];
            
            if (!aryNumber) {
                
                aryNumber = [NSMutableArray array];
                [dictionaryIndexs setValue:aryNumber forKey:key];
            }
            
            [aryNumber addObject:obj[key]];
        }];
    }];
    
    for (NSInteger i = 0; i < keys.count; i++) {
        
        id key = keys[i];
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [colorForKeys[key] CGColor];
        layer.lineWidth = 1;
        layer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self addSublayer:layer];
        [self.aryLineLayer addObject:layer];
        
        DLineScaler * scaler = [DLineScaler new];
        scaler.dataAry = dictionaryIndexs[key];
        
        [self.aryLineScalar addObject:scaler];
    }
}

/**
 * 绘制柱状图
 *
 * @param dictionary 绘制数据格式 @[@{@"MA5" : xxx, @"MA10" : xxx}, ...]
 * @param key 绘制标签
 * @param positiveColor 正数颜色
 * @param negativeColor 负数颜色
 */
- (void)registerBarsForDictionary:(NSArray <NSDictionary *> *)dictionary
                              key:(NSString *)key
                    positiveColor:(UIColor *)positiveColor
                    negativeColor:(UIColor *)negativeColor
{
    [_positiveLayer removeFromSuperlayer];
    [_negativeLayer removeFromSuperlayer];
    
    __block NSMutableArray * aryNumber = [NSMutableArray array];
    
    [dictionary enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
        
        [aryNumber addObject:obj[key]];
    }];
    
    _negativeLayer = [CAShapeLayer layer];
    _negativeLayer.fillColor = negativeColor.CGColor;
    _negativeLayer.strokeColor = negativeColor.CGColor;
    _negativeLayer.lineWidth = 0;
    _negativeLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_negativeLayer];
    
    _positiveLayer = [CAShapeLayer layer];
    _positiveLayer.fillColor = positiveColor.CGColor;
    _positiveLayer.strokeColor = positiveColor.CGColor;
    _positiveLayer.lineWidth = 0;
    _positiveLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_positiveLayer];
    
    _barScaler = [DBarScaler new];
    _barScaler.dataAry = aryNumber;
}

/**
 * 绘制层数据
 */
- (void)updateLineLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min
{
    for (NSUInteger idx = 0; idx < self.aryLineLayer.count; idx++) {
        
        CAShapeLayer * obj = self.aryLineLayer[idx];
        
        DLineScaler * lineScaler = self.aryLineScalar[idx];
        lineScaler.max = max;
        lineScaler.min = min;
        lineScaler.rect = obj.frame;
        [lineScaler updateScalerWithRange:range];
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddRangePoints(ref, lineScaler.linePoints, range);
        obj.path = ref;
        CGPathRelease(ref);
    }
}

/**
 * 绘制层数据(柱)
 */
- (void)updateBarLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min
{
    _barScaler.max = max;
    _barScaler.min = min;
    _barScaler.rect = _positiveLayer.frame;
    _barScaler.aroundNumber = @0;
    _barScaler.barWidth = 1;
    [_barScaler updateScalerWithRange:range];
    
    CGMutablePathRef ref_p = CGPathCreateMutable();
    CGMutablePathRef ref_n = CGPathCreateMutable();
    
    [_barScaler getNegativeData:^(CGRect *rects, size_t size) {
        
        GGPathAddCGRects(ref_n, rects, size);
        
    } range:range];
    
    [_barScaler getPositiveData:^(CGRect *rects, size_t size) {
        
        GGPathAddCGRects(ref_p, rects, size);
        
    } range:range];
    
    _negativeLayer.path = ref_n;
    _positiveLayer.path = ref_p;
    
    CGPathRelease(ref_p);
    CGPathRelease(ref_n);
}

/**
 * 获取区间最大值最小值
 */
- (void)getIndexWithRange:(NSRange)range max:(CGFloat *)max min:(CGFloat *)min
{
    NSArray * rangeDatas = [_datas subarrayWithRange:range];
    
    CGFloat indexMax = FLT_MIN;
    CGFloat indexMin = FLT_MAX;
    
    [NSArray getDictionaryArray:rangeDatas max:&indexMax min:&indexMin];
    
    *max = indexMax > *max ? indexMax : *max;
    *min = indexMin < *min ? indexMin : *min;
}

/**
 * 更新title
 */
- (NSArray <NSString *> *)titles { return nil; }

/**
 * 指标字符串
 */
- (NSAttributedString *)attrStringWithIndex:(NSInteger)index { return nil; }

/**
 * 更新指标图表
 */
- (void)setKLineArray:(NSArray <id<KLineAbstract, VolumeAbstract>> *)kLineArray {}

/**
 * 绘制指标层
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min {}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, aryLineLayer)

GGLazyGetMethod(NSMutableArray, aryLineScalar)

@end
