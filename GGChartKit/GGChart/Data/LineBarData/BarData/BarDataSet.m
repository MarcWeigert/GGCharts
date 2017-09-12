//
//  BarDataSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarDataSet.h"
#import "BarCanvasAbstract.h"

@interface BarDataSet () <BarCanvasAbstract>

@end

@implementation BarDataSet

/**
 * 获取数据数组(子类重写)
 */
- (NSArray <BaseLineBarData *> *)getBaseLineBarDataArray
{
    return self.barAry;
}

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel
{
    [super configLineAndAxisModel];
    
    // 填充定标器
    for (GGBarData * obj in self.barAry) {
        
        [obj.lineBarScaler updateScaler];
    }
}

@end
