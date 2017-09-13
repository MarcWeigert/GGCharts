//
//  IOBarChartViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "IOBarChartViewController.h"
#import "PNBarChart.h"

#import "BarChart.h"
#import "Colors.h"

@interface IOBarChartViewController ()

@property (nonatomic, strong) BarChart * barChart;

@property (nonatomic, strong) BarDataSet * barDataSet;

@property (nonatomic, strong) GGBarData * barData;
@property (nonatomic, strong) GGBarData * barData2;

@end

@implementation IOBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"IOBarChart";
    
    _barData = [[GGBarData alloc] init];
    _barData.barWidth = 25;
    _barData.roundNumber = @0;
    _barData.dataAry = @[@-2225.6, @-2563.1, @531.4, @839.4, @7.4, @1000, @-897.0, @1500];
    
    _barData2 = [[GGBarData alloc] init];
    _barData2.barWidth = 10;
    _barData2.roundNumber = @0;
    
    _barDataSet = [[BarDataSet alloc] init];
    _barDataSet.barAry = @[_barData];
    _barDataSet.lineBarMode = LineBarDrawParallel;
    
    [_barDataSet setBarColorsAtIndexPath:^UIColor *(NSIndexPath * index, NSNumber * number) {
        
        return number.floatValue > 0 ? RGB(241, 73, 81) : RGB(30, 191, 97);
    }];
    
    _barChart = [[BarChart alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    _barChart.barDataSet = _barDataSet;
    [self.view addSubview:_barChart];
    
    [_barChart drawBarChart];
    
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
    _barData.dataAry = @[@2225.6, @2563.1, @531.4, @839.4, @107.4, @1000, @897.0, @1500];
    
    [_barChart drawBarChart];
}

- (void)analogDataSecond
{
    _barData.dataAry = @[@-2225.6, @-2563.1, @-531.4, @-839.4, @-7.4, @-1000, @-897.0, @-1500];
    
    [_barChart drawBarChart];
}

- (void)analogDataThird
{
    _barData.dataAry = @[@-2225.6, @2563.1, @-531.4, @-839.4, @7.4, @-1000, @897.0, @-1500];
    
    [_barChart drawBarChart];
}

@end
