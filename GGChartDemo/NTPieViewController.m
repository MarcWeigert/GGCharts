//
//  NTPieViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/10.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NTPieViewController.h"

#import "Colors.h"

#import "PieChart.h"

@interface NTPieViewController ()

@end

@implementation NTPieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NTPieChart";
    
    NSArray * titleArray = @[@"直接访问", @"邮件营销", @"联盟广告", @"视频广告", @"搜索引擎"];
    NSArray * dataArray = @[ @335, @310, @234, @735, @1548];
    NSArray * colorArray = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
    
    PieData * pie = [[PieData alloc] init];
    pie.radiusRange = GGRadiusRangeMake(0, 80);
    pie.showOutLableType = OutSideShow;
    pie.dataAry = dataArray;
    pie.outSideLable.lineSpacing = 5;
    pie.outSideLable.lineLength = 10;
    pie.outSideLable.inflectionLength = 10;
    pie.outSideLable.linePointRadius = 1.5;
    pie.innerLable.stringOffSet = CGSizeMake(-.5, 0);
    
    [pie setPieColorsForIndex:^(NSInteger index, CGFloat ratio){
        
        return colorArray[index];
    }];
    
    [pie.outSideLable setLineColorsBlock:^(NSInteger index, CGFloat ratio){
        
        return colorArray[index];
    }];
    
    PieDataSet * dataSet = [[PieDataSet alloc] init];
    dataSet.pieAry = @[pie];
    
    
    PieChart * pieChart = [[PieChart alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
    pieChart.pieDataSet = dataSet;
    
    [pieChart drawPieChart];
    
    [self.view addSubview:pieChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
