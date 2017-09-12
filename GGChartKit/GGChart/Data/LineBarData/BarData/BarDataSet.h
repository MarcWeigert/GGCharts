//
//  BarDataSet.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGBarData.h"
#import "BaseLineBarSet.h"

@interface BarDataSet : BaseLineBarSet

/**
 * 柱状图颜色
 */
@property (nonatomic, copy) UIColor *(^barColorsAtIndexPath)(NSIndexPath *indexPath);

/**
 * 柱状图数据数组
 */
@property (nonatomic, strong) NSArray <GGBarData *> *barAry;

@end
