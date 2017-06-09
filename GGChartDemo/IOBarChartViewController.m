//
//  IOBarChartViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "IOBarChartViewController.h"
#import "IOBarChart.h"
#import "BarChartData.h"

@interface IOBarChartViewController ()

@property (nonatomic, strong) IOBarChart * barChart;

@end

@implementation IOBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"IOBarChart";
    
    BarChartData * data = [[BarChartData alloc] init];
    data.dataSet = @[@-2225.6, @-2563.1, @531.4, @839.4, @7.4, @1000, @-897.0, @1500];
    
    _barChart = [[IOBarChart alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    _barChart.topTitle = @"最近五日主力增减仓";
    _barChart.bottomTitle = @"净利润 (万元) ";
    _barChart.positiveTitle = @"资金流入";
    _barChart.negativeTitle = @"资金流出";
    _barChart.axisTitles = @[@"15Q2", @"15Q3", @"15Q4", @"16Q1", @"16Q2", @"16Q3", @"16Q4", @"17Q1"];
    _barChart.barData = data;
    _barChart.barWidth = 25;
    _barChart.axisFont = [UIFont systemFontOfSize:9];
    [_barChart strockChart];
    [_barChart addAnimation:1];
    [self.view addSubview:_barChart];
    
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
    BarChartData * data = [[BarChartData alloc] init];
    data.dataSet = @[@2225.6, @2563.1, @531.4, @839.4, @7.4, @1000, @897.0, @1500];
    _barChart.barData = data;
    [_barChart updateChart];
}

- (void)analogDataSecond
{
    BarChartData * data = [[BarChartData alloc] init];
    data.dataSet = @[@-2225.6, @-2563.1, @-531.4, @-839.4, @-7.4, @-1000, @-897.0, @-1500];
    _barChart.barData = data;
    [_barChart updateChart];
}

- (void)analogDataThird
{
    BarChartData * data = [[BarChartData alloc] init];
    data.dataSet = @[@-2225.6, @2563.1, @-531.4, @-839.4, @7.4, @-1000, @897.0, @-1500];
    _barChart.barData = data;
    [_barChart updateChart];
}

@end
