//
//  TimeChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"
#import "StockModelProtocol.h"

@interface TimeChart : BaseChart

@property (nonatomic, strong) UIColor * lineColor;      ///< 分时线颜色
@property (nonatomic, strong) UIColor * redColor;       ///< 环比上次涨颜色
@property (nonatomic, strong) UIColor * greenColor;     ///< 环比上次跌颜色
@property (nonatomic, strong) UIColor * avgColor;       ///< 均价线颜色

@property (nonatomic, assign) CGFloat lineRatio;    ///< 分时线所占比率

@property (nonatomic, strong) NSArray <TimeDataProtocol, VolumeDataProtocol> * objTimeAry;  ///< 分时数组

@end
