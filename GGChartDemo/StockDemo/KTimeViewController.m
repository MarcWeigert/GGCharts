//
//  KTimeViewController.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KTimeViewController.h"
#import "BaseModel.h"
#import "MinuteChart.h"
#import "QueryViewAbstract.h"
#import "NSDate+GGDate.h"
#import "HorizontalKLineViewController.h"

@implementation TimeModel

- (CGFloat)ggTimeAveragePrice
{
    return _avg_price;
}

- (CGFloat)ggTimePrice
{
    return _price;
}

- (CGFloat)ggTimeClosePrice
{
    return _price / (1 + _price_change_rate / 100);
}

- (NSDate *)ggTimeDate
{
    return _ggDate;
}

- (CGFloat)ggVolume
{
    return _volume;
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
    return @{@"价格" : [UIColor blackColor],
             @"均价" : [UIColor blackColor],
             @"成交量" : [UIColor blackColor]};
}

/**
 * 查询Key颜色
 *
 * @{@"key" : [UIColor redColor]}
 */
- (NSDictionary *)queryValueForColor
{
    return @{[NSString stringWithFormat:@"%.2f", _price] : [UIColor blackColor],
             [NSString stringWithFormat:@"%.2f", _avg_price] : [UIColor blackColor],
             [NSString stringWithFormat:@"%zd手", _volume] : [UIColor blackColor]};
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
    return @[@{@"价格" : [NSString stringWithFormat:@"%.2f", _price]},
             @{@"均价" : [NSString stringWithFormat:@"%.2f", _avg_price]},
             @{@"成交量" : [NSString stringWithFormat:@"%zd手", _volume]}];
}

@end

@interface KTimeViewController ()

@property (nonatomic, strong) MinuteChart * timeChart;

@end

@implementation KTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"伊利股份(600887)";
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockFiveDataJsonPath]];
    NSArray * stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    
    NSArray <MinuteAbstract, VolumeAbstract> * timeAry = (NSArray <MinuteAbstract, VolumeAbstract> *) [BaseModel arrayForArray:stockJson class:[TimeModel class]];
    
    [timeAry enumerateObjectsUsingBlock:^(TimeModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.ggDate = [NSDate dateWithString:obj.date format:@"yyyy-MM-dd HH:mm:ss"];
    }];
    
    _timeChart = [[MinuteChart alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20, 250)];
    [_timeChart setMinuteTimeArray:timeAry timeChartType:TimeDay];
    
    [self.view addSubview:_timeChart];
    [_timeChart drawChart];
    
    UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithTitle:@"横屏" style:0 target:self action:@selector(present)];
    self.navigationItem.rightBarButtonItem = bar;
}

- (void)present
{
    [self presentViewController:[HorizontalKLineViewController new] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"time_chart_data" ofType:@"json"];
}

- (NSString *)stockFiveDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"600887_five_day" ofType:@"json"];
}

@end
