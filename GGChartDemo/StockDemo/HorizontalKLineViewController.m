//
//  HorizontalKLineViewController.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "HorizontalKLineViewController.h"
#import "KLineViewController.h"
#import "KTimeViewController.h"
#import "NSDate+GGDate.h"
#import "TableIndexCell.h"
#import "SlideTabView.h"
#import "MinuteChart.h"

#define GG_SCREEN_W     [UIScreen mainScreen].bounds.size.width
#define GG_SCREEN_H     [UIScreen mainScreen].bounds.size.height

#define Menu_Top    70
#define Menu_W      40
#define Menu_Left_Padding   10
#define Menu_Bottom_Padding 10

#define Index_Inner     UIEdgeInsetsMake(0, 5, 0, 5)
#define Index_Hidden_Inner      UIEdgeInsetsMake(0, Menu_W, 0, Menu_W)

static NSString * indexCellIdentifier = @"TableIndexCell";

@interface HorizontalKLineViewController () <UITableViewDelegate, UITableViewDataSource, SwitchTabViewDelegate>

@property (nonatomic, strong) NSArray * menuDatas;

@property (nonatomic, strong) UILabel * topLable;
@property (nonatomic, strong) SlideTabView * bottomBar;

@property (nonatomic, strong) KLineChart * kChart;
@property (nonatomic, strong) UITableView * indexTableView;
@property (nonatomic, strong) NSArray * kLineArray;

@property (nonatomic, strong) MinuteChart * kTimeChart;
@property (nonatomic, strong) NSArray * timeDataAry;

@property (nonatomic, strong) MinuteChart * kFiveTimeChart;
@property (nonatomic, strong) NSArray * timeFiveDataAry;

@end

@implementation HorizontalKLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = RGB(255, 255, 255);
    
    // k线
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockDataJsonPath]];
    NSArray *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    _kLineArray = [[[KLineData arrayForArray:stockJson class:[KLineData class]] reverseObjectEnumerator] allObjects];
    
    [_kLineArray enumerateObjectsUsingBlock:^(KLineData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.ggDate = [NSDate dateWithString:obj.date format:@"yyyy-MM-dd HH:mm:ss"];
    }];
    
    // 日
    NSData *dataTimeStock = [NSData dataWithContentsOfFile:[self stockTimeDataJsonPath]];
    NSArray * stockTimeJson = [NSJSONSerialization JSONObjectWithData:dataTimeStock options:0 error:nil];
    _timeDataAry = (NSArray <MinuteAbstract, VolumeAbstract> *) [BaseModel arrayForArray:stockTimeJson class:[TimeModel class]];
    
    [_timeDataAry enumerateObjectsUsingBlock:^(TimeModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.ggDate = [NSDate dateWithString:obj.date format:@"yyyy-MM-dd HH:mm:ss"];
    }];
    
    
    // 五日
    NSData *dataFiveTimeStock = [NSData dataWithContentsOfFile:[self stockFiveDataJsonPath]];
    NSArray * stockFiveTimeJson = [NSJSONSerialization JSONObjectWithData:dataFiveTimeStock options:0 error:nil];
    _timeFiveDataAry = (NSArray <MinuteAbstract, VolumeAbstract> *) [BaseModel arrayForArray:stockFiveTimeJson class:[TimeModel class]];
    
    [_timeFiveDataAry enumerateObjectsUsingBlock:^(TimeModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.ggDate = [NSDate dateWithString:obj.date format:@"yyyy-MM-dd HH:mm:ss"];
    }];
    
    [self makeSubViews];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(GG_SCREEN_H - 50, 0, 40, 40);
    [btn setTitle:@"×" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:30];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self tabBtnClicked:0];
}

