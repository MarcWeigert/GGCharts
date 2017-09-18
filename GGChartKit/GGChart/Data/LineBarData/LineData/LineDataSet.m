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
 * 设置折线与轴数据
 */
- (void)configLineAndAxisModel
{
    [super configLineAndAxisModel];
    
    // 配置折线数组
    [self configAxisWithArray:self.lineAry];
    [self configLineScalerWithArray:self.lineAry];
    
    // 填充定标器
    [self.lineAry enumerateObjectsUsingBlock:^(GGLineData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.lineBarScaler updateScaler];
    }];
}

@end
