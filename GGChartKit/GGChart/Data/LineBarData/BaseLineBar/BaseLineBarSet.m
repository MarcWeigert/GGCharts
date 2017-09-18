//
//  BaseLineBarSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineBarSet.h"
#import "NSArray+Stock.h"

@interface BaseLineBarSet ()

/**
 * 绘制区域
 */
@property (nonatomic, assign) CGRect rect;

/**
 * 是否为外部设置轴极大极小值
 */
@property (nonatomic, assign) BOOL isExternalSetAxisMaxmun;

@end

@implementation BaseLineBarSet

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _idRatio = .1f;
        _insets = UIEdgeInsetsMake(20, 5, 20, 5);
    }
    
    return self;
}

#pragma mark - ConfigDatas

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateChartConfigs:(CGRect)rect
{
    _rect = rect;
    
    [self configSubModelRectAndInsets];
    [self configGridSubModel];
    [self configLineAndAxisModel];
    [self configQueryModel];
}

/**
 * 设置绘制模型区域数据
 */
- (void)configSubModelRectAndInsets
{
    self.gridConfig.insets = self.insets;
    self.queryConfig.insets = self.insets;
}

/**
 * 设置折线背景层数据
 */
- (void)configGridSubModel
{
    CGRect gridRect = UIEdgeInsetsInsetRect(_rect, self.insets);
    
    self.gridConfig.leftNumberAxis.axisLine = GGLeftLineRect(gridRect);
    self.gridConfig.rightNumberAxis.axisLine = GGRightLineRect(gridRect);
    self.gridConfig.bottomLableAxis.axisLine = GGBottomLineRect(gridRect);
    self.gridConfig.topLableAxis.axisLine = GGTopLineRect(gridRect);
}

/**
 * 设置查价层数据
 */
- (void)configQueryModel
{
    self.queryConfig.leftNumberAxis = self.gridConfig.leftNumberAxis;
    self.queryConfig.rightNumberAxis = self.gridConfig.rightNumberAxis;
    self.queryConfig.bottomLableAxis = self.gridConfig.bottomLableAxis;
    self.queryConfig.topLableAxis = self.gridConfig.topLableAxis;
}

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel
{    
    
}

/**
 * 设置填充数据轴
 */
- (void)configAxisWithArray:(NSArray <BaseLineBarData *> *)baseLineArray
{
    // 区分左右折线数据
    NSMutableArray * leftDataAry = [NSMutableArray array];
    NSMutableArray * rightDataAry = [NSMutableArray array];
    
    [baseLineArray enumerateObjectsUsingBlock:^(BaseLineBarData * obj, NSUInteger idx, BOOL * stop) {
        
        if (obj.scalerMode == ScalerAxisLeft && obj.dataAry) {
            
            [leftDataAry addObject:obj.dataAry];
        }
        else if (obj.scalerMode == ScalerAxisRight && obj.dataAry) {
            
            [rightDataAry addObject:obj.dataAry];
        }
    }];
    
    // 填充左轴极大极小值
    CGFloat leftMax = FLT_MIN, leftMin = FLT_MAX;
    [leftDataAry getTwoDimensionaMax:&leftMax min:&leftMin selGetter:@selector(floatValue) base:self.idRatio];
    [(id <NumberAxisAbstract>)self.gridConfig.leftNumberAxis setDataAryMaxValue:leftMax minValue:leftMin];
    
    // 填充右轴极大极小值
    CGFloat rightMax = FLT_MIN, rightMin = FLT_MAX;
    [rightDataAry getTwoDimensionaMax:&rightMax min:&rightMin selGetter:@selector(floatValue) base:self.idRatio];
    [(id <NumberAxisAbstract>)self.gridConfig.rightNumberAxis setDataAryMaxValue:rightMax minValue:rightMin];
}

/**
 * 设置填充定标器
 */
- (void)configLineScalerWithArray:(NSArray <BaseLineBarData *> *)baseLineArray
{
    // 设置定标器区域
    [baseLineArray enumerateObjectsUsingBlock:^(BaseLineBarData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.lineBarScaler.rect = UIEdgeInsetsInsetRect(_rect, self.insets);
    }];
    
    // 填充定标器
    for (NSInteger i = 0; i < baseLineArray.count; i++) {
        
        BaseLineBarData * obj = baseLineArray[i];
        
        if (self.lineBarMode == LineBarDrawParallel) {      ///< 并列排列
            
            obj.lineBarScaler.xRatio = 1.0 / (baseLineArray.count + 1) * (i + 1);
        }
        
        if (obj.scalerMode == ScalerAxisLeft) {
            
            obj.lineBarScaler.max = self.gridConfig.leftNumberAxis.max.floatValue;
            obj.lineBarScaler.min = self.gridConfig.leftNumberAxis.min.floatValue;
        }
        else if (obj.scalerMode == ScalerAxisRight) {
            
            obj.lineBarScaler.max = self.gridConfig.rightNumberAxis.max.floatValue;
            obj.lineBarScaler.min = self.gridConfig.rightNumberAxis.min.floatValue;
        }
    }
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