- (void)makeSubViews
{
    CGRect topRect = CGRectMake(0, 0, GG_SCREEN_H, 40);
    CGRect botomRect = CGRectMake(0, GG_SCREEN_W - 35, GG_SCREEN_H, 35);
    CGFloat padding = 10;
    CGFloat indexWidth = 40;
    CGFloat kLineIndexTop = 12;
    CGRect indexRect = CGRectMake(GG_SCREEN_H - indexWidth - padding, indexWidth + kLineIndexTop, 40, GG_SCREEN_W - (indexWidth + kLineIndexTop) - 40);
    CGRect kLineRect = CGRectMake(padding, indexWidth, GG_SCREEN_H - padding * 3 - 40, indexRect.size.height + 11);
    CGRect timeChartRect = CGRectMake(padding, indexWidth, GG_SCREEN_H - padding * 2, indexRect.size.height + 11);
    
    _topLable = [[UILabel alloc] initWithFrame:topRect];
    _topLable.text = @"  伊利股份(600887)       13.76       -0.44%           时间 14:01";
    [self.view addSubview:_topLable];
    
    _bottomBar = [SlideTabView switchTabView:@[@"分时", @"五日", @"日K", @"周K", @"月K"]];
    _bottomBar.frame = botomRect;
    _bottomBar.delegate = self;
    [self.view addSubview:_bottomBar];
    
    _indexTableView = [[UITableView alloc] initWithFrame:indexRect style:UITableViewStylePlain];
    _indexTableView.delegate = self;
    _indexTableView.dataSource = self;
    _indexTableView.layer.borderColor = RGB(190, 190, 190).CGColor;
    _indexTableView.layer.borderWidth = .5f;
    _indexTableView.showsVerticalScrollIndicator = NO;
    _indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_indexTableView registerClass:[TableIndexCell class] forCellReuseIdentifier:indexCellIdentifier];
    [self.view addSubview:_indexTableView];
    
    _kChart = [[KLineChart alloc] initWithFrame:kLineRect];
    [_kChart setKLineArray:_kLineArray type:KLineTypeDay];
    _kChart.kLineCountVisibale = 90;
    _kChart.kMinCountVisibale = 40;
    _kChart.kMaxCountVisibale = 190;
    _kChart.kLineProportion = .7f;
    [_kChart updateChart];
    
    __weak UITableView * tbIndex = _indexTableView;
    [_kChart setIndexChangeBlock:^(NSString *indexName) {
        
        [tbIndex reloadData];
    }];
    
    __weak KLineChart * kChart = _kChart;
    __weak HorizontalKLineViewController * weakSelf = self;
    
    [_kChart setRefreshBlock:^{
        
        CGSize contetnSzie = kChart.scrollView.contentSize;
        NSRange range = NSMakeRange(0, weakSelf.kLineArray.count);
        
        NSMutableArray * aryKLineDatas = [NSMutableArray arrayWithArray:[kChart.kLineArray subarrayWithRange:range]];
        [aryKLineDatas addObjectsFromArray:kChart.kLineArray];
        
        [kChart setKLineArray:aryKLineDatas type:kChart.kStyle];
        [kChart updateChart];
        [kChart endLoadingState];
        
        kChart.scrollView.contentOffset = CGPointMake(weakSelf.kChart.scrollView.contentSize.width - contetnSzie.width, 0);
    }];
    
    [self.view addSubview:_kChart];
    
    UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.topLable.gg_height - .5f, self.topLable.gg_width, .5f)];
    topLine.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:topLine];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottomBar.gg_top, self.topLable.gg_width, .5f)];
    bottomLine.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:bottomLine];
    
    // 分时图
    _kTimeChart = [[MinuteChart alloc] initWithFrame:timeChartRect];
    [_kTimeChart setMinuteTimeArray:(NSArray <MinuteAbstract, VolumeAbstract> *)_timeDataAry timeChartType:TimeHalfAnHour];
    _kTimeChart.lineRatio = 0.7f;
    _kTimeChart.dirAxisSplitCount = 3;
    [_kTimeChart setTrading:YES];
    [self.view addSubview:_kTimeChart];
    [_kTimeChart drawChart];
    
    // 五日线
    _kFiveTimeChart = [[MinuteChart alloc] initWithFrame:timeChartRect];
    [_kFiveTimeChart setMinuteTimeArray:(NSArray <MinuteAbstract, VolumeAbstract> *)_timeFiveDataAry timeChartType:TimeDay];
    _kFiveTimeChart.lineRatio = 0.7f;
    _kFiveTimeChart.dirAxisSplitCount = 3;
    [_kFiveTimeChart setTrading:YES];
    [self.view addSubview:_kFiveTimeChart];
    [_kFiveTimeChart drawChart];
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

