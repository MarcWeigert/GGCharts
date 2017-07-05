//
//  ListVC.m
//  HCharts
//
//  Created by 黄舜 on 16/5/10.
//  Copyright © 2016年 黄舜. All rights reserved.
//

#import "ListVC.h"
#import "IOBarChartViewController.h"
#import "LineBarChartViewController.h"
#import "NTPieViewController.h"
#import "MDLineViewController.h"
#import "KTimeViewController.h"
#import "KLineViewController.h"

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
    return @{@"IOBarChartView" : @"",
             @"LineBarChartView" : @"",
             @"NTPieView" : @"",
             @"MDLineView" : @"",
             @"TimeChartView" : @""
             @"KLineChartView"};
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
    return @[@"Chart", @"StockChart"];
}

- (NSArray *)rowAry
{
    return @[@[@"IOBarChartView", @"LineBarChartView", @"NTPieView", @"MDLineView"], @[@"TimeChartView", @"KLineChartView"]];
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
    
    if ([selectStr isEqualToString:@"IOBarChartView"]) {
        
        [self.navigationController pushViewController:[IOBarChartViewController new] animated:NO];
    }
    else if ([selectStr isEqualToString:@"LineBarChartView"]) {
    
        [self.navigationController pushViewController:[LineBarChartViewController new] animated:NO];
    }
    else if ([selectStr isEqualToString:@"NTPieView"]) {
    
        [self.navigationController pushViewController:[NTPieViewController new] animated:NO];
    }
    else if ([selectStr isEqualToString:@"MDLineView"]) {
        
        [self.navigationController pushViewController:[MDLineViewController new] animated:NO];
    }
    else if ([selectStr isEqualToString:@"TimeChartView"]) {
    
        [self.navigationController pushViewController:[KTimeViewController new] animated:NO];
    }
    else if ([selectStr isEqualToString:@"KLineChartView"]) {
        
        [self.navigationController pushViewController:[KLineViewController new] animated:NO];
    }
    else {
    
        UIView *chartView;
        
        SuppressPerformSelectorLeakWarning (
                                            
                                            chartView = [self performSelector:selector];
                                            );
        
        UIViewController *vc = [[UIViewController alloc] init];
        vc.title = selectStr;
        [vc.view addSubview:chartView];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

@end
