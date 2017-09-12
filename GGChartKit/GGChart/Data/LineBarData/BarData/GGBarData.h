//
//  GGBarData.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLineBarData.h"

@interface GGBarData : BaseLineBarData


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
 * 柱状图宽度
 */
@property (nonatomic, assign) CGFloat barWidth;

/**
 * 柱状图底部价格
 */
@property (nonatomic, strong) NSNumber * bottomPrice;

@end