#pragma mark - SlideDelegate

- (void)tabBtnClicked:(NSInteger)btnTag
{
    // 刷新hidden
    self.kTimeChart.hidden = !(btnTag == 0);
    self.kFiveTimeChart.hidden = !(btnTag == 1);
    self.kChart.hidden = !(btnTag == 2 || btnTag == 3 || btnTag == 4);
    self.indexTableView.hidden = !(btnTag == 2 || btnTag == 3 || btnTag == 4);
    
    [self.kTimeChart setTrading:!self.kTimeChart.hidden];
    [self.kFiveTimeChart setTrading:!self.kFiveTimeChart.hidden];
    
    NSString * path = [self stockDataJsonPath];
    KLineStyle kStyle = KLineTypeDay;
    
    if (btnTag == 2) {
        
        path = [self stockDataJsonPath];
        kStyle = KLineTypeDay;
    }
    else if (btnTag == 3) {
    
        path = [self stockWeekDataJsonPath];
        kStyle = KLineTypeWeek;
    }
    else if (btnTag == 4) {
    
        path = [self stockMonthDataJsonPath];
        kStyle = KLineTypeMonth;
    }
    
    NSData *dataStock = [NSData dataWithContentsOfFile:path];
    NSArray *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    _kLineArray = [[[KLineData arrayForArray:stockJson class:[KLineData class]] reverseObjectEnumerator] allObjects];
    
    [_kLineArray enumerateObjectsUsingBlock:^(KLineData * obj, NSUInteger idx, BOOL * stop) {
        
        obj.ggDate = [NSDate dateWithString:obj.date format:@"yyyy-MM-dd HH:mm:ss"];
    }];
    
    [_kChart setKLineArray:_kLineArray type:kStyle];
    [_kChart updateChart];
}

#pragma mark - UITableView Delegate && Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuDatas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = self.menuDatas[indexPath.section][indexPath.row];
    BOOL isSelect = [_kChart.volumIndexIndexName isEqualToString:string] || [_kChart.kLineIndexIndexName isEqualToString:string];
    
    TableIndexCell * indexCell = [tableView dequeueReusableCellWithIdentifier:indexCellIdentifier forIndexPath:indexPath];
    indexCell.textLabel.text = self.menuDatas[indexPath.section][indexPath.row];
    indexCell.textLabel.textAlignment = NSTextAlignmentCenter;
    indexCell.textLabel.font = [UIFont systemFontOfSize:9];
    indexCell.textLabel.textColor = isSelect ? RGB(115, 190, 222) : [UIColor blackColor];
    [indexCell showLine:indexPath.row != [self.menuDatas[indexPath.section] count] - 1 || indexPath.section == self.menuDatas.count - 1];
    return indexCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return;
    }
    else {
    
        [_kChart setIndex:self.menuDatas[indexPath.section][indexPath.row]];
        [tableView reloadData];
    }
}

#pragma mark - Lazy

- (NSArray *)menuDatas
{
    if (_menuDatas == nil) {
        
        _menuDatas = @[@[@"前复权", @"后复权", @"不复权"],
                       @[@"MA", @"EMA", @"MIKE", @"BOLL", @"BBI", @"TD"],
                       @[@"MAVOL", @"MACD", @"KDJ", @"RSI", @"ATR"]];
    }
    
    return _menuDatas;
}

- (NSString *)stockTimeDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"time_chart_data" ofType:@"json"];
}

- (NSString *)stockFiveDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"600887_five_day" ofType:@"json"];
}

@end
