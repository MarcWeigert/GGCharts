//
//  KLineViewController.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KLineViewController.h"
#import "NSDate+GGDate.h"
#import "HorizontalKLineViewController.h"

@interface KLineViewController ()

@end

@implementation KLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockWeekDataJsonPath]];
    NSArray *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    
    NSArray <KLineData *> *datas = [[[KLineData arrayForArray:stockJson class:[KLineData class]] reverseObjectEnumerator] allObjects];
    
    self.title = @"伊利股份(600887)";

    [datas enumerateObjectsUsingBlock:^(KLineData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.ggDate = [NSDate dateWithString:obj.date format:@"yyyy-MM-dd HH:mm:ss"];
    }];
    
    KLineChart * kChart = [[KLineChart alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 300)];
    [kChart setKLineArray:datas type:KLineTypeWeek];
    [kChart updateChart];
    
    [self.view addSubview:kChart];
    
    UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithTitle:@"横屏" style:0 target:self action:@selector(present)];
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)present
{
    [self presentViewController:[HorizontalKLineViewController new] animated:YES completion:nil];
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
