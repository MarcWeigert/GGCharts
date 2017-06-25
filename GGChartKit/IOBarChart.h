//
//  IOBarChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseCountChart.h"
#import "PNBarData.h"

@interface IOBarChart : BaseCountChart

@property (nonatomic, copy) NSString * topTitle;
@property (nonatomic, strong) UIFont * topFont;
@property (nonatomic, strong) UIColor * topColor;

@property (nonatomic, copy) NSString * bottomTitle;
@property (nonatomic, strong) UIFont * bottomFont;
@property (nonatomic, strong) UIColor * bottomColor;

@property (nonatomic, copy) NSString * positiveTitle;
@property (nonatomic, strong) UIColor * positiveColor;

@property (nonatomic, copy) NSString * negativeTitle;
@property (nonatomic, strong) UIColor * negativeColor;

@property (nonatomic, copy) NSArray * axisTitles;
@property (nonatomic, strong) UIFont * axisFont;
@property (nonatomic, strong) UIColor * axisColor;

@property (nonatomic, strong) PNBarData * pnBarData;

@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, strong) NSString * format;

- (void)updateChart;

/** 图表动画 */
- (void)addAnimation:(NSTimeInterval)duration;

@end
