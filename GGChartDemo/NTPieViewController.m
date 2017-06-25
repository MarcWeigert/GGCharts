//
//  NTPieViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/10.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NTPieViewController.h"
#import "PieChartData.h"
#import "Colors.h"
#import "NTPieChart.h"
#import "PieChart.h"

@interface NTPieViewController ()

@end

@implementation NTPieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NTPieChart";
    
    PieChartData * pie_d1 = [[PieChartData alloc] init];
    pie_d1.pieName = @"直接访问";
    pie_d1.pieData = @335;
    pie_d1.color = __RGB_RED;
    
    PieChartData * pie_d2 = [[PieChartData alloc] init];
    pie_d2.pieName = @"直接访问";
    pie_d2.pieData = @310;
    pie_d2.color = __RGB_BLUE;
    
    PieChartData * pie_d3 = [[PieChartData alloc] init];
    pie_d3.pieName = @"直接访问";
    pie_d3.pieData = @234;
    pie_d3.color = __RGB_GREEN;
    
    PieChartData * pie_d4 = [[PieChartData alloc] init];
    pie_d4.pieName = @"直接访问";
    pie_d4.pieData = @735;
    pie_d4.color = __RGB_ORIGE;
    
    PieChartData * pie_d5 = [[PieChartData alloc] init];
    pie_d5.pieName = @"直接访问";
    pie_d5.pieData = @1548;
    pie_d5.color = __RGB_CYAN;
    
    PieChartData * pie_d6 = [[PieChartData alloc] init];
    pie_d6.pieName = @"直接访问";
    pie_d6.pieData = @748;
    pie_d6.color = __RGB_CYAN;
    
    PieChartData * pie_d7 = [[PieChartData alloc] init];
    pie_d7.pieName = @"直接访问";
    pie_d7.pieData = @148;
    pie_d7.color = __RGB_BLACK;
    
    NSArray * pieData = @[pie_d1, pie_d2, pie_d3, pie_d4, pie_d5];
    
    PieChart * chart = [[PieChart alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
    chart.radius = 80;
    chart.sectorAry = pieData;
    
//    chart.annularRadius = 80;
//    chart.annularWidth = 15;
//    chart.annularAry = @[pie_d2, pie_d3, pie_d5, pie_d7, pie_d6];
    
    [chart strockChart];
    [chart addAnimationWithDuration:.7];
    
    [self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
