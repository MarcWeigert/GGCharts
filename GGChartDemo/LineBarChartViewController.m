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

@interface LineBarChartViewController ()

@property (nonatomic) LineBarChart * lineBarChart;

@end

@implementation LineBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"LineBarChartView";
    
    // 柱状数据
    BarData * barData = [[BarData alloc] init];
    barData.color = __RGB_BLUE;
    barData.width = 8;
    barData.datas = @[@1.29, @1.88, @1.46, @3.30, @3.66, @3.23, @3.48, @3.51];
    
    //[barData addTarget:self action:@selector(onTouchBar:index:) forBarEvents:TouchEventMoveNear];
    
    BarData * barData1 = [[BarData alloc] init];
    barData1.color = __RGB_RED;
    barData1.width = 8;
    barData1.datas = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    BarData * barData2 = [[BarData alloc] init];
    barData2.color = __RGB_CYAN;
    barData2.width = 8;
    barData2.datas = @[@11.29, @11.88, @11.46, @13.30, @13.66, @13.23, @13.48, @13.51];
    //barData2.isShowString = YES;
    
    // 线数据
    LineData * lineData = [[LineData alloc] init];
    lineData.color = __RGB_RED;
    lineData.datas = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    // 线数据
    LineData * lineData1 = [[LineData alloc] init];
    lineData1.color = __RGB_ORIGE;
    lineData1.datas = @[@11.29, @-11.88, @11.46, @-13.30, @13.66, @3.23, @-3.48, @-3.51];
    lineData1.stringColor = __RGB_ORIGE;
    //[lineData1 addTarget:self action:@selector(onTouchLine:index:) forBarEvents:TouchEventMoveNear];
    
    _lineBarChart = [[LineBarChart alloc] initWithFrame:CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200)];
    _lineBarChart.lbTop.text = @"最近五日主力增减仓";
    _lineBarChart.lbBottom.text = @"净利润 (万元) ";
    _lineBarChart.xAxisTitles = @[@"15Q2", @"15Q3", @"15Q4", @"16Q1", @"16Q2", @"16Q3", @"16Q4", @"17Q1"];
    _lineBarChart.barDataAry = @[barData, barData1, barData2];
    _lineBarChart.lineDataAry = @[lineData, lineData1];
    _lineBarChart.isNeedSplitX = YES;
    //_lineBarChart.barPile = YES;
    //_lineBarChart.linePile = YES;
    _lineBarChart.axisFont = [UIFont systemFontOfSize:9];
    
    //_lineBarChart.attachedString = @"%";
    _lineBarChart.yAxisSplit = 3;
    [_lineBarChart drawChart];
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

- (void)onTouchBar:(CGRect)rect index:(NSInteger)index
{
    NSLog(@"barMove");
    
    NSLog(@"x : %.2f, y : %.2f, w : %.2f, h : %.2f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    NSLog(@"%zd", index);
}

- (void)onTouchLine:(CGPoint)point index:(NSInteger)index
{
    NSLog(@"lineMove");
    
    NSLog(@"x : %.2f, y : %.2f", point.x, point.y);
    
    NSLog(@"%zd", index);
}

- (void)analogDataFirst
{
    // 柱状数据
    BarData * barData = [[BarData alloc] init];
    barData.color = __RGB_BLUE;
    barData.width = 8;
    barData.datas = @[@-1.29, @1.88, @-1.46, @3.30, @-3.66, @-3.23, @3.48, @3.51];
    
    BarData * barData1 = [[BarData alloc] init];
    barData1.color = __RGB_RED;
    barData1.width = 8;
    barData1.datas = @[@-1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    BarData * barData2 = [[BarData alloc] init];
    barData2.color = __RGB_CYAN;
    barData2.width = 8;
    barData2.datas = @[@11.29, @11.88, @11.46, @-13.30, @13.66, @13.23, @13.48, @13.51];
    
    // 线数据
    LineData * lineData = [[LineData alloc] init];
    lineData.color = __RGB_RED;
    lineData.datas = @[@-1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    // 线数据
    LineData * lineData1 = [[LineData alloc] init];
    lineData1.color = __RGB_ORIGE;
    lineData1.datas = @[@11.29, @-11.88, @11.46, @-13.30, @-13.66, @-3.23, @-3.48, @-3.51];
    
    _lineBarChart.barDataAry = @[barData, barData1, barData2];
    _lineBarChart.lineDataAry = @[lineData, lineData1];
    [_lineBarChart updateChart];
}

- (void)analogDataSecond
{
    // 柱状数据
    BarData * barData = [[BarData alloc] init];
    barData.color = __RGB_BLUE;
    barData.width = 8;
    barData.datas = @[@1.29, @-1.88, @1.46, @3.30, @3.66, @-3.23, @-3.48, @3.51];
    
    BarData * barData1 = [[BarData alloc] init];
    barData1.color = __RGB_RED;
    barData1.width = 8;
    barData1.datas = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    BarData * barData2 = [[BarData alloc] init];
    barData2.color = __RGB_CYAN;
    barData2.width = 8;
    barData2.datas = @[@11.29, @11.88, @11.46, @13.30, @13.66, @13.23, @13.48, @13.51];
    
    // 线数据
    LineData * lineData = [[LineData alloc] init];
    lineData.color = __RGB_RED;
    lineData.datas = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    // 线数据
    LineData * lineData1 = [[LineData alloc] init];
    lineData1.color = __RGB_ORIGE;
    lineData1.datas = @[@11.29, @-11.88, @11.46, @-13.30, @13.66, @3.23, @-3.48, @-3.51];
    
    _lineBarChart.barDataAry = @[barData, barData1, barData2];
    _lineBarChart.lineDataAry = @[lineData, lineData1];
    [_lineBarChart updateChart];
}

- (void)analogDataThird
{
    // 柱状数据
    BarData * barData = [[BarData alloc] init];
    barData.color = __RGB_BLUE;
    barData.width = 8;
    barData.datas = @[@1.29, @-1.88, @-1.46, @3.30, @-3.66, @-3.23, @3.48, @3.51];
    
    BarData * barData1 = [[BarData alloc] init];
    barData1.color = __RGB_RED;
    barData1.width = 8;
    barData1.datas = @[@-1.29, @-1.88, @-1.46, @-3.30, @-3.66, @-3.23, @-3.48, @-3.51];
    
    BarData * barData2 = [[BarData alloc] init];
    barData2.color = __RGB_CYAN;
    barData2.width = 8;
    barData2.datas = @[@-11.29, @-11.88, @11.46, @-13.30, @-13.66, @13.23, @13.48, @13.51];
    
    // 线数据
    LineData * lineData = [[LineData alloc] init];
    lineData.color = __RGB_RED;
    lineData.datas = @[@-1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    // 线数据
    LineData * lineData1 = [[LineData alloc] init];
    lineData1.color = __RGB_ORIGE;
    lineData1.datas = @[@-11.29, @-11.88, @-11.46, @-13.30, @-13.66, @-3.23, @-3.48, @-3.51];
    
    _lineBarChart.barDataAry = @[barData, barData1, barData2];
    _lineBarChart.lineDataAry = @[lineData, lineData1];
    [_lineBarChart updateChart];
}

@end
