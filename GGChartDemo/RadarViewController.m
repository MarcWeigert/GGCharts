//
//  RadarViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RadarViewController.h"

#import "GGRadarChart.h"

@interface RadarViewController ()

@property (nonatomic, strong) RadarDataSet * radarDataSet;

@end

@implementation RadarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _radarDataSet = [[RadarDataSet alloc] init];
    _radarDataSet.indicatorSet = @[RardarIndicatorMake(@"1月", 100),
                                   RardarIndicatorMake(@"2月", 100),
                                   RardarIndicatorMake(@"3月", 100),
                                   RardarIndicatorMake(@"4月", 100),
                                   RardarIndicatorMake(@"5月", 100),
                                   RardarIndicatorMake(@"6月", 100),
                                   RardarIndicatorMake(@"7月", 100),
                                   RardarIndicatorMake(@"8月", 100),
                                   RardarIndicatorMake(@"9月", 100),
                                   RardarIndicatorMake(@"10月", 100),
                                   RardarIndicatorMake(@"11月", 100),
                                   RardarIndicatorMake(@"12月", 100)];
    
    RadarData * radarData = [[RadarData alloc] init];
    radarData.datas = @[@2.6, @5.9, @9.0, @26.4, @28.7, @70.7, @75.6, @82.2, @48.7, @18.8, @6.0, @2.3];
    radarData.fillColor = [[UIColor blueColor] colorWithAlphaComponent:.5f];
    radarData.strockColor = [UIColor blackColor];
    radarData.lineWidth = .5f;
    
    RadarData * radarData1 = [[RadarData alloc] init];
    radarData1.datas = @[@2.0, @4.9, @7.0, @23.2, @25.6, @76.7, @35.6, @62.2, @32.6, @20.0, @6.4, @3.3];
    radarData1.fillColor = [[UIColor yellowColor] colorWithAlphaComponent:.5f];
    radarData1.strockColor = [UIColor blackColor];
    radarData1.lineWidth = .5f;
    
    _radarDataSet.titleFont = [UIFont systemFontOfSize:12];
    _radarDataSet.strockColor = [UIColor blackColor];
    _radarDataSet.stringColor = [UIColor blackColor];
    _radarDataSet.lineWidth = .5f;
    _radarDataSet.radius = 100;
    _radarDataSet.splitCount = 3;
    _radarDataSet.radarSet = @[radarData, radarData1];
    
    GGRadarChart * radarChart = [[GGRadarChart alloc] initWithFrame:self.view.frame];
    radarChart.radarData = _radarDataSet;
    [radarChart drawRadarChart];
    
    [self.view addSubview:radarChart];
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
