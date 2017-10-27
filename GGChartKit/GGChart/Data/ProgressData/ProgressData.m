//
//  ProgressData.m
//  GGCharts
//
//  Created by _ | Durex on 17/10/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "ProgressData.h"

@implementation ProgressData

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _lineWidth = 17;
        _progressRadius = 100;
        _progressBackColor = C_HEX(0x2B2B2B);
        _progressGradientColor =  @[C_HEX(0xD49648), C_HEX(0xCB4942)];
        
        _pointRadius = 10;
        _pointColor = [UIColor whiteColor];
        
        _startAngle = 135;
        _endAngle = 45;
        
        _gradientCurve = GradientX;
    }
    
    return self;
}

/**
 * 弧度范围
 */
- (GGSizeRange)arcRange
{
    return GGSizeRangeMake(degreesToRadians(_startAngle), degreesToRadians(_endAngle));
}

/**
 * 中心文字外观设置
 */
- (ProgressLable *)centerLable
{
    if (_centerLable == nil) {
        
        _centerLable = [ProgressLable new];
    }
    
    return _centerLable;
}

@end
