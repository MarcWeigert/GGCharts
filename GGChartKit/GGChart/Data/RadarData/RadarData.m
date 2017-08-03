//
//  RadarData.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarData.h"
#import "RadarAbstract.h"

@interface RadarData () <RadarAbstract>

@property (nonatomic, strong) NSArray <NSNumber *> *ratiosAry;

@end

@implementation RadarData

- (void)setRatios:(NSArray<NSNumber *> *)ratios
{
    _ratiosAry = ratios;
}

- (NSArray *)ratios
{
    return _ratiosAry;
}

@end
