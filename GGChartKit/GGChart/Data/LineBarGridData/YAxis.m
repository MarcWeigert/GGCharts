//
//  YAxis.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "YAxis.h"

@interface YAxis () <NumberAxisAbstract>

/**
 * 数据中极大值
 */
@property (nonatomic, assign) CGFloat dataMaxValue;

/**
 * 数据中极小值
 */
@property (nonatomic, assign) CGFloat dataMinValue;

@end

@implementation YAxis

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _over = 0;
        _splitCount = 0;
        _dataFormatter = @"%.2f";
    }
    
    return self;
}

/**
 * 通过轴线当前长度获取数据
 *
 * @param pix 像素
 *
 * @return 数据
 */
- (CGFloat)getNumberWithPix:(CGFloat)pix
{
    CGFloat maxAxisValue = _max == nil ? _dataMaxValue : _max.floatValue;
    CGFloat minAxisValue = _min == nil ? _dataMinValue : _min.floatValue;
    
    return [DLineScaler getPriceWithYPixel:pix line:_axisLine max:maxAxisValue min:minAxisValue];
}

/**
 * 设置轴内极大极小值
 *
 * @param maxValue 极大值
 * @param minValue 极小值
 */
- (void)setDataAryMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue
{
    if (_max == nil) {
        
        _dataMaxValue = maxValue;
    }
    
    if (_min == nil) {
        
        _dataMinValue = minValue;
    }
}

/**
 * 轴最大值
 */
- (NSNumber *)max
{
    if (_max == nil) {
        
        return @(_dataMaxValue);
    }
    
    return _max;
}

/**
 * 轴最小值
 */
- (NSNumber *)min
{
    if (_min == nil) {
        
        return @(_dataMinValue);
    }
    
    return _min;
}

#pragma mark - Lazy

/**
 * 轴名称
 */
- (AxisName *)name
{
    if (_name == nil) {
        
        _name = [[AxisName alloc] init];
    }
    
    return _name;
}

@end
