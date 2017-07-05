//
//  KTimeViewController.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KTimeViewController.h"
#import "BaseModel.h"
#import "MinuteChart.h"

@interface TimeModel : BaseModel <MinuteAbstract, VolumeAbstract>

@property (nonatomic , assign) NSInteger volume;
@property (nonatomic , assign) CGFloat price_change;
@property (nonatomic , assign) CGFloat price;
@property (nonatomic , assign) CGFloat price_change_rate;
@property (nonatomic , assign) CGFloat turnover;
@property (nonatomic , copy) NSString * date;
@property (nonatomic , assign) NSInteger total_volume;
@property (nonatomic , assign) CGFloat avg_price;

@end

@implementation TimeModel

- (CGFloat)ggTimeAveragePrice
{
    return _avg_price;
}

- (CGFloat)ggTimePrice
{
    return _price;
}

- (CGFloat)ggVolume
{
    return _volume;
}

@end

@interface KTimeViewController ()

@property (nonatomic, strong) MinuteChart * timeChart;

@end

@implementation KTimeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockDataJsonPath]];
    NSArray * stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    
    _timeChart = [[MinuteChart alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    _timeChart.objTimeAry = (NSArray <MinuteAbstract, VolumeAbstract> *)[BaseModel arrayForArray:stockJson class:[TimeModel class]];
    
    [self.view addSubview:_timeChart];
    [_timeChart drawChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"time_chart_data" ofType:@"json"];
}

@end
