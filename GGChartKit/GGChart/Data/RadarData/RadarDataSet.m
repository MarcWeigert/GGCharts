//
//  RadarDataSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarDataSet.h"
#import "RadarSetAbstract.h"

@interface RadarDataSet () <RadarSetAbstract>

@property (nonatomic, strong) NSArray <NSString *> *titleAry;

@property (nonatomic, strong) NSArray <NSNumber *> *maxAry;

@end

@implementation RadarDataSet

- (void)setIndicatorSet:(NSArray<RadarIndicatorData *> *)indicatorSet
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

- (void)setRadarSet:(NSArray<RadarData <RadarAbstract> *> *)radarSet
{
    _radarSet = radarSet;
    
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
        
        obj.ratios = aryRadar;
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
