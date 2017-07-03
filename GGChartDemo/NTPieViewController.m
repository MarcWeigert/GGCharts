//
//  NTPieViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/10.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NTPieViewController.h"
#import "PieData.h"
#import "Colors.h"
#import "PieChart.h"

@interface NTPieViewController ()

@end

@implementation NTPieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NTPieChart";
    
    PieData * pie_d1 = [[PieData alloc] init];
    pie_d1.pieName = @"直接访问";
    pie_d1.data = 335;
    pie_d1.color = __RGB_RED;
    
    PieData * pie_d2 = [[PieData alloc] init];
    pie_d2.pieName = @"直接访问";
    pie_d2.data = 310;
    pie_d2.color = __RGB_BLUE;
    
    PieData * pie_d3 = [[PieData alloc] init];
    pie_d3.pieName = @"直接访问";
    pie_d3.data = 234;
    pie_d3.color = __RGB_GREEN;
    
    PieData * pie_d4 = [[PieData alloc] init];
    pie_d4.pieName = @"直接访问";
    pie_d4.data = 735;
    pie_d4.color = __RGB_ORIGE;
    
    PieData * pie_d5 = [[PieData alloc] init];
    pie_d5.pieName = @"直接访问";
    pie_d5.data = 1548;
    pie_d5.color = __RGB_CYAN;
    
    PieData * pie_d6 = [[PieData alloc] init];
    pie_d6.pieName = @"直接访问";
    pie_d6.data = 748;
    pie_d6.color = __RGB_CYAN;
    
    PieData * pie_d7 = [[PieData alloc] init];
    pie_d7.pieName = @"直接访问";
    pie_d7.data = 148;
    pie_d7.color = __RGB_BLACK;
    
    NSArray * pieData = @[pie_d1, pie_d2, pie_d3, pie_d4, pie_d5];
    
    PieChart * chart = [[PieChart alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
    chart.radius = 80;
    chart.dataAry = pieData;
    
    [chart drawChart];
    [chart addAnimationWithDuration:3.f];
    
    [self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
