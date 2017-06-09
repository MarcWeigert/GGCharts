//
//  LineBarChartViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineBarChartViewController.h"
#import "BarChartData.h"
#import "LineChartData.h"
#import "IOLineBarChart.h"
#import "Colors.h"

@interface LineBarChartViewController ()

@property (nonatomic) IOLineBarChart * lineBarChart;

@end

@implementation LineBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"LineBarChartView";
    
    // 柱状数据
    BarChartData * barData = [[BarChartData alloc] init];
    barData.barColor = __RGB_BLUE;
    barData.dataSet = @[@1.29, @1.88, @1.46, @3.30, @3.66, @3.23, @3.48, @3.51];
    
    // 线数据
    LineChartData * lineData = [[LineChartData alloc] init];
    lineData.lineColor = __RGB_RED;
    lineData.dataSet = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    _lineBarChart = [[IOLineBarChart alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    _lineBarChart.topTitle = @"最近五日主力增减仓";
    _lineBarChart.bottomTitle = @"净利润 (万元) ";
    _lineBarChart.axisTitles = @[@"15Q2", @"15Q3", @"15Q4", @"16Q1", @"16Q2", @"16Q3", @"16Q4", @"17Q1"];
    _lineBarChart.barDataAry = @[barData];
    _lineBarChart.lineDataAry = @[lineData];
    _lineBarChart.barWidth = 20;
    _lineBarChart.lineWidth = 1;
    _lineBarChart.axisFont = [UIFont systemFontOfSize:9];
    [_lineBarChart strockChart];
    [_lineBarChart addAnimation:1];
    [self.view addSubview:_lineBarChart];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(10, 400, 100, 50)];
    [btn setTitle:@"模拟数据一" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataFirst) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(120, 400, 100, 50)];
    [btn setTitle:@"模拟数据二" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataSecond) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(230, 400, 100, 50)];
    [btn setTitle:@"模拟数据三" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataThird) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)analogDataFirst
{
    // 柱状数据
    BarChartData * barData = [[BarChartData alloc] init];
    barData.barColor = __RGB_BLUE;
    barData.dataSet = @[@-1.29, @-1.88, @1.46, @-3.30, @-3.66, @3.23, @-3.48, @3.51];
    
    // 线数据
    LineChartData * lineData = [[LineChartData alloc] init];
    lineData.lineColor = __RGB_RED;
    lineData.dataSet = @[@-1.29, @1.88, @1.46, @-3.30, @3.66, @-3.23, @-3.48, @3.51];
    
    _lineBarChart.barDataAry = @[barData];
    _lineBarChart.lineDataAry = @[lineData];
    [_lineBarChart updateChart];
}

- (void)analogDataSecond
{
    // 柱状数据
    BarChartData * barData = [[BarChartData alloc] init];
    barData.barColor = __RGB_BLUE;
    barData.dataSet = @[@1.29, @1.88, @1.46, @-3.30, @-3.66, @-3.23, @3.48, @3.51];
    
    // 线数据
    LineChartData * lineData = [[LineChartData alloc] init];
    lineData.lineColor = __RGB_RED;
    lineData.dataSet = @[@1.29, @1.88, @1.46, @3.30, @3.66, @3.23, @3.48, @3.51];
    
    _lineBarChart.barDataAry = @[barData];
    _lineBarChart.lineDataAry = @[lineData];
    [_lineBarChart updateChart];
}

- (void)analogDataThird
{
    // 柱状数据
    BarChartData * barData = [[BarChartData alloc] init];
    barData.barColor = __RGB_BLUE;
    barData.dataSet = @[@-1.29, @1.88, @-1.46, @3.30, @-3.66, @3.23, @-3.48, @3.51];
    
    // 线数据
    LineChartData * lineData = [[LineChartData alloc] init];
    lineData.lineColor = __RGB_RED;
    lineData.dataSet = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @-3.23, @-3.48, @3.51];
    
    _lineBarChart.barDataAry = @[barData];
    _lineBarChart.lineDataAry = @[lineData];
    [_lineBarChart updateChart];
}

@end
