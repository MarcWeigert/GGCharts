//
//  MDLineViewController.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MDLineViewController.h"
#import "LineChart.h"
#import "Colors.h"

@interface MDLineViewController ()

@end

@implementation MDLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"LineChart";
    
    NSData *dataStock = [NSData dataWithContentsOfFile:[self stockDataJsonPath]];
    NSDictionary *stockJson = [NSJSONSerialization JSONObjectWithData:dataStock options:0 error:nil];
    NSArray *beforeAry = stockJson[@"beforeData"];
    
    NSMutableArray * aryLineData = [NSMutableArray array];
    NSMutableSet * indexSet = [NSMutableSet set];
    NSMutableSet * indexPointSet = [NSMutableSet set];
    NSMutableArray * aryTitles = [NSMutableArray array];
    
    for (NSInteger i = 0; i < beforeAry.count; i++) {
        
        NSDictionary * dictionary = beforeAry[i];
        [aryLineData addObject:dictionary[@"close_price"]];
        [aryTitles addObject:[self titleDataString:dictionary[@"date"]]];
        
        if (i % 130 == 0) {
            
            [indexSet addObject:@(i)];
        }
        
        if (![dictionary[@"dividend"] isKindOfClass:[NSNull class]]) {
            
            [indexPointSet addObject:@(i)];
        }
    }
    
    GGLineData * lineData = [[GGLineData alloc] init];
    lineData.dataAry = aryLineData;
    lineData.lineWidth = .5f;
    lineData.lineColor = __RGB_BLUE;
    lineData.lineFillColor = [__RGB_BLUE colorWithAlphaComponent:.3f];
    lineData.showShapeIndexSet = indexPointSet;
    lineData.shapeRadius = 1.5f;
    lineData.shapeFillColor = __RGB_RED;
    
    LineDataSet * lineSet = [[LineDataSet alloc] init];
    lineSet.insets = UIEdgeInsetsMake(15, 0, 15, 0);
    lineSet.lineAry = @[lineData];
    lineSet.idRatio = .1f;
    
    /** 查价 */
    lineSet.queryConfig.lineWidth = .5f;
    lineSet.queryConfig.lineColor = RGB(186, 167, 169);
    lineSet.queryConfig.lableInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    
    /** 网格 */
    lineSet.gridConfig.lineColor = RGB(186, 167, 169);
    lineSet.gridConfig.lineWidth = .7f;
    lineSet.gridConfig.axisLineColor = [UIColor blackColor];
    lineSet.gridConfig.axisLableFont = [UIFont systemFontOfSize:8];
    lineSet.gridConfig.axisLableColor = RGB(186, 167, 169);
    lineSet.gridConfig.dashPattern = @[@2, @2];
    
    /** 底轴 */
    lineSet.gridConfig.bottomLableAxis.lables = aryTitles;
    lineSet.gridConfig.bottomLableAxis.over = 0;
    lineSet.gridConfig.bottomLableAxis.showSplitLine = YES;
    lineSet.gridConfig.bottomLableAxis.showQueryLable = YES;
    lineSet.gridConfig.bottomLableAxis.showIndexSet = indexSet;
    lineSet.gridConfig.bottomLableAxis.offSetRatio = CGPointMake(0, 0);
    
    /** 左轴 */
    lineSet.gridConfig.leftNumberAxis.splitCount = 7;
    lineSet.gridConfig.leftNumberAxis.dataFormatter = @"%.2f";
    lineSet.gridConfig.leftNumberAxis.over = 0;
    lineSet.gridConfig.leftNumberAxis.showSplitLine = YES;
    lineSet.gridConfig.leftNumberAxis.showQueryLable = YES;
    lineSet.gridConfig.leftNumberAxis.offSetRatio = CGPointMake(0, -1.0f);
    lineSet.gridConfig.leftNumberAxis.stringGap = 2;
    
    CGRect rect = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 250);
    LineChart * lineChart = [[LineChart alloc] initWithFrame:rect];
    lineChart.lineDataSet = lineSet;
    [lineChart drawLineChart];
    [self.view addSubview:lineChart];
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

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"stock_data" ofType:@"json"];
}

@end
