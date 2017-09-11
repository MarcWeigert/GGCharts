//
//  YAxis.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "YAxis.h"

@interface YAxis () <NumberAxisAbstract>


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
    return [DLineScaler getPriceWithYPixel:pix line:_axisLine max:_max.floatValue min:_min.floatValue];
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
