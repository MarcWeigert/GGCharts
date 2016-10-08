//
//  ListVC.m
//  HCharts
//
//  Created by 黄舜 on 16/5/10.
//  Copyright © 2016年 黄舜. All rights reserved.
//

#import "ListVC.h"
#import "ChartVC.h"
#import "CumSumBarView.h"
#import "CumSumLineView.h"
#import "RankBarView.h"
#import "Colors.h"
#import "CrossLineView.h"

#define LIST_TO(A) ChartVC *vc = [[ChartVC alloc] initWithChartView:A]; vc.title = string; [self.navigationController pushViewController:vc animated:NO];

@implementation ListVC

#pragma mark - 各个视图

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
    [rankBar addAnimation];
    
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
    return @[@[@"空心饼图", @"阴影饼图"],  @[@"多数据叠加柱状图", @"多数据排列柱状图"], @[@"大数据折线图", @"数据叠加折线图"]];
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
    NSString *string = [self.rowAry[indexPath.section] objectAtIndex:indexPath.row];
    
    if ([string isEqualToString:@"空心饼图"]) {
        
        //LIST_TO([self pieHollowView]);
    }
    else if ([string isEqualToString:@"阴影饼图"]) {
    
        //LIST_TO([self pieCubeView]);
    }
    else if ([string isEqualToString:@"多数据叠加柱状图"]) {
        
        LIST_TO([self cumSumBarView]);
    }
    else if ([string isEqualToString:@"多数据排列柱状图"]) {
        
        LIST_TO([self rankBarView]);
    }
    else if ([string isEqualToString:@"大数据折线图"]) {
        
        LIST_TO([self crossLineView]);
    }
    else if ([string isEqualToString:@"数据叠加折线图"]) {
        
        LIST_TO([self cumSumLineView]);
    }
}

@end
