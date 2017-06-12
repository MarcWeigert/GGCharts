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

@interface MDLineViewController () <MDLineChartDelegate>

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
    lineChart.frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 250);
    lineChart.dataSet = aryLineData;
    [lineChart strockChart];
    lineChart.delegate = self;
    [self.view addSubview:lineChart];
    
    [lineChart addAnimation:3];
}

- (NSString *)titleDataString:(NSString *)string
{
    if ([string isEqualToString:@"--"]) {
        
        return @"--";
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [formatter dateFromString:string];
    
    NSDateFormatter * showFormatter = [[NSDateFormatter alloc] init];
    showFormatter.dateFormat = @"yy/MM/dd";
    
    return [showFormatter stringFromDate:date];
}

- (void)moveToKeyNodeData:(MassChartData *)chartData queryView:(StockQueryView *)queryView
{
    NSMutableArray * aryData = [NSMutableArray array];
    
    QueryData * q_data0 = [QueryData new];
    q_data0.keyColor = [UIColor blackColor];
    q_data0.valueColor = [UIColor blackColor];
    q_data0.key = @"时间";
    q_data0.value = chartData.title;
    [aryData addObject:q_data0];
    
    QueryData * q_data1 = [QueryData new];
    q_data1.keyColor = [UIColor blackColor];
    q_data1.valueColor = [UIColor blackColor];
    q_data1.key = @"收盘";
    q_data1.value = [NSString stringWithFormat:@"%.2f", chartData.value];
    [aryData addObject:q_data1];
    
    if ([chartData.attribute isKindOfClass:[NSNull class]]) {
        
        chartData.attribute = @{@"ex-dividend_date" : @"--",
                                @"dividend_payout_ratio" : @"--",
                                @"dividend_radio" : @"--",
                                @"dividend_date" : @"--",
                                @"stock_record_date" : @"--"};
    }
    
    [chartData.attribute enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        
        QueryData * q_data = [QueryData new];
        q_data.keyColor = [UIColor blackColor];
        q_data.valueColor = [UIColor blackColor];
        [aryData addObject:q_data];
        
        if ([key isEqualToString:@"ex-dividend_date"]) {
            
            q_data.key = @"股票除权日期";
            q_data.value = obj;
            
            if ([obj isKindOfClass:[NSNull class]]) {
                
                q_data.value = @"--";
            }
            else {
            
                q_data.value = [self titleDataString:(NSString *)obj];
            }
        }
        else if ([key isEqualToString:@"dividend_payout_ratio"]) {
            
            q_data.key = @"股利支付率";
            q_data.value = obj;
            
            if ([obj isKindOfClass:[NSNull class]]) {
                
                q_data.value = @"--";
            }
        }
        else if ([key isEqualToString:@"dividend_radio"]) {
            
            q_data.key = @"分红率";
            q_data.value = obj;
            
            if ([obj isKindOfClass:[NSNull class]]) {
                
                q_data.value = @"--";
            }
        }
        else if ([key isEqualToString:@"dividend_date"]) {
            
            q_data.key = @"派息日";
            q_data.value = obj;
            
            if ([obj isKindOfClass:[NSNull class]]) {
                
                q_data.value = @"--";
            }
            else {
                
                q_data.value = [self titleDataString:(NSString *)obj];
            }
            
        }
        else if ([key isEqualToString:@"stock_record_date"]) {
            
            q_data.key = @"股票登记日期";
            q_data.value = obj;
            
            if ([obj isKindOfClass:[NSNull class]]) {
                
                q_data.value = @"--";
            }
            else {
                
                q_data.value = [self titleDataString:(NSString *)obj];
            }
        }
    }];
    
    queryView.aryData = aryData;
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"stock_data" ofType:@"json"];
}

@end
