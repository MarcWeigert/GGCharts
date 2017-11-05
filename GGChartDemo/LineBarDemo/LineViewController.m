//
//  LineViewController.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineViewController.h"
#import "LineCanvas.h"
#import "LineDataSet.h"
#import "LineData.h"
#import "GridBackCanvas.h"
#import "LineChart.h"

@interface LineViewController ()

@property (nonatomic, strong) LineData * line;
@property (nonatomic, strong) LineChart * lineChart;

@end

@implementation LineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"自定义最大最小值";
    
    LineData * line = [[LineData alloc] init];
    line.lineWidth = 1;
    line.lineColor = C_HEX(0xf64646);
    line.dataAry = @[@28, @65, @45, @78, @82, @65];
    line.shapeRadius = 3;
    line.stringFont = [UIFont systemFontOfSize:12];
    line.dataFormatter = @"%.f 分";
    line.stringColor = C_HEX(0xf64646);
    line.lineFillColor = [[UIColor redColor] colorWithAlphaComponent:.5f];
    line.gradientFillColors = @[(__bridge id)C_HEX(0xF9EDD9).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    line.locations = @[@0.7, @1];
    line.shapeLineWidth = 1;
    line.dashPattern = @[@2, @2];
    _line = line;
    
    LineDataSet * lineSet = [[LineDataSet alloc] init];
    lineSet.insets = UIEdgeInsetsMake(30, 50, 30, 30);
    lineSet.lineAry = @[line];
    lineSet.updateNeedAnimation = YES;
    
    lineSet.gridConfig.lineColor = C_HEX(0xe4e4e4);
    lineSet.gridConfig.lineWidth = .5f;
    lineSet.gridConfig.axisLineColor = RGB(146, 146, 146);
    lineSet.gridConfig.axisLableColor = RGB(146, 146, 146);
    
    lineSet.gridConfig.bottomLableAxis.lables = @[@"2月", @"3月", @"4月", @"5月", @"6月", @"7月"];
    lineSet.gridConfig.bottomLableAxis.drawStringAxisCenter = YES;
    lineSet.gridConfig.bottomLableAxis.over = 0;
    
    lineSet.gridConfig.leftNumberAxis.splitCount = 2;
    lineSet.gridConfig.leftNumberAxis.max = @100;
    lineSet.gridConfig.leftNumberAxis.min = @0;
    lineSet.gridConfig.leftNumberAxis.dataFormatter = @"%.f";
    lineSet.gridConfig.leftNumberAxis.showSplitLine = YES;
    
    LineChart * lineChart = [[LineChart alloc] initWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 180)];
    lineChart.lineDataSet = lineSet;
    [lineChart drawLineChart];
    [self.view addSubview:lineChart];
    [lineChart startAnimationsWithType:LineAnimationRiseType duration:.5f];
    _lineChart = lineChart;
    
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
    _line.dataAry = @[@48, @75, @15, @98, @12, @35];
    
    [_lineChart drawLineChart];
}

- (void)analogDataSecond
{
    _line.dataAry = @[@1, @3, @100, @50, @20, @65];
    
    [_lineChart drawLineChart];
}

- (void)analogDataThird
{
    _line.dataAry = @[@82, @56, @54, @87, @28, @40];
    
    [_lineChart drawLineChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
