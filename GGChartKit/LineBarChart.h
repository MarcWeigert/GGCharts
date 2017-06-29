//
//  IOLineBarChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChartData.h"
#import "BaseChart.h"
#import "LineChartData.h"

#import "BarData.h"
#import "LineData.h"

@interface LineBarChart : BaseChart

@property (nonatomic, copy) NSString * topTitle;
@property (nonatomic, strong) UIFont * topFont;
@property (nonatomic, strong) UIColor * topColor;

@property (nonatomic, copy) NSString * bottomTitle;
@property (nonatomic, strong) UIFont * bottomFont;
@property (nonatomic, strong) UIColor * bottomColor;

@property (nonatomic, copy) NSArray * axisTitles;
@property (nonatomic, strong) UIFont * axisFont;
@property (nonatomic, strong) UIColor * axisColor;

@property (nonatomic, assign) NSInteger yAxisSplit;
@property (nonatomic, copy) NSString * yAxisformat;

@property (nonatomic, strong) NSArray <BarData *> * barDataAry;
@property (nonatomic, strong) NSArray <LineData *> * lineDataAry;

@property (nonatomic, assign) BOOL isLineNeedShape;
@property (nonatomic, assign) BOOL isLineNeedString;
@property (nonatomic, assign) BOOL isBarNeedString;

- (void)updateChart;

- (void)addAnimation:(NSTimeInterval)duration;

@end
