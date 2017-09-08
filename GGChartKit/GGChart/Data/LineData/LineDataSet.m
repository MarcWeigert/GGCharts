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

@interface LineDataSet () <LineCanvasAbstract>

/**
 * 绘制区域
 */
@property (nonatomic, assign) CGRect rect;

@end

@implementation LineDataSet

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _idRatio = .1f;
    }
    
    return self;
}

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect
{
    _rect = rect;
    
    [self configSubModelRectAndInsets];
    [self configGridSubModel];
    [self configLineAndAxisModel];
}

/**
 * 设置绘制模型区域数据
 */
- (void)configSubModelRectAndInsets
{
    _gridConfig.insets = _insets;
    _queryConfig.insets = _insets;
    
    for (GGLineData * lineData in _lineAry) {
        
        lineData.lineScaler.rect = UIEdgeInsetsInsetRect(_rect, _insets);
    }
}

/**
 * 设置折线背景层数据
 */
- (void)configGridSubModel
{
    CGRect gridRect = UIEdgeInsetsInsetRect(_rect, _insets);
    
    _gridConfig.leftNumberAxis.axisLine = GGLeftLineRect(gridRect);
    _gridConfig.rightNumberAxis.axisLine = GGRightLineRect(gridRect);
    _gridConfig.bottomLableAxis.axisLine = GGBottomLineRect(gridRect);
    _gridConfig.topLableAxis.axisLine = GGTopLineRect(gridRect);
    
    _queryConfig.leftNumberAxis = _gridConfig.leftNumberAxis;
    _queryConfig.rightNumberAxis = _gridConfig.rightNumberAxis;
    _queryConfig.bottomLableAxis = _gridConfig.bottomLableAxis;
    _queryConfig.topLableAxis = _gridConfig.topLableAxis;
}

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel
{
    // 区分左右折线数据
    NSMutableArray * leftDataAry = [NSMutableArray array];
    NSMutableArray * rightDataAry = [NSMutableArray array];
    
    [self.lineAry enumerateObjectsUsingBlock:^(GGLineData * obj, NSUInteger idx, BOOL * stop) {
        
        if (obj.scalerMode == ScalerAxisLeft && obj.lineDataAry) {
        
            [leftDataAry addObject:obj.lineDataAry];
        }
        else if (obj.scalerMode == ScalerAxisRight && obj.lineDataAry) {
        
            [rightDataAry addObject:obj.lineDataAry];
        }
    }];
    
    // 填充左轴极大极小值
    if (_gridConfig.leftNumberAxis.max == nil ||
        _gridConfig.leftNumberAxis.min == nil) {
        
        CGFloat leftMax = FLT_MIN, leftMin = FLT_MAX;
        [leftDataAry getTwoDimensionaMax:&leftMax min:&leftMin selGetter:@selector(floatValue) base:_idRatio];
        
        _gridConfig.leftNumberAxis.max = @(leftMax);
        _gridConfig.leftNumberAxis.min = @(leftMin);
    }
    
    // 填充右轴极大极小值
    if (_gridConfig.rightNumberAxis.max == nil ||
        _gridConfig.rightNumberAxis.min == nil) {
        
        CGFloat rightMax = FLT_MIN, rightMin = FLT_MAX;
        [rightDataAry getTwoDimensionaMax:&rightMax min:&rightMin selGetter:@selector(floatValue) base:_idRatio];
        
        _gridConfig.rightNumberAxis.max = @(rightMax);
        _gridConfig.rightNumberAxis.min = @(rightMin);
    }
    
    // 填充定标器
    [self.lineAry enumerateObjectsUsingBlock:^(GGLineData * obj, NSUInteger idx, BOOL * stop) {
        
        if (_lineMode == LineDrawParallel) {      ///< 并列排列
            
            obj.lineScaler.xRatio = idx / self.lineAry.count;
        }
        
        if (obj.scalerMode == ScalerAxisLeft) {
            
            obj.lineScaler.max = _gridConfig.leftNumberAxis.max.floatValue;
            obj.lineScaler.min = _gridConfig.leftNumberAxis.min.floatValue;
        }
        else if (obj.scalerMode == ScalerAxisRight) {
            
            obj.lineScaler.max = _gridConfig.rightNumberAxis.max.floatValue;
            obj.lineScaler.min = _gridConfig.rightNumberAxis.min.floatValue;
        }
        
        [obj.lineScaler updateScaler];
    }];
}

#pragma mark - Lazy

/**
 * 折线图背景层设置
 */
- (LineBarGird *)gridConfig
{
    if (_gridConfig == nil) {
        
        _gridConfig = [[LineBarGird alloc] init];
    }
    
    return _gridConfig;
}

/**
 * 折线图查价配置
 */
- (LineBarQuery *)queryConfig
{
    if (_queryConfig == nil) {
        
        _queryConfig = [[LineBarQuery alloc] init];
    }
    
    return _queryConfig;
}

@end
