//
//  IOLineBarChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChartData.h"
#import "LineChartData.h"

@interface IOLineBarChart : UIView

@property (nonatomic, copy) NSString * topTitle;
@property (nonatomic, strong) UIFont * topFont;
@property (nonatomic, strong) UIColor * topColor;

@property (nonatomic, copy) NSString * bottomTitle;
@property (nonatomic, strong) UIFont * bottomFont;
@property (nonatomic, strong) UIColor * bottomColor;

@property (nonatomic, copy) NSArray * axisTitles;
@property (nonatomic, strong) UIFont * axisFont;
@property (nonatomic, strong) UIColor * axisColor;

@property (nonatomic, strong) BarChartData * barData;
@property (nonatomic, assign) CGFloat barWidth;

@property (nonatomic, strong) LineChartData * lineData;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) NSInteger yAxisSplit;
@property (nonatomic, copy) NSString * yAxisformat;

@property (nonatomic, assign) UIEdgeInsets contentInset;

- (void)updateChart;
- (void)strockChart;
- (void)addAnimation:(NSTimeInterval)duration;

@end
