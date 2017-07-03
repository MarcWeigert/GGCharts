//
//  IOBarChartViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "IOBarChartViewController.h"
#import "PNBarChart.h"

@interface IOBarChartViewController ()

@property (nonatomic, strong) PNBarChart * barChart;

@end

@implementation IOBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"IOBarChart";
    
    PNBarData * bar = [[PNBarData alloc] init];
    bar.datas = @[@-2225.6, @-2563.1, @531.4, @839.4, @7.4, @1000, @-897.0, @1500];
    bar.width = 25;
    
    [bar addTarget:self
            action:@selector(clickBar:index:)
      forBarEvents:TouchEventMoveNear];
    
    _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    _barChart.lbTop.text = @"最近五日主力增减仓";
    _barChart.lbBottom.text = @"净利润 (万元) ";
    _barChart.axisTitles = @[@"15Q2", @"15Q3", @"15Q4", @"16Q1", @"16Q2", @"16Q3", @"16Q4", @"17Q1"];
    _barChart.axisFont = [UIFont systemFontOfSize:9];
    _barChart.pnBarData = bar;
    [_barChart drawChart];
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

- (void)clickBar:(CGRect)rect index:(NSInteger)index
{
    NSLog(@"%.2f", rect.size.width);
    
    NSLog(@"%zd", index);
}

- (void)analogDataFirst
{
    _barChart.pnBarData.datas = @[@2225.6, @2563.1, @531.4, @839.4, @107.4, @1000, @897.0, @1500];
    [_barChart updateChart];
}

- (void)analogDataSecond
{
    _barChart.pnBarData.datas = @[@-2225.6, @-2563.1, @-531.4, @-839.4, @-7.4, @-1000, @-897.0, @-1500];
    [_barChart updateChart];
}

- (void)analogDataThird
{
    _barChart.pnBarData.datas = @[@-2225.6, @2563.1, @-531.4, @-839.4, @7.4, @-1000, @897.0, @-1500];
    [_barChart updateChart];
}

@end
