//
//  LineDataSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineDataSet.h"

@interface LineDataSet () <LineCanvasAbstract>

@end

@implementation LineDataSet

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _bottomAxis = [[XAxis alloc] init];
        _bottomAxis.textRatio = CGPointMake(-.5f, 0.1);
        _bottomAxis.startLocalRatio = CGPointMake(0, 1);
        _bottomAxis.endLocalRatio = CGPointMake(1, 1);
        _bottomAxis.over = 2;
        _bottomAxis.axisLineWidth = .7f;
        _bottomAxis.axisFont = [UIFont systemFontOfSize:12];
        _bottomAxis.axisColor = [UIColor blackColor];
        
        _topAxis = [[XAxis alloc] init];
        _topAxis.textRatio = CGPointMake(-.5f, -1.1f);
        _topAxis.startLocalRatio = CGPointMake(0, 0);
        _topAxis.endLocalRatio = CGPointMake(0, 1);
        _topAxis.over = 2;
        _topAxis.axisLineWidth = .7f;
        _topAxis.axisFont = [UIFont systemFontOfSize:12];
        _topAxis.axisColor = [UIColor blackColor];
        
        _leftAxis = [[YAxis alloc] init];
        _leftAxis.textRatio = CGPointMake(-1.1f, -.5f);
        _leftAxis.startLocalRatio = CGPointMake(0, 1);
        _leftAxis.endLocalRatio = CGPointMake(0, 0);
        _leftAxis.over = -2;
        _leftAxis.axisLineWidth = .7f;
        _leftAxis.axisFont = [UIFont systemFontOfSize:12];
        _leftAxis.axisColor = [UIColor blackColor];
        
        _rightAxis = [[YAxis alloc] init];
        _rightAxis.textRatio = CGPointMake(0.1f, -.5f);
        _rightAxis.startLocalRatio = CGPointMake(0, 1);
        _rightAxis.endLocalRatio = CGPointMake(1, 1);
        _rightAxis.over = -2;
        _rightAxis.axisLineWidth = .7f;
        _rightAxis.axisFont = [UIFont systemFontOfSize:12];
        _rightAxis.axisColor = [UIColor blackColor];
    }
    
    return self;
}

- (NSUInteger)horizontalCount
{
    return _bottomAxis.titles.count - 1;
}

- (NSUInteger)verticalCount
{
    return _leftAxis.splitCount;
}

- (UIEdgeInsets)lineInsets
{
    return _insets;
}

- (NSArray *)axiss
{
    return @[_bottomAxis, _leftAxis, _topAxis, _rightAxis];
}

@end
