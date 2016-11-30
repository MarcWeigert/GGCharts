//
//  ListVC.m
//  HCharts
//
//  Created by 黄舜 on 16/5/10.
//  Copyright © 2016年 黄舜. All rights reserved.
//

#import "ListVC.h"
#import "CumSumBarView.h"
#import "CumSumLineView.h"
#import "RankBarView.h"
#import "Colors.h"
#import "CrossLineView.h"
#import "HollowFanView.h"
#import "PieView.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation ListVC

#pragma mark - 各个视图

- (NSDictionary *)pushDictionary
{
    return @{@"空心饼图" : @"hollowFanView",
             @"阴影饼图" : @"pieView",
             @"多数据叠加柱状图" : @"cumSumBarView",
             @"多数据排列柱状图" : @"rankBarView",
             @"大数据折线图" : @"crossLineView",
             @"堆叠区域图" : @"cumSumLineView",};
}

- (UIView *)pieView
{
    PieView *pieView = [[PieView alloc] initWithFrame:CGRectZero];
    pieView.frame = CGRectMake(0, 0, 370, 370);
    pieView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    pieView.dataAry = @[@335, @310, @234, @135, @1548];
    pieView.titleAry = @[@"直接访问", @"邮件营销", @"联盟广告", @"视频广告", @"搜索引擎"];
    pieView.colorAry = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
    
    [pieView stockChart];
    //[pieView addAnimation];
    
    return pieView;
}

- (UIView *)cumSumLineView
{
    CumSumLineView *layView = [[CumSumLineView alloc] initWithFrame:CGRectZero];
    layView.frame =  CGRectMake(10, 100, self.view.frame.size.width - 10, 400);
    layView.colorAry = @[__RGB_RED, __RGB_GREEN, __RGB_BLUE, __RGB_ORIGE, __RGB_CYAN];
    layView.dataArys = @[@[@320, @202, @301, @334, @390, @330, @320],
                         @[@120, @132, @101, @134, @90, @230, @210],
                         @[@220, @182, @191, @234, @290, @330, @310],
                         @[@150, @212, @201, @154, @190, @330, @410],
                         @[@820, @832, @901, @934, @1290, @1330, @1320]];
    layView.titleAry = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    [layView stockChart];
    [layView addAnimation];
    
    return layView;
}

- (UIView *)cumSumBarView
{
    CumSumBarView *layView = [[CumSumBarView alloc] initWithFrame:CGRectZero];
    layView.frame =  CGRectMake(10, 100, self.view.frame.size.width - 10, 400);
    layView.colorAry = @[__RGB_RED, __RGB_GREEN, __RGB_BLUE, __RGB_ORIGE, __RGB_CYAN];
    layView.dataArys = @[@[@320, @202, @301, @334, @390, @330, @320],
                         @[@120, @132, @101, @134, @90, @230, @210],
                         @[@220, @182, @191, @234, @290, @330, @310],
                         @[@150, @212, @201, @154, @190, @330, @410],
                         @[@820, @832, @901, @934, @1290, @1330, @1320]];
    layView.titleAry = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    [layView stockChart];
    [layView addAnimation];
    
    return layView;
}

- (UIView *)rankBarView
{
    RankBarView *rankBar = [[RankBarView alloc] initWithFrame:CGRectZero];
    rankBar.frame =  CGRectMake(0, 100, self.view.frame.size.width, 400);
    rankBar.colorAry = @[__RGB_RED, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
    rankBar.titleAry = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    rankBar.dataArys = @[@[@(FLT_MIN), @(FLT_MIN), @7.0, @23.2, @25.6, @76.7, @135.6, @162.2, @32.6, @20.0, @6.4, @3.3],
                         @[@2.6, @5.9, @9.0, @26.4, @28.7, @70.7, @175.6, @182.2, @48.7, @18.8, @6.0, @2.3]];
    
    [rankBar stockChart];
    [rankBar addAnimation:3];
    
    return rankBar;
}

- (UIView *)crossLineView
{
    // 降雨量数据
    NSData *dataTop = [NSData dataWithContentsOfFile:[self LineDataTopPath]];
    NSArray *topAry = [NSJSONSerialization JSONObjectWithData:dataTop options:0 error:nil];
    
    // 流量数据
    NSData *dataBottom = [NSData dataWithContentsOfFile:[self LineDataBottomPath]];
    NSArray *bottomAry = [NSJSONSerialization JSONObjectWithData:dataBottom options:0 error:nil];
    
    CrossLineView *viewLine = [[CrossLineView alloc] init];
    viewLine.frame = CGRectMake(0, 100, self.view.frame.size.width, 400);
    viewLine.topAry = topAry;
    viewLine.bottomAry = bottomAry;
    viewLine.topLineColor = __RGB_RED;
    viewLine.bottomLineColor = __RGB_GREEN;
    viewLine.topFillColor = [__RGB_RED colorWithAlphaComponent:0.3];
    viewLine.bottomFillColor = [__RGB_GREEN colorWithAlphaComponent:0.3];
    viewLine.titleAry = @[@"2003", @"2004", @"2005", @"2006", @"2007", @"2008", @"2009", @"2010", @"2011", @"2012", @"2013"];
    
    [viewLine stockChart];
    [viewLine addAnimation];
    
    return viewLine;
}

- (UIView *)hollowFanView
{
    HollowFanView *fanView = [[HollowFanView alloc] initWithFrame:CGRectZero];
    fanView.frame = CGRectMake(0, 0, 300, 300);
    fanView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    fanView.dataAry = @[@335, @310, @234, @135, @1548];
    fanView.titleAry = @[@"直接访问", @"邮件营销", @"联盟广告", @"视频广告", @"搜索引擎"];
    fanView.colorAry = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
    
    [fanView stockChart];
    [fanView addAnimation];
    
    return fanView;
}

#pragma mark - 数据路径

- (NSString *)LineDataTopPath
{
    return [[NSBundle mainBundle] pathForResource:@"CrossLineTopData" ofType:@"txt"];
}

- (NSString *)LineDataBottomPath
{
    return [[NSBundle mainBundle] pathForResource:@"CrossLineBottomData" ofType:@"txt"];
}

#pragma mark - 初始化

- (void)viewDidLoad
{
    self.title = @"Charts";
    
    self.table = [[UITableView alloc] initWithFrame:self.view.frame];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorColor = [UIColor whiteColor];
    
    [self.view addSubview:_table];
}

- (NSArray *)sectionAry
{
    return @[@"饼图", @"柱状图", @"折线图"];
}

- (NSArray *)rowAry
{
    return @[@[@"空心饼图", @"阴影饼图"],  @[@"多数据叠加柱状图", @"多数据排列柱状图"], @[@"大数据折线图", @"堆叠区域图"]];
}

#pragma mark - tableView Delegate && DataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:20];
    lable.text = [NSString stringWithFormat:@"    %@", self.sectionAry[section]];
    lable.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    
    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowAry[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [self.rowAry[indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectStr = [self.rowAry[indexPath.section] objectAtIndex:indexPath.row];
    NSString *selectorStr = [[self pushDictionary] objectForKey:selectStr];
    SEL selector = NSSelectorFromString(selectorStr);
    
    UIView *chartView;
    
    SuppressPerformSelectorLeakWarning (
    
        chartView = [self performSelector:selector];
    );
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = selectStr;
    [vc.view addSubview:chartView];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
