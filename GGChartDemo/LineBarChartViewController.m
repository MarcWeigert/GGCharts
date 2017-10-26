//
//  LineBarChartViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineBarChartViewController.h"
#import "LineBarChart.h"

#import "LineData.h"
#import "BarData.h"

@interface LineBarChartViewController ()

@property (nonatomic) LineBarChart * lineBarChart;

@property (nonatomic, strong) BarData * barData1;
@property (nonatomic, strong) BarData * barData2;

@property (nonatomic, strong) LineData * lineData1;
@property (nonatomic, strong) LineData * lineData2;

@end

@implementation LineBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"并列 堆叠 环绕";
    
    _barData1 = [[BarData alloc] init];
    _barData1.dataAry = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    _barData1.barWidth = 10;
    _barData1.barFillColor = __RGB_RED;
    
    _barData2 = [[BarData alloc] init];
    _barData2.dataAry = @[@11.29, @11.88, @11.46, @13.30, @13.66, @13.23, @13.48, @13.51];
    _barData2.barWidth = 10;
    _barData2.barFillColor = __RGB_CYAN;
    
    _lineData1 = [[LineData alloc] init];
    _lineData1.lineColor = __RGB_RED;
    _lineData1.scalerMode = ScalerAxisRight;
    _lineData1.shapeRadius = 2;
    _lineData1.dataAry = @[@1.29, @-1.88, @1.46, @-3.30, @3.66, @3.23, @-3.48, @-3.51];
    
    _lineData2 = [[LineData alloc] init];
    _lineData2.lineColor = __RGB_ORIGE;
    _lineData2.scalerMode = ScalerAxisRight;
    _lineData2.shapeRadius = 2;
    _lineData2.dataAry = @[@11.29, @-11.88, @11.46, @-13.30, @13.66, @3.23, @-3.48, @-3.51];
    
    LineBarDataSet * lineBarSet = [[LineBarDataSet alloc] init];
    lineBarSet.insets = UIEdgeInsetsMake(30, 40, 30, 40);
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
    
    // LineBar Demo 1
    _lineBarChart = [[LineBarChart alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width - 10, 200)];
    _lineBarChart.lineBarDataSet = lineBarSet;
    [_lineBarChart drawLineBarChart];
    [self.view addSubview:_lineBarChart];
    [_lineBarChart startLineAnimationsWithType:LineAnimationRiseType duration:.8f];
    [_lineBarChart startBarAnimationsWithType:BarAnimationRiseType duration:.8f];
    
    // LineBar Demo 2
    lineBarSet.lineBarMode = LineBarDrawPNHeapUp;
    _lineBarChart = [[LineBarChart alloc] initWithFrame:CGRectMake(5, _lineBarChart.gg_bottom, [UIScreen mainScreen].bounds.size.width - 10, 200)];
    _lineBarChart.lineBarDataSet = lineBarSet;
    [_lineBarChart drawLineBarChart];
    [self.view addSubview:_lineBarChart];
    [_lineBarChart startLineAnimationsWithType:arc4random() % 2 == 0 ? LineAnimationStrokeType : LineAnimationRiseType duration:.8f];
    [_lineBarChart startBarAnimationsWithType:BarAnimationRiseType duration:.8f];
    
    BarData * barData3 = [[BarData alloc] init];
    barData3.dataAry = @[@-11.29, @11.88, @-11.46, @13.30, @-13.66, @13.23, @-13.48, @13.51];
    barData3.barWidth = 10;
    barData3.barFillColor = __RGB_ORIGE;
    
    // LineBar Demo 3
    _barData1.roundNumber = @0;
    _barData2.roundNumber = @0;
    barData3.roundNumber = @0;
    _lineData1.roundNumber = @0;
    _lineData2.roundNumber = @0;
    
    _lineData1.stringFont = [UIFont systemFontOfSize:9];
    _lineData1.dataFormatter = @"%.2f";
    _lineData1.stringColor = __RGB_RED;
    
    lineBarSet.lineBarMode = LineBarDrawPNHeapUp;
    lineBarSet.gridConfig.leftNumberAxis.dataFormatter = @"%.2f";
    lineBarSet.gridConfig.rightNumberAxis.dataFormatter = @"%.2f";
    lineBarSet.barAry = @[_barData1, _barData2, barData3];
    
    _lineBarChart = [[LineBarChart alloc] initWithFrame:CGRectMake(5, _lineBarChart.gg_bottom, [UIScreen mainScreen].bounds.size.width - 10, 200)];
    _lineBarChart.lineBarDataSet = lineBarSet;
    [_lineBarChart drawLineBarChart];
    [self.view addSubview:_lineBarChart];
    [_lineBarChart startLineAnimationsWithType:LineAnimationStrokeType duration:.8f];
    [_lineBarChart startBarAnimationsWithType:BarAnimationRiseType duration:.8f];
}

@end
