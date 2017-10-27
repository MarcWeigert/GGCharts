//
//  LineDataSet.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineDataSet.h"
#import "LineCanvas.h"

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
    [self.lineAry enumerateObjectsUsingBlock:^(LineData * obj, NSUInteger idx, BOOL * stop) {
        
        [obj.lineBarScaler updateScaler];
    }];
}

@end
