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

#import "GGLineChart.h"

@interface LineViewController ()

@end

@implementation LineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    GGLineData * line = [[GGLineData alloc] init];
    line.lineWidth = 1;
    line.lineColor = [UIColor redColor];
    line.lineDataAry = @[@820, @932, @901, @934, @1290, @1330, @1320];
    line.shapeRadius = 3;
    line.stringFont = [UIFont systemFontOfSize:12];
    line.dataFormatter = @"%.f";
    line.scalerType = ScalerAxisRight;
//    line.lineFillColor = [[UIColor redColor] colorWithAlphaComponent:.5f];
    line.fillRoundPrice = @1000;
    
    GGLineData * line2 = [[GGLineData alloc] init];
    line2.lineWidth = 1;
    line2.lineColor = [UIColor blackColor];
    line2.lineDataAry = @[@0.5, @.84, @.02, @.34, @.3, @1.5, @.01];
    line2.shapeRadius = 3;
    line2.stringFont = [UIFont systemFontOfSize:12];
    line2.dataFormatter = @"%.2fC";
    line2.scalerType = ScalerAxisLeft;
//    line2.lineFillColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    line2.fillRoundPrice = @0;
    
    LineDataSet * lineSet = [[LineDataSet alloc] init];
    lineSet.insets = UIEdgeInsetsMake(30, 50, 30, 50);
    lineSet.lineAry = @[line, line2];
    lineSet.gridColor = [UIColor blackColor];
    lineSet.gridLineWidth = .5f;
    lineSet.bottomAxis.titles = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月"];
    lineSet.bottomAxis.drawStringAxisCenter = YES;
    lineSet.leftAxis.splitCount = 5;
    //    lineSet.leftAxis.axisFont = [UIFont systemFontOfSize:6];
    lineSet.topAxis.titles = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月"];
    lineSet.topAxis.drawStringAxisCenter = YES;
    lineSet.rightAxis.splitCount = 5;
    lineSet.isGroupingAlignment = YES;
    //    lineSet.isCenterAlignment = YES;
    
    GGLineChart * lineChart = [[GGLineChart alloc] initWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 300)];
    lineChart.lineDataSet = lineSet;
    [lineChart drawLineChart];
    [self.view addSubview:lineChart];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
