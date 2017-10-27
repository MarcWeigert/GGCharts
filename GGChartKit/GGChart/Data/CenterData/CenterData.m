//
//  CenterData.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "CenterData.h"

@implementation CenterLableData

@end

@interface CenterData () <CenterAbstract>

/**
 * 结构体
 */
@property (nonatomic, assign) GGPolygon ggPolygon;

@end

@implementation CenterData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _lable = [[CenterLableData alloc] init];
    }
    
    return self;
}

/**
 * 结构体
 */
- (void)setPolygon:(GGPolygon)polygon
{
    _ggPolygon = polygon;
}

/**
 * 结构体
 */
- (GGPolygon)polygon
{
    return _ggPolygon;
}

/**
 * 设置半径
 */
- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    _ggPolygon.radius = radius;
}

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateCenterConfigs:(CGRect)rect
{
    _ggPolygon.center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

@end
