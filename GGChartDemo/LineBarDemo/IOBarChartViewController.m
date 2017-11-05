//
//  IOBarChartViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "IOBarChartViewController.h"

#import "BarChart.h"

@interface IOBarChartViewController ()

@property (nonatomic, strong) BarChart * barChart;

@property (nonatomic, strong) BarDataSet * barDataSet;

@property (nonatomic, strong) BarData * barData;

@end

@implementation IOBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"IOBarChart";
    
    _barData = [[BarData alloc] init];
    _barData.barWidth = GG_SIZE_CONVERT(25);
    _barData.roundNumber = @0;
    _barData.dataAry = @[@-2225.6, @-2563.1, @531.4, @839.4, @-897.0, @1500];
    
    _barData.dataFormatter = @"%.2f";
    _barData.stringColor = [UIColor blackColor];
    _barData.stringFont = [UIFont systemFontOfSize:GG_SIZE_CONVERT(11)];
    
    _barDataSet = [[BarDataSet alloc] init];
    _barDataSet.barAry = @[_barData];
    _barDataSet.lineBarMode = LineBarDrawParallel;
    _barDataSet.midLineWidth = .5f;
    _barDataSet.midLineColor = RGB(140, 154, 163);
    _barDataSet.updateNeedAnimation = YES;
    _barDataSet.idRatio = 0;
    
    _barDataSet.gridConfig.bottomLableAxis.lables = @[@"7-24", @"7-25", @"7-26", @"7-27", @"7-28", @"7-29"];
    _barDataSet.gridConfig.bottomLableAxis.drawStringAxisCenter = YES;
    
    [_barDataSet setBarColorsAtIndexPath:^UIColor *(NSIndexPath * index, NSNumber * number) {
        
        return number.floatValue > 0 ? RGB(241, 73, 81) : RGB(30, 191, 97);
    }];
    
    [_barDataSet setStringColorForValue:^UIColor *(CGFloat value) {
        
        return value > 0 ? RGB(241, 73, 81) : RGB(30, 191, 97);
    }];
    
    _barChart = [[BarChart alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    _barChart.barDataSet = _barDataSet;
    [self.view addSubview:_barChart];
    
    [_barChart drawBarChart];
    [_barChart startAnimationsWithType:BarAnimationRiseType duration:.5f];
    
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
    _barData.dataAry = @[@2225.6, @2563.1, @531.4, @839.4, @107.4, @1500];
    
    [_barChart drawBarChart];
}

- (void)analogDataSecond
{
    _barData.dataAry = @[@-2225.6, @-839.4, @-7.4, @-1000, @-897.0, @-1500];
    
    [_barChart drawBarChart];
}

- (void)analogDataThird
{
    _barData.dataAry = @[@-2225.6, @2563.1, @-531.4, @-839.4, @7.4, @-1000];
    
    [_barChart drawBarChart];
}

@end
