//
//  RadarDataSet.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarDataSet.h"
#import "RadarSetAbstract.h"

@interface RadarDataSet () <RadarSetAbstract>

@property (nonatomic, strong) NSArray <NSString *> *titleAry;

@property (nonatomic, strong) NSArray <NSNumber *> *maxAry;

@end

@implementation RadarDataSet

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _titleSpacing = 10;
    }
    
    return self;
}

- (void)setIndicatorSet:(NSArray <RadarIndicatorData *> *)indicatorSet
{
    _indicatorSet = indicatorSet;
    
    NSMutableArray * aryTitles = [NSMutableArray array];
    NSMutableArray * maxAry = [NSMutableArray array];
    
    [_indicatorSet enumerateObjectsUsingBlock:^(RadarIndicatorData * obj, NSUInteger idx, BOOL * stop) {
        
        [aryTitles addObject:obj.title];
        [maxAry addObject:@(obj.max)];
    }];
    
    _titleAry = [NSArray arrayWithArray:aryTitles];
    _maxAry = [NSArray arrayWithArray:maxAry];
}

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect
{
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    GGPolygon ploygon = GGPolygonMake(_radius, center.x, center.y, _indicatorSet.count, 0);
    
    [_radarSet enumerateObjectsUsingBlock:^(RadarData <RadarAbstract> * obj, NSUInteger idx, BOOL * stop) {
        
        NSMutableArray * aryRadar = [NSMutableArray array];
        
        [obj.datas enumerateObjectsUsingBlock:^(NSNumber * number, NSUInteger idx, BOOL * stop) {
            
            NSInteger maxIdx = idx >= _maxAry.count ? _maxAry.count - 1 : idx;
            CGFloat base = _maxAry[maxIdx].floatValue;
            
            if (base == 0) {
                
                [aryRadar addObject:@(obj.baseRatio)];
            }
            else {
                
                [aryRadar addObject:@(number.floatValue / _maxAry[idx].floatValue * (1 - obj.baseRatio) + obj.baseRatio)];
            }
        }];
        
        obj.radarScaler.radarProportions = aryRadar;
        obj.radarScaler.polygon = ploygon;
        [obj.radarScaler updateScaler];
    }];
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titleAry = titles;
}

- (NSArray *)titles
{
    return _titleAry;
}

- (NSInteger)side
{
    return _indicatorSet.count;
}

@end
