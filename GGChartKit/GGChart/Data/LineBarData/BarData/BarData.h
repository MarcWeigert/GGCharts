//
//  BarData.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLineBarData.h"

@interface BarData : BaseLineBarData


#pragma mark - 柱状图设置

/**
 * 柱状图边框颜色
 */
@property (nonatomic, strong) UIColor * barBorderColor;

/**
 * 柱状图填充色
 */
@property (nonatomic, strong) UIColor * barFillColor;

/**
 * 柱状图边框
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 柱状图宽度
 */
@property (nonatomic, assign) CGFloat barWidth;

@end
