//
//  MDLineChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"
#import "MassChartData.h"
#import "StockQueryView.h"

@protocol MDLineChartDelegate <NSObject>

@optional

- (void)moveToKeyNodeData:(MassChartData *)chartData queryView:(StockQueryView *)queryView;

@end

@interface MDLineChart : BaseChart

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor * color;
@property (nonatomic, strong) UIFont * axisFont;
@property (nonatomic, copy) NSString * yAxisformat;

@property (nonatomic, strong) NSArray <MassChartData *> * dataSet;

@property (nonatomic, assign) NSUInteger xNdiv;
@property (nonatomic, assign) NSUInteger yAxisSplit;

@property (nonatomic, weak) id <MDLineChartDelegate> delegate;

- (void)strockChart;

- (void)addAnimation:(NSTimeInterval)duration;

@end
