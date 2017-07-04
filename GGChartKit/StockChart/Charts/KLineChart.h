//
//  KLineChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseStockChart.h"
#import "KLineAbstract.h"
#import "VolumeAbstract.h"

@interface KLineChart : BaseStockChart

@property (nonatomic, strong) NSArray <id <KLineAbstract, VolumeAbstract> > * kLineArray;    ///< k线数组

@property (nonatomic, assign) NSInteger kLineCountVisibale;     ///< 一屏幕显示多少根k线
@property (nonatomic, assign) CGFloat kInterval;    ///< k线之间的间隔

- (void)updateChart;

@end
