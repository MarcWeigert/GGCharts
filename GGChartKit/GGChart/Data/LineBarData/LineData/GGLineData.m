//
//  GGLineData.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGLineData.h"
#import "LineDrawAbstract.h"

@interface GGLineData () <LineDrawAbstract>
{
    DLineScaler * _lineScaler;
}

@end

@implementation GGLineData

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.lineWidth = 1;
        self.lineColor = [UIColor blackColor];
        
        self.shapeLineWidth = 1;
        self.shapeRadius = 2;
    }
    
    return self;
}

/**
 * 折线定标器
 */
- (DLineScaler *)lineBarScaler
{
    if (_lineScaler == nil) {
        
        _lineScaler = [[DLineScaler alloc] init];
    }
    
    return _lineScaler;
}

/**
 * 用来显示的数据
 */
- (void)setDataAry:(NSArray<NSNumber *> *)dataAry
{
    [super setDataAry:dataAry];
    
    self.lineBarScaler.dataAry = dataAry;
}

/**
 * 绘制折线点
 */
- (CGPoint *)points
{
    return self.lineBarScaler.linePoints;
}

@end
