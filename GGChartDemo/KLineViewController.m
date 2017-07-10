//
//  KLineViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KLineViewController.h"
#import "BaseModel.h"
#import "KLineChart.h"
#import "QueryViewAbstract.h"

#import "KLineIndexManager.h"

#import "BaseIndexLayer.h"

@interface KLineData : BaseModel <KLineAbstract, VolumeAbstract, QueryViewAbstract>

@property (nonatomic , assign) CGFloat high_price;
@property (nonatomic , assign) CGFloat turnover;
@property (nonatomic , assign) CGFloat turnover_rate;
@property (nonatomic , assign) NSInteger volume;
@property (nonatomic , assign) CGFloat price_change;
@property (nonatomic , assign) CGFloat close_price;
@property (nonatomic , assign) CGFloat low_price;
@property (nonatomic , assign) CGFloat open_price;
@property (nonatomic , copy) NSString * date;
@property (nonatomic , assign) CGFloat amplitude;
@property (nonatomic , assign) CGFloat price_change_rate;

@property (nonatomic , assign) BOOL showTitle;
@property (nonatomic , copy) NSString * title;
@property (nonatomic , strong) NSDate * ggDate;

@end

@implementation KLineData

- (NSDate *)ggKLineDate
{
    return _ggDate;
}

- (BOOL)isShowTitle
{
    return _showTitle;
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

- (NSString *)ggKLineTitle
{
    return _title;
}

- (CGFloat)ggVolume
{
    return _volume / 1000000;
}

- (NSString *)ggVolumeTitle
{
    return _date;
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
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockDataJsonPath]];
    NSArray *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    
    NSArray <KLineData *> *datas = [[[KLineData arrayForArray:stockJson class:[KLineData class]] reverseObjectEnumerator] allObjects];
    
    self.title = @"伊利股份(600887)";
    
    __block NSInteger month = 0;
    
    [datas enumerateObjectsUsingBlock:^(KLineData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.title = [self getMonth:obj.date];
        obj.ggDate = [self getDateString:obj.date];
        
        if (month != obj.title.integerValue) {
            
            obj.showTitle = YES;
            month = obj.title.integerValue;
        }
        
        if (obj.title.integerValue == 1) {
            
            obj.title = [self getYearMonth:obj.date];
        }
    }];
    
    KLineChart * kChart = [[KLineChart alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 300)];
    kChart.kLineArray = datas;
    [kChart updateChart];
    
    [self.view addSubview:kChart];
}

- (NSString *)getMonth:(NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [formatter dateFromString:dateString];
    
    NSDateFormatter * showFormatter = [[NSDateFormatter alloc] init];
    showFormatter.dateFormat = @"MM";
    
    return [showFormatter stringFromDate:date];
}

- (NSDate *)getDateString:(NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:dateString];
}

- (NSString *)getYearMonth:(NSString *)dateString
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [formatter dateFromString:dateString];
    
    NSDateFormatter * showFormatter = [[NSDateFormatter alloc] init];
    showFormatter.dateFormat = @"yyyy/MM";
    
    return [showFormatter stringFromDate:date];
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"600887_kdata" ofType:@"json"];
}


@end
