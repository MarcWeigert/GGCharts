//
//  MALayer.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MALayer.h"
#import "DLineScaler.h"
#import "GGChartDefine.h"
#import "KLineIndexManager.h"
#import "GGGraphics.h"

@interface MALayer ()

@property (nonatomic, strong) NSArray <id<KLineAbstract>> * kLineArray;
@property (nonatomic, strong) NSArray <NSNumber *> * param;

@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> * aryLineLayer;
@property (nonatomic, strong) NSMutableArray <DLineScaler *> * aryLineScalar;

@property (nonatomic, strong) NSMutableArray <NSString *> * allKeys;
@property (nonatomic, strong) NSDictionary * dictionaryMaIndexs;

@end

@implementation MALayer

/**
 * 根据数组数据结构计算MA指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 */
- (void)updateIndexWithArray:(NSArray <id<KLineAbstract>> *)kLineArray
                       param:(NSDictionary <NSNumber *, UIColor *> *)param
{
    _kLineArray = kLineArray;
    
    _param = [param.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber * obj1, NSNumber * obj2) {
        
        return [obj1 compare:obj2];
    }];
    
    // 删除所有层
    for (NSUInteger idx = 0; idx < self.aryLineLayer.count; idx++) {
        CAShapeLayer * layer = self.aryLineLayer[idx];
        [layer removeFromSuperlayer];
    }
    
    // 重置所有数据
    [self.aryLineLayer removeAllObjects];
    [self.aryLineScalar removeAllObjects];
    [self.allKeys removeAllObjects];
    _dictionaryMaIndexs = nil;
    
    for (NSUInteger idx = 0; idx < _param.count; idx++) {
        
        NSNumber * obj = _param[idx];
        
        CAShapeLayer * layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [param[_param[idx]] CGColor];
        layer.lineWidth = 1;
        [self addSublayer:layer];
        [self.aryLineLayer addObject:layer];
        [self.aryLineScalar addObject:[DLineScaler new]];
        [self.allKeys addObject:[NSString stringWithFormat:@"MA%@", obj]];
    }
    
    // 计算指标
    _dictionaryMaIndexs = [[KLineIndexManager shareInstans] getMaIndexWith:kLineArray
                                                                     param:_param
                                                               priceString:CLOSE];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    for (NSUInteger idx = 0; idx < self.aryLineLayer.count; idx++) {
        
        CAShapeLayer * obj = self.aryLineLayer[idx];
        
        obj.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
}

/**
 * 绘制层数据
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min
{
    for (NSUInteger idx = 0; idx < self.aryLineLayer.count; idx++) {
        
        CAShapeLayer * obj = self.aryLineLayer[idx];
        
        NSString * key = self.allKeys[idx];
        NSArray <NSNumber *> * indexDatas = [self.dictionaryMaIndexs objectForKey:key];
        
        DLineScaler * lineScaler = self.aryLineScalar[idx];
        lineScaler.max = max;
        lineScaler.min = min;
        lineScaler.rect = obj.frame;
        lineScaler.dataAry = indexDatas;
        lineScaler.xMaxCount = indexDatas.count;
        [lineScaler updateScaler];
        
        CGMutablePathRef ref = CGPathCreateMutable();
        GGPathAddRangePoints(ref, lineScaler.linePoints, range);
        obj.path = ref;
        CGPathRelease(ref);
    }
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, aryLineLayer);
GGLazyGetMethod(NSMutableArray, aryLineScalar);
GGLazyGetMethod(NSMutableArray, allKeys);

@end
