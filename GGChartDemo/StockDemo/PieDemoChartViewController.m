//
//  PieDemoChartViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieDemoChartViewController.h"
#import "GGPieChart.h"
#import "Colors.h"
#import "NSAttributedString+GGChart.h"

@interface PieDemoChartViewController ()

@property (nonatomic, strong) GGPieChart * pieChart;

@end

@implementation PieDemoChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"扇形图";
    
    NSArray * pieColors = @[C_HEX(0xF04D00), C_HEX(0xFBD439), C_HEX(0x23AADA)];
    NSArray * gradAryColors = @[@[C_HEX(0xFFB04F), C_HEX(0xF96B46)], @[C_HEX(0xFFE70E), C_HEX(0xFFF283)], @[C_HEX(0x0ECFFF), C_HEX(0x84E3FD)]];
    NSArray * attrbuteString = @[[NSAttributedString pieChartWeightAttributeStringWith:@"业绩" nameColor:C_HEX(0xF04D00) title:@"市场业绩财报很好" fractional:@"（满分60.5）"],
                                 [NSAttributedString pieChartWeightAttributeStringWith:@"估值" nameColor:C_HEX(0xFBD439) title:@"估值有极强吸引力" fractional:@"（满分13.5）"],
                                 [NSAttributedString pieChartWeightAttributeStringWith:@"市场" nameColor:C_HEX(0x23AADA) title:@"市场情绪中性" fractional:@"（满分26）"]];
    
    GGPieData * pie = [[GGPieData alloc] init];
    pie.radiusRange = GGRadiusRangeMake(34, 34 + 59);
    pie.showOutLableType = OutSideShow;
    pie.roseType = RoseRadius;
    pie.dataAry = @[@45, @22, @33];
    pie.outSideLable.stringRatio = CGPointMake(-1, -.5f);
    pie.outSideLable.stringOffSet = CGSizeMake(-3, -2);
    pie.outSideLable.lineLength = 10;
    pie.outSideLable.inflectionLength = 90;
    pie.outSideLable.linePointRadius = 1.5;
    pie.innerLable.stringOffSet = CGSizeMake(-.5, 0);
    pie.showInnerString = YES;
    
    [pie setGradientColorsForIndex:^NSArray<UIColor *> *(NSInteger index) {
        
        return gradAryColors[index];
    }];
    
    [pie.outSideLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat ratio) {
        
        return attrbuteString[index];
    }];
    
    [pie.outSideLable setLineColorsBlock:^UIColor *(NSInteger index, CGFloat ratio) {
        
        return pieColors[index];
    }];
    
    [pie.innerLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat ratio) {
        
        return [NSAttributedString pieInnerStringWithLargeString:@[@"58", @"8", @"13"][index] smallString:@"分"];
    }];
    
    PieDataSet * pieDataSet = [[PieDataSet alloc] init];
    pieDataSet.pieAry = @[pie];
    
    [pieDataSet.centerLable.lable setAttrbuteStringValueBlock:^NSAttributedString *(CGFloat value) {
        
        return [NSAttributedString pieInnerStringWithCenterString:@"79" smallString:@"分值"];
    }];
    
    _pieChart = [[GGPieChart alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 500)];
    _pieChart.pieDataSet = pieDataSet;
    [_pieChart drawPieChart];
    
    [self.view addSubview:_pieChart];
}

@end
