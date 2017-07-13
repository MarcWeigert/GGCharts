//
//  HorizontalKLineViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "HorizontalKLineViewController.h"
#import "KLineViewController.h"
#import "NSDate+GGDate.h"

@interface HorizontalKLineViewController ()

@end

@implementation HorizontalKLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = RGB(31, 33, 45);
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockDataJsonPath]];
    NSArray *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    NSArray <KLineData *> *datas = [[[KLineData arrayForArray:stockJson class:[KLineData class]] reverseObjectEnumerator] allObjects];
    
    self.title = @"伊利股份(600887)";
    
    [datas enumerateObjectsUsingBlock:^(KLineData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.ggDate = [NSDate dateWithString:obj.date format:@"yyyy-MM-dd HH:mm:ss"];
    }];
    
    KLineChart * kChart = [[KLineChart alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.height - 40, self.view.frame.size.width - 40)];
    [kChart setKLineArray:datas type:KLineTypeDay];
    kChart.kLineProportion = .7f;
    [kChart updateChart];
    
    [self.view addSubview:kChart];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"600887_kdata" ofType:@"json"];
}

- (NSString *)stockWeekDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"week_k_data_60087" ofType:@"json"];
}

- (NSString *)stockMonthDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"month_k_data_600887" ofType:@"json"];
}

@end
