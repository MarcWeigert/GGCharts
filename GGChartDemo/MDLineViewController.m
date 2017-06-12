//
//  MDLineViewController.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MDLineViewController.h"
#import "MassChartData.h"
#import "MDLineChart.h"

@interface MDLineViewController ()

@end

@implementation MDLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"MDLineChart";
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockDataJsonPath]];
    NSDictionary *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    NSArray *beforeAry = stockJson[@"beforeData"];
    
    NSMutableArray * aryLineData = [NSMutableArray array];
    
    for (NSDictionary * dictionary in beforeAry) {
        
        MassChartData * chartData = [MassChartData new];
        chartData.title = [self titleDataString:dictionary[@"date"]];
        chartData.value = [dictionary[@"close_price"] floatValue];
        chartData.attribute = dictionary[@"dividend"];
        [aryLineData addObject:chartData];
        
        if (![chartData.attribute isKindOfClass:[NSNull class]]) {
            
            chartData.isKeyNote = YES;
        }
    }
    
    MDLineChart * lineChart = [[MDLineChart alloc] initWithFrame:CGRectZero];
    lineChart.frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 200);
    lineChart.dataSet = aryLineData;
    [lineChart strockChart];
    [self.view addSubview:lineChart];
}

- (NSString *)titleDataString:(NSString *)string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [formatter dateFromString:string];
    
    NSDateFormatter * showFormatter = [[NSDateFormatter alloc] init];
    showFormatter.dateFormat = @"yy/MM/dd";
    
    return [showFormatter stringFromDate:date];
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"stock_data" ofType:@"json"];
}

@end
