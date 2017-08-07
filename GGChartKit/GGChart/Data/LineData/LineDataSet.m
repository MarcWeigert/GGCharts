//
//  LineDataSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineDataSet.h"
#import "AxisAbstract.h"
#import "LineCanvas.h"
#import "NSArray+Stock.h"

@interface LineDataSet () <LineCanvasAbstract, GridAbstract>

@end

@implementation LineDataSet

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _bottomAxis = [[XAxis alloc] init];
        _bottomAxis.textRatio = CGPointMake(-.5f, 0.1);
        _bottomAxis.over = 2;
        _bottomAxis.axisLineWidth = .7f;
        _bottomAxis.axisFont = [UIFont systemFontOfSize:12];
        _bottomAxis.axisColor = [UIColor blackColor];
        _bottomAxis.needShowGridLine = YES;
        [(id <AxisAbstract>)_bottomAxis setStartLocalRatio:CGPointMake(0, 1)];
        [(id <AxisAbstract>)_bottomAxis setEndLocalRatio:CGPointMake(1, 1)];
        
        _topAxis = [[XAxis alloc] init];
        _topAxis.textRatio = CGPointMake(-.5f, -1.1f);
        _topAxis.over = -2;
        _topAxis.axisLineWidth = .7f;
        _topAxis.axisFont = [UIFont systemFontOfSize:12];
        _topAxis.axisColor = [UIColor blackColor];
        _topAxis.needShowGridLine = YES;
        [(id <AxisAbstract>)_topAxis setStartLocalRatio:CGPointMake(0, 0)];
        [(id <AxisAbstract>)_topAxis setEndLocalRatio:CGPointMake(1, 0)];
        
        _leftAxis = [[YAxis alloc] init];
        _leftAxis.textRatio = CGPointMake(-1.1f, -.5f);
        _leftAxis.over = -2;
        _leftAxis.axisLineWidth = .7f;
        _leftAxis.splitCount = 5;
        _leftAxis.axisFont = [UIFont systemFontOfSize:12];
        _leftAxis.axisColor = [UIColor blackColor];
        _leftAxis.needShowGridLine = YES;
        [(id <AxisAbstract>)_leftAxis setStartLocalRatio:CGPointMake(0, 1)];
        [(id <AxisAbstract>)_leftAxis setEndLocalRatio:CGPointMake(0, 0)];
        
        _rightAxis = [[YAxis alloc] init];
        _rightAxis.textRatio = CGPointMake(0.1f, -.5f);
        _rightAxis.over = 2;
        _rightAxis.axisLineWidth = .7f;
        _rightAxis.splitCount = 5;
        _rightAxis.axisFont = [UIFont systemFontOfSize:12];
        _rightAxis.axisColor = [UIColor blackColor];
        _rightAxis.needShowGridLine = YES;
        [(id <AxisAbstract>)_rightAxis setStartLocalRatio:CGPointMake(1, 1)];
        [(id <AxisAbstract>)_rightAxis setEndLocalRatio:CGPointMake(1, 0)];
    }
    
    return self;
}

- (UIEdgeInsets)lineInsets
{
    return _insets;
}

- (NSArray *)axiss
{
    return @[_bottomAxis, _leftAxis, _topAxis, _rightAxis];
}

- (void)drawOnLineCanvas:(LineCanvas *)lineCanvas
{
    NSMutableArray * leftYAxisDataAry = [NSMutableArray array];
    NSMutableArray * rightYAxisDataAry = [NSMutableArray array];
    
    NSMutableArray * leftObjDataAry = [NSMutableArray array];
    NSMutableArray * rightObjDataAry = [NSMutableArray array];
    
    [self.lineAry enumerateObjectsUsingBlock:^(GGLineData * obj, NSUInteger idx, BOOL * stop) {
        
        if (obj.scalerType == ScalerAxisLeft) {
            
            [leftYAxisDataAry addObject:obj.lineDataAry];
            [leftObjDataAry addObject:obj];
        }
        else {
        
            [rightYAxisDataAry addObject:obj.lineDataAry];
            [rightObjDataAry addObject:obj];
        }
    }];
    
    if (leftObjDataAry.count > 0) {
     
        // 获取最大值最小值(左边)
        CGFloat leftMax = FLT_MIN;
        CGFloat leftMin = FLT_MAX;
        
        if (_leftAxis.max == nil || _leftAxis.max == nil) {
            
            [leftYAxisDataAry getTwoDimensionaMax:&leftMax
                                              min:&leftMin
                                        selGetter:@selector(floatValue)
                                             base:.1f];
            
            _leftAxis.max = @(leftMax);
            _leftAxis.min = @(leftMin);
        }
        else {
            
            leftMax = _leftAxis.max.floatValue;
            leftMin = _leftAxis.min.floatValue;
        }
        
        [leftObjDataAry enumerateObjectsUsingBlock:^(GGLineData * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.lineScaler.max = leftMax;
            obj.lineScaler.min = leftMin;
        }];
    }
    
    if (rightObjDataAry.count > 0) {
        
        // 获取最大值最小值(右边)
        CGFloat rightMax = FLT_MIN;
        CGFloat rightMin = FLT_MAX;
        
        if (_rightAxis.max == nil || _rightAxis.max == nil) {
            
            [rightYAxisDataAry getTwoDimensionaMax:&rightMax
                                               min:&rightMin
                                         selGetter:@selector(floatValue)
                                              base:.1f];
            
            _rightAxis.max = @(rightMax);
            _rightAxis.min = @(rightMin);
        }
        else {
            
            rightMax = _rightAxis.max.floatValue;
            rightMin = _rightAxis.min.floatValue;
        }
        
        [rightObjDataAry enumerateObjectsUsingBlock:^(GGLineData * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.lineScaler.max = rightMax;
            obj.lineScaler.min = rightMin;
        }];
    }
}

@end
