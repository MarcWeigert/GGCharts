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

@interface IOLineBarChart : BaseChart

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

@property (nonatomic, strong) NSArray <BarChartData *> * barDataAry;
@property (nonatomic, assign) CGFloat barWidth;

@property (nonatomic, strong) NSArray <LineChartData *> * lineDataAry;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)updateChart;
- (void)strockChart;
- (void)addAnimation:(NSTimeInterval)duration;

@end
