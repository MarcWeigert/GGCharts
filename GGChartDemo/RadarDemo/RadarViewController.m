//
//  RadarViewController.m
//  GGCharts
//
//  Created by _ | Durex on 17/10/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarViewController.h"
#import "RadarChart.h"

@interface RadarViewController ()

@property (nonatomic, strong) RadarDataSet * radarDataSet;

@end

@implementation RadarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 背景色
    [self.navigationController.navigationBar setBarTintColor:C_HEX(0x151515)];
    
    // 导航栏字体
    NSDictionary * dictionaryNavi = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dictionaryNavi];
    
    self.title = @"雷达图";
    
    self.view.backgroundColor = C_HEX(0x242424);
    
    _radarDataSet = [[RadarDataSet alloc] init];
    _radarDataSet.indicatorSet = @[RardarIndicatorMake(@"业绩洞察", 115), RardarIndicatorMake(@"商业模式", 115),
                                   RardarIndicatorMake(@"市场洞察", 115), RardarIndicatorMake(@"投资者专业能力", 115),
                                   RardarIndicatorMake(@"事件洞察", 115), RardarIndicatorMake(@"行业洞察", 115)];
    
    NSNumber * number1 = @(115 - 32);
    NSNumber * number2 = @(115 - 100);
    NSNumber * number3 = @(115 - 5);
    NSNumber * number4 = @(115 - 73.5);
    NSNumber * number5 = @(115 - 10);
    NSNumber * number6 = @(115 - 35);
    
    RadarData * radarData = [[RadarData alloc] init];
    radarData.datas = @[number1, number2, number3, number4, number5, number6];
    radarData.strockColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
    radarData.lineWidth = .5f;
    radarData.shapeRadius = 1.5f;
    radarData.shapeLineWidth = .5f;
    radarData.shapeFillColor = [UIColor whiteColor];
    radarData.gradientColors = @[(__bridge id)C_HEXA(0x4CB2D8, .5f).CGColor,
                                 (__bridge id)C_HEXA(0x435CD1, .5f).CGColor];
    
    RadarData * radarData1 = [[RadarData alloc] init];
    radarData1.datas = @[number1, number2, @(0), @(0), number5, number6];
    radarData1.lineWidth = .0f;
    radarData1.gradientColors = @[(__bridge id)C_HEXA(0x4CB2D8, .2f).CGColor,
                                  (__bridge id)C_HEXA(0x435CD1, .2f).CGColor];
    
    RadarData * radarData2 = [[RadarData alloc] init];
    radarData2.datas = @[number1, number2, number3, number4, @(0), @(0)];
    radarData2.lineWidth = .0f;
    radarData2.gradientColors = @[(__bridge id)C_HEXA(0x4CB2D8, .2f).CGColor,
                                  (__bridge id)C_HEXA(0x435CD1, .2f).CGColor];
    
    RadarData * radarData3 = [[RadarData alloc] init];
    radarData3.datas = @[number1, number2, @(0), @(0), @(0), number6];
    radarData3.lineWidth = .0f;
    radarData3.gradientColors = @[(__bridge id)C_HEXA(0x4CB2D8, .2f).CGColor,
                                  (__bridge id)C_HEXA(0x435CD1, .2f).CGColor];
    
    _radarDataSet.titleFont = [UIFont systemFontOfSize:11];
    _radarDataSet.strockColor = C_HEX(0x2E2D31);
    _radarDataSet.stringColor = C_HEX(0x666666);
    _radarDataSet.lineWidth = .5f;
    _radarDataSet.radius = 115;
    _radarDataSet.borderWidth = 1.0f;
    _radarDataSet.splitCount = 5;
    _radarDataSet.isCirlre = YES;
    _radarDataSet.radarSet = @[radarData, radarData1, radarData2, radarData3];
    
    RadarChart * radarChart = [[RadarChart alloc] initWithFrame:self.view.frame];
    radarChart.radarData = _radarDataSet;
    [radarChart drawRadarChart];
    
    [self.view addSubview:radarChart];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
