//
//  BaseBarData.h
//  HSCharts
//
//  Created by _ | Durex on 2017/6/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineData.h"
#import "DBarScaler.h"
#import "GGChartTouchProtocol.h"

@interface BaseBarData : BaseLineData <GGChartTouchProtocol>

@property (nonatomic, strong) DBarScaler * barScaler;   ///< 柱状图定标器

/**
 * 增加点击事件
 *
 * @param target 执行类
 * @param action 响应方法
 * @param controlEvents 点击方法
 */
- (void)addTarget:(id)target
           action:(SEL)action
     forBarEvents:(GGChartEvents)controlEvents;

@end
