//
//  LineBarChartViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineBarChartViewController.h"
#import "LineBarChart.h"
#import "Colors.h"

#import "GGLineData.h"
#import "GGBarData.h"

@interface LineBarChartViewController ()

@property (nonatomic) LineBarChart * lineBarChart;
@property (nonatomic) LineBarDataSet * lineBarSet;

@property (nonatomic, strong) GGBarData * barData1;
@property (nonatomic, strong) GGBarData * barData2;

@property (nonatomic, strong) GGLineData * lineData1;
@property (nonatomic, strong) GGLineData * lineData2;

@end

@implementation LineBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"LineBarChartView";
    
    _barData1 = [[GGBarData alloc] init];
    _barData1.dataAry = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    _barData1.barWidth = 10;
    _barData1.barFillColor = __RGB_RED;
    
    _barData2 = [[GGBarData alloc] init];
    _barData2.dataAry = @[@11.29, @11.88, @11.46, @13.30, @13.66, @13.23, @13.48, @13.51];
    _barData2.barWidth = 10;
    _barData2.barFillColor = __RGB_CYAN;
    
    _lineData1 = [[GGLineData alloc] init];
    _lineData1.lineColor = __RGB_RED;
    _lineData1.scalerMode = ScalerAxisRight;
    _lineData1.dataAry = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    _lineData2 = [[GGLineData alloc] init];
    _lineData2.lineColor = __RGB_ORIGE;
    _lineData2.scalerMode = ScalerAxisRight;
    _lineData2.dataAry = @[@11.29, @-11.88, @11.46, @-13.30, @13.66, @3.23, @-3.48, @-3.51];
    
    LineBarDataSet * lineBarSet = [[LineBarDataSet alloc] init];
    lineBarSet.insets = UIEdgeInsetsMake(30, 20, 30, 20);
    lineBarSet.lineAry = @[_lineData1, _lineData2];
    lineBarSet.barAry = @[_barData1, _barData2];
    lineBarSet.updateNeedAnimation = YES;
    
    lineBarSet.gridConfig.lineColor = C_HEX(0xe4e4e4);
    lineBarSet.gridConfig.lineWidth = .5f;
    lineBarSet.gridConfig.axisLineColor = RGB(146, 146, 146);
    lineBarSet.gridConfig.axisLableColor = RGB(146, 146, 146);
    
    lineBarSet.gridConfig.bottomLableAxis.lables = @[@"15Q1", @"15Q2", @"15Q3", @"15Q4", @"16Q1", @"16Q2", @"16Q3", @"16Q4"];
    lineBarSet.gridConfig.bottomLableAxis.drawStringAxisCenter = YES;
    lineBarSet.gridConfig.bottomLableAxis.showSplitLine = YES;
    lineBarSet.gridConfig.bottomLableAxis.over = 2;
    lineBarSet.gridConfig.bottomLableAxis.showQueryLable = YES;
    
    lineBarSet.gridConfig.leftNumberAxis.splitCount = 4;
    lineBarSet.gridConfig.leftNumberAxis.dataFormatter = @"%.0f";
    lineBarSet.gridConfig.leftNumberAxis.showSplitLine = YES;
    lineBarSet.gridConfig.leftNumberAxis.showQueryLable = YES;
    
    lineBarSet.gridConfig.rightNumberAxis.splitCount = 4;
    lineBarSet.gridConfig.rightNumberAxis.dataFormatter = @"%.0f";
    lineBarSet.gridConfig.rightNumberAxis.showQueryLable = YES;
    
    _lineBarChart = [[LineBarChart alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    _lineBarChart.lineBarDataSet = lineBarSet;
    [_lineBarChart drawLineBarChart];
    [self.view addSubview:_lineBarChart];
    
    
    _lineBarSet = lineBarSet;
    
    
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
    _barData1.dataAry = @[@-1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    _barData2.dataAry = @[@11.29, @11.88, @11.46, @-13.30, @13.66, @13.23, @13.48, @13.51];
    
    _lineData1.dataAry = @[@-1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    _lineData2.dataAry = @[@11.29, @-11.88, @11.46, @-13.30, @-13.66, @-3.23, @-3.48, @-3.51];
    
    [_lineBarChart drawLineBarChart];
}

- (void)analogDataSecond
{
    _barData1.dataAry = @[@1.29, @-1.88, @1.46, @3.30, @3.66, @-3.23, @-3.48, @3.51];
    _barData2.dataAry = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    _lineData1.dataAry = @[@-1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    _lineData2.dataAry = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    [_lineBarChart drawLineBarChart];
}

- (void)analogDataThird
{
    _barData1.dataAry = @[@-1.29, @-1.88, @-1.46, @-3.30, @-3.66, @-3.23, @-3.48, @-3.51];
    _barData2.dataAry = @[@-11.29, @-11.88, @11.46, @-13.30, @-13.66, @13.23, @13.48, @13.51];
    
    _lineData1.dataAry = @[@-1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    _lineData2.dataAry = @[@-11.29, @-11.88, @-11.46, @-13.30, @-13.66, @-3.23, @-3.48, @-3.51];
    
    [_lineBarChart drawLineBarChart];
}

@end
