//
//  PieDemoIIViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieDemoIIViewController.h"
#import "PieChart.h"
#import "NSAttributedString+GGChart.h"

@interface PieDemoIIViewController ()

@end

@implementation PieDemoIIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray * pie_colors = @[__RGB_RED, __RGB_GREEN, __RGB_GRAY, __RGB_BLUE, __RGB_BLACK, __RGB_ORIGE, __RGB_CYAN, __RGB_PINK];
    NSArray * pie_colors2 = @[__RGB_RED, __RGB_ORIGE, __RGB_GRAY];
    
    CGFloat baseRadius = [UIScreen mainScreen].bounds.size.width / 2 - 110;
    
    PieData * pie = [[PieData alloc] init];
    pie.radiusRange = GGRadiusRangeMake(baseRadius, baseRadius * 1.3);
    pie.showOutLableType = OutSideShow;
    pie.dataAry = @[@335, @310, @234, @135, @1048, @251, @147, @102];
    pie.showOutLableType = OutSideShow;
    pie.outSideLable.lineLength = 20;
    pie.outSideLable.inflectionLength = 10;
    pie.outSideLable.stringFormat = @"%.0f万元";
    pie.outSideLable.lableFont = [UIFont systemFontOfSize:12];
    
    [pie setPieColorsForIndex:^UIColor *(NSInteger index, CGFloat value) {
        
        return pie_colors[index];
    }];
    
    [pie.outSideLable setLineColorsBlock:^UIColor *(NSInteger index, CGFloat value) {
        
        return pie_colors[index];
    }];
    
    PieData * pie2 = [[PieData alloc] init];
    pie2.radiusRange = GGRadiusRangeMake(0, baseRadius * .75);
    pie2.dataAry = @[@335, @679, @1548];
    pie2.showInnerString = YES;
    
    [pie2 setPieColorsForIndex:^UIColor *(NSInteger index, CGFloat value) {
        
        return pie_colors2[index];
    }];
    
    [pie2.innerLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat value, CGFloat ratio) {
        
        NSString * string = @[@"广发", @"中金", @"中信"][index];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr setText:string color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
        return attr;
    }];
    
    PieDataSet * pieDataSet = [[PieDataSet alloc] init];
    pieDataSet.pieAry = @[pie, pie2];
    pieDataSet.pieAnimationType = EjectAnimation;
    
    PieChart * pieChart = [[PieChart alloc] initWithFrame:self.view.frame];
    pieChart.pieDataSet = pieDataSet;
    [pieChart drawPieChart];
    [self.view addSubview:pieChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
