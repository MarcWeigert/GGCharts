//
//  ProgressViewController.m
//  GGCharts
//
//  Created by _ | Durex on 17/10/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "ProgressViewController.h"
#import "ProgressChart.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 背景色
    [self.navigationController.navigationBar setBarTintColor:C_HEX(0x151515)];
    
    // 导航栏字体
    NSDictionary * dictionaryNavi = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dictionaryNavi];

    self.title = @"进度图";
    self.view.backgroundColor = C_HEX(0x242424);

//    CGFloat height = [UIScreen mainScreen].bounds.size.height - 64;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    ProgressData * progress1 = [[ProgressData alloc] init];
    progress1.maxValue = 13;
    progress1.value = 8.5;
    progress1.progressRadius = 88.5;
    progress1.centerLable.stringFormat = @"%.1f";
    progress1.centerLable.lableFont = [UIFont fontWithName:@"Helvetica-Light" size:80];
    progress1.centerLable.lableColor = C_HEX(0xCCCCCC);
    
    ProgressChart * chart1 = [[ProgressChart alloc] initWithFrame:CGRectZero];
    chart1.gg_top = 130;
    chart1.gg_size = CGSizeMake(195, 195);
    chart1.gg_centerX = width / 2;
    chart1.progressData = progress1;
    [chart1 drawProgressChart];
    [self.view addSubview:chart1];

    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 79, 18)];
    lable.layer.cornerRadius = 9;
    lable.backgroundColor = C_HEX(0x2B2B2B);
    lable.textColor = C_HEX(0x888888);
    lable.text = @"信任度";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.layer.masksToBounds = YES;
    lable.font = [UIFont systemFontOfSize:11];
    lable.gg_centerX = width / 2;
    lable.gg_top = chart1.gg_top + 160.5f;
    [self.view addSubview:lable];
    
    [chart1 startAnimationWithDuration:.5f];
}

@end
