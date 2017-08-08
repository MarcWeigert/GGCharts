//
//  LineViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineViewController.h"
#import "LineCanvas.h"
#import "LineDataSet.h"
#import "GGLineData.h"
#import "GridBackCanvas.h"
#import "GGChartDefine.h"
#import "GGLineChart.h"

@interface LineViewController ()

@end

@implementation LineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GGLineData * line = [[GGLineData alloc] init];
    line.lineWidth = 1;
    line.lineColor = C_HEX(0xf64646);
    line.lineDataAry = @[@28, @65, @45, @78, @82, @65];
    line.shapeRadius = 3;
    line.stringFont = [UIFont systemFontOfSize:12];
    line.dataFormatter = @"%.f 分";
    line.stringColor = C_HEX(0xf64646);
    line.lineFillColor = [[UIColor redColor] colorWithAlphaComponent:.5f];
    line.gradientColors = @[(__bridge id)C_HEX(0xF9EDD9).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    line.locations = @[@0.7, @1];
    
    LineDataSet * lineSet = [[LineDataSet alloc] init];
    lineSet.insets = UIEdgeInsetsMake(30, 50, 30, 30);
    lineSet.lineAry = @[line];
    lineSet.gridColor = C_HEX(0xe4e4e4);
    lineSet.gridLineWidth = .5f;
    
    lineSet.bottomAxis.titles = @[@"2月", @"3月", @"4月", @"5月", @"6月", @"7月"];
    lineSet.bottomAxis.drawStringAxisCenter = YES;
    lineSet.bottomAxis.needShowGridLine = NO;
    lineSet.bottomAxis.over = 0;
    lineSet.bottomAxis.axisColor = RGB(146, 146, 146);
    
    lineSet.leftAxis.splitCount = 2;
    lineSet.leftAxis.max = @100;
    lineSet.leftAxis.min = @0;
    lineSet.leftAxis.dataFormatter = @"%.f";
    lineSet.leftAxis.axisColor = RGB(146, 146, 146);
    lineSet.leftAxis.needShowAxisLine = NO;
    lineSet.isCenterAlignment = YES;
    
    GGLineChart * lineChart = [[GGLineChart alloc] initWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 180)];
    lineChart.lineDataSet = lineSet;
    [lineChart drawLineChart];
    [self.view addSubview:lineChart];
    
    [lineChart startAnimation:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
