//
//  LineDataSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineDataSet.h"
#import "LineCanvas.h"
#import "NSArray+Stock.h"

@interface LineDataSet () <LineCanvasAbstract>

@end

@implementation LineDataSet

/**
 * 获取数据数组(子类重写)
 */
- (NSArray <BaseLineBarData *> *)getBaseLineBarDataArray
{
    return self.lineAry;
}

/**
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel
{
    [super configLineAndAxisModel];
    
    // 填充定标器
    [self.lineAry enumerateObjectsUsingBlock:^(GGLineData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.lineBarScaler updateScaler];
    }];
}

@end
