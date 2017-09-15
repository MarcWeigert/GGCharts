//
//  LineBarGird.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineBarGird.h"

@interface LineBarGird () <GridAbstract>

@end

@implementation LineBarGird

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _lineWidth = .7f;
        _lineColor = [UIColor blackColor];
        
        _axisSplitLineColor = [UIColor blackColor];
        _axisLineColor = [UIColor blackColor];
        _axisLableFont = [UIFont systemFontOfSize:10];
        _axisLableColor = [UIColor blackColor];
    }
    
    return self;
}

#pragma mark - 轴设置

/**
 * 查价层左边数据轴
 */
- (YAxis *)leftNumberAxis
{
    if (_leftNumberAxis == nil) {
        
        _leftNumberAxis = [[YAxis alloc] init];
        _leftNumberAxis.offSetRatio = CGPointMake(-1.0f, -.5f);
        _leftNumberAxis.stringGap = -5.0f;
        _leftNumberAxis.name.offSetRatio = CGPointMake(-.5f, -1.0f);
        _leftNumberAxis.name.offSetSize = CGSizeMake(0, -5);
    }
    
    return _leftNumberAxis;
}

/**
 * 查价层右边数据轴
 */
- (YAxis *)rightNumberAxis
{
    if (_rightNumberAxis == nil) {
        
        _rightNumberAxis = [[YAxis alloc] init];
        _rightNumberAxis.offSetRatio = CGPointMake(.0f, -.5f);
        _rightNumberAxis.stringGap = 5.0f;
        _rightNumberAxis.name.offSetRatio = CGPointMake(-.5f, -1.0f);
        _rightNumberAxis.name.offSetSize = CGSizeMake(0, -5);
    }
    
    return _rightNumberAxis;
}

/**
 * 查价层上层标签轴
 */
- (XAxis *)topLableAxis
{
    if (_topLableAxis == nil) {
        
        _topLableAxis = [[XAxis alloc] init];
        _topLableAxis.offSetRatio = CGPointMake(-.5f, -1.0f);
        _topLableAxis.stringGap = -5.0f;
    }
    
    return _topLableAxis;
}

/**
 * 背景层底部标签轴
 */
- (XAxis *)bottomLableAxis
{
    if (_bottomLableAxis == nil) {
        
        _bottomLableAxis = [[XAxis alloc] init];
        _bottomLableAxis.offSetRatio = CGPointMake(-.5f, .0f);
        _bottomLableAxis.stringGap = 5.0f;
    }
    
    return _bottomLableAxis;
}

@end
