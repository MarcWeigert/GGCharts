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

@implementation KLineData

- (NSDate *)ggKLineDate
{
    return _ggDate;
}

- (CGFloat)ggOpen
{
    return _open_price;
}

- (CGFloat)ggClose
{
    return _close_price;
}

- (CGFloat)ggHigh
{
    return _high_price;
}

- (CGFloat)ggLow
{
    return _low_price;
}

- (CGFloat)ggVolume
{
    return _volume / 1000000;
}

- (NSDate *)ggVolumeDate
{
    return _ggDate;
}

/**
 * 查询Value颜色
 *
 * @{@"key" : [UIColor redColor]}
 */
- (NSDictionary *)queryKeyForColor
{
    return @{@"开盘" : [UIColor blackColor],
             @"收盘" : [UIColor blackColor],
             @"最高" : [UIColor blackColor],
             @"最低" : [UIColor blackColor],
             @"成交量" : [UIColor blackColor]};
}

/**
 * 查询Key颜色
 *
 * @{@"key" : [UIColor redColor]}
 */
- (NSDictionary *)queryValueForColor
{
    return @{[NSString stringWithFormat:@"%.2f", _open_price] : [UIColor blackColor],
             [NSString stringWithFormat:@"%.2f", _close_price] : [UIColor blackColor],
             [NSString stringWithFormat:@"%.2f", _high_price] : [UIColor blackColor],
             [NSString stringWithFormat:@"%.2f", _low_price] : [UIColor blackColor],
             [NSString stringWithFormat:@"%zd万手", _volume / 1000000] : [UIColor blackColor]};
}

/**
 * 键值对
 *
 * @[@{@"key" : @"value"},
 *   @{@"key" : @"value"},
 *   @{@"key" : @"value"}]
 */
- (NSArray <NSDictionary *> *)valueForKeyArray
{
    return @[@{@"开盘" : [NSString stringWithFormat:@"%.2f", _open_price]},
             @{@"收盘" : [NSString stringWithFormat:@"%.2f", _close_price]},
             @{@"最高" : [NSString stringWithFormat:@"%.2f", _high_price]},
             @{@"最低" : [NSString stringWithFormat:@"%.2f", _low_price]},
             @{@"成交量" : [NSString stringWithFormat:@"%zd万手", _volume / 1000000]}];
}

@end

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
