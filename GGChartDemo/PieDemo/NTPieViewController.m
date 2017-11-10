//
//  NTPieViewController.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/10.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NTPieViewController.h"

#import "PieChart.h"
#import "NSAttributedString+GGChart.h"

@interface NTPieViewController ()

@property (nonatomic, strong) PieData * pie;

@property (nonatomic, strong) PieDataSet * dataSet;

@property (nonatomic, strong) PieChart * pieChart;

@end

@implementation NTPieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"NTPieChart";
    
    NSArray * titleArray = @[@"华泰证券", @"国泰证券", @"海通证券", @"中信证券", @"广大证券", @"广发证券"];
    NSArray * dataArray = @[@335, @310, @234, @735, @1548];
    NSArray * colorArray = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN, __RGB_PINK];
    
    PieData * pie = [[PieData alloc] init];
    pie.radiusRange = GGRadiusRangeMake(0, GG_SIZE_CONVERT(90));
    pie.showOutLableType = OutSideShow;
    pie.dataAry = dataArray;
    pie.outSideLable.lineSpacing = GG_SIZE_CONVERT(20);
    pie.outSideLable.lineLength = GG_SIZE_CONVERT(10);
    pie.outSideLable.inflectionLength = GG_SIZE_CONVERT(10);
    pie.outSideLable.linePointRadius = 1.5;
    
    [pie setPieColorsForIndex:^(NSInteger index, CGFloat ratio){
        
        return colorArray[index];
    }];
    
    [pie.outSideLable setLineColorsBlock:^(NSInteger index, CGFloat ratio){
        
        return colorArray[index];
    }];
    
    [pie.outSideLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat value, CGFloat ratio) {
        
        UIColor * color = colorArray[index];
        NSString * ratioString = [NSString stringWithFormat:@"%d%%", (int)(ratio * 100)];
        NSString * priceString = [NSString stringWithFormat:@"%.f万元", value];
        
        return [NSAttributedString pieOutSideStringWithTitle:titleArray[index]
                                                       ratio:ratioString
                                                       price:priceString
                                                  ratioColor:color];
    }];
    
    PieDataSet * dataSet = [[PieDataSet alloc] init];
    dataSet.pieAry = @[pie];
    dataSet.borderRadius = GG_SIZE_CONVERT(94);
    dataSet.pieBorderWidth = .7f;
    dataSet.pieBorderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    dataSet.showCenterLable = YES;
    dataSet.centerLable.radius = 80 / 5 * 2.2;
    dataSet.centerLable.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
    [dataSet.centerLable.lable setAttrbuteStringValueBlock:^NSAttributedString *(CGFloat value) {
        
        return [NSAttributedString pieCenterStringWithTitle:@"今日" subTitle:@"资金"];
    }];
    
    dataSet.updateNeedAnimation = YES;
    
    PieChart * pieChart = [[PieChart alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 400)];
    pieChart.pieDataSet = dataSet;
    
    [pieChart drawPieChart];
    [pieChart startAnimationsWithType:EjectAnimation duration:1.5f];
    
    [self.view addSubview:pieChart];
    
    _pie = pie;
    _dataSet = dataSet;
    _pieChart = pieChart;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(10, 450, 100, 50)];
    [btn setTitle:@"模拟数据一" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataFirst) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(120, 450, 100, 50)];
    [btn setTitle:@"模拟数据二" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataSecond) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(230, 450, 100, 50)];
    [btn setTitle:@"模拟数据三" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataThird) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)analogDataFirst
{
    _pie.dataAry = @[@310, @1548, @234, @335, @735];
    
    [_pieChart drawPieChart];
}

- (void)analogDataSecond
{
    _pie.dataAry = @[@735, @310, @234, @335, @1548];
    
    [_pieChart drawPieChart];
}

- (void)analogDataThird
{
    _pie.dataAry = @[@234, @310, @1548, @735, @335];
    
    [_pieChart drawPieChart];
}

@end
