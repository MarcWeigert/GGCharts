//
//  PieDemoChartViewController.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieDemoChartViewController.h"
#import "PieChart.h"
#import "NSAttributedString+GGChart.h"

@interface PieDemoChartViewController ()

@property (nonatomic, strong) PieChart * pieChart;

@property (nonatomic, strong) PieData * pie;

@end

@implementation PieDemoChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扇形图";
    
    NSArray * pieColors = @[C_HEX(0xF04D00), C_HEX(0xFBD439), C_HEX(0x23AADA)];
    
    NSArray * gradAryColors = @[@[C_HEX(0xFFB04F), C_HEX(0xF96B46)],
                                @[C_HEX(0xFFE70E), C_HEX(0xFFF283)],
                                @[C_HEX(0x0ECFFF), C_HEX(0x84E3FD)]];
    
    NSArray * sources = @[@58, @8, @13];
    NSArray * dataAry = @[@45, @22, @33];
    
    NSArray * maxAry = @[@60.5, @13.5, @26];
    NSArray * outTitle = @[@"业绩", @"估值", @"市场"];
    NSArray * outSub = @[@"市场业绩财报很好", @"估值有极强吸引力", @"市场情绪中性"];
    NSArray * outColor = @[C_HEX(0xF04D00), C_HEX(0xFBD439), C_HEX(0x23AADA)];
    
    PieData * pie = [[PieData alloc] init];
    pie.radiusRange = GGRadiusRangeMake(GG_SIZE_CONVERT(34), GG_SIZE_CONVERT(34 + 59));
    pie.showOutLableType = OutSideShow;
    pie.roseType = RoseRadius;
    pie.dataAry = dataAry;
    pie.outSideLable.stringRatio = GGRatioCenterLeft;
    pie.outSideLable.stringOffSet = CGSizeMake(-3, -2);
    pie.outSideLable.lineLength = GG_SIZE_CONVERT(10);
    pie.outSideLable.inflectionLength = GG_SIZE_CONVERT(90);
    pie.outSideLable.linePointRadius = 1.5;
    //pie.innerLable.stringOffSet = CGSizeMake(-.5, 0);
    pie.showInnerString = YES;
    
    _pie = pie;
    
    [pie setGradientColorsForIndex:^NSArray<UIColor *> *(NSInteger index) {
        
        return gradAryColors[index];
    }];
    
    [pie.outSideLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat value, CGFloat ratio) {
        
        NSNumber * weight = dataAry[index];
        NSNumber * source = maxAry[index];
        NSString * string = [NSString stringWithFormat:@"（满分%.1f）", source.floatValue / weight.floatValue * value];
        
        return [NSAttributedString pieChartWeightAttributeStringWith:outTitle[index]
                                                           nameColor:outColor[index]
                                                               title:outSub[index]
                                                          fractional:string];
    }];
    
    [pie.outSideLable setLineColorsBlock:^UIColor *(NSInteger index, CGFloat ratio) {
        
        return pieColors[index];
    }];
    
    [pie.innerLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat value, CGFloat ratio) {
        
        NSNumber * weight = dataAry[index];
        NSNumber * source = sources[index];
        NSString * string = [NSString stringWithFormat:@"%.f", source.floatValue / weight.floatValue * value];
        
        return [NSAttributedString pieInnerStringWithLargeString:string smallString:@"分"];
    }];
    
    PieDataSet * pieDataSet = [[PieDataSet alloc] init];
    pieDataSet.pieAry = @[pie];
    pieDataSet.showCenterLable = YES;
    
    [pieDataSet.centerLable.lable setAttrbuteStringValueBlock:^NSAttributedString *(CGFloat value) {
        
        return [NSAttributedString pieInnerStringWithCenterString:@"79" smallString:@"分值"];
    }];
    
    _pieChart = [[PieChart alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 500)];
    _pieChart.pieDataSet = pieDataSet;
    [_pieChart drawPieChart];
    [_pieChart startAnimationsWithType:RotationAnimation duration:.5f];
    
    [self.view addSubview:_pieChart];
    
    //
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(10, 450, 100, 50)];
    [btn setTitle:@"显示外线" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataFirst) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setFrame:CGRectMake(120, 450, 130, 50)];
    [btn setTitle:@"点击显示外线" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(analogDataSecond) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)analogDataFirst
{
    _pie.showOutLableType = OutSideShow;
    
    [_pieChart drawPieChart];
    [_pieChart startAnimationsWithType:EjectAnimation duration:.5f];
}

- (void)analogDataSecond
{
    _pie.showOutLableType = OutSideSelect;
    
    [_pieChart drawPieChart];
    [_pieChart startAnimationsWithType:RotationAnimation duration:.5f];
}

@end
