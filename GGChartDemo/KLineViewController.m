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

@interface KLineData : BaseModel <KLineAbstract, VolumeAbstract>

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

@end

@implementation KLineData

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
    return _date;
}

- (CGFloat)ggVolume
{
    return _volume;
}

- (NSString *)ggVolumeTitle
{
    return _date;
}

@end

@interface KLineViewController ()

@end

@implementation KLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockDataJsonPath]];
    NSArray *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    
    NSArray <KLineData *> *datas = [KLineData arrayForArray:stockJson class:[KLineData class]];
    
    KLineChart * kChart = [[KLineChart alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 350)];
    kChart.kLineArray = [[datas reverseObjectEnumerator] allObjects];
    [kChart updateChart];
    
    [self.view addSubview:kChart];
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"600887_kdata" ofType:@"json"];
}


@end
