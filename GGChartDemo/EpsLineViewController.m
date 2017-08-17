//
//  EpsLineViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/14.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "EpsLineViewController.h"
#import "BaseModel.h"
#import "LineCanvas.h"
#import "LineDataSet.h"
#import "GGLineData.h"
#import "GridBackCanvas.h"
#import "GGChartDefine.h"
#import "GGLineChart.h"
#import "NSArray+Stock.h"

@interface Eps : BaseModel

@property (nonatomic) CGFloat eps_y1;

@property (nonatomic) CGFloat eps_y2;

@property (nonatomic) CGFloat close_price;

@property (nonatomic) NSInteger equity_change;

@end

@implementation Eps


@end

#pragma mark - EpsLineViewController

@interface EpsLineViewController ()

@end

@implementation EpsLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"EPS";
    
    NSData * dataTimeStock = [NSData dataWithContentsOfFile:[self epsStockDataJsonPath]];
    NSArray * stockEpsJson = [NSJSONSerialization JSONObjectWithData:dataTimeStock options:0 error:nil];
    NSArray * epsData = [BaseModel arrayForArray:stockEpsJson class:[Eps class]];
    
    NSArray * stockPrice = [epsData numbarArrayForKey:@"close_price"];
    NSArray * epsY1 = [epsData numbarArrayForKey:@"eps_y1"];
    NSArray * epsY2 = [epsData numbarArrayForKey:@"eps_y2"];
    
    GGLineData * liney1 = [[GGLineData alloc] init];
    liney1.lineWidth = .5f;
    liney1.lineColor = RGB(234, 120, 86);
    liney1.lineDataAry = epsY1;
    
    GGLineData * liney2 = [[GGLineData alloc] init];
    liney2.lineWidth = .5f;
    liney2.lineColor = RGB(181, 220, 249);
    liney2.lineDataAry = epsY2;
    
    GGLineData * line = [[GGLineData alloc] init];
    line.lineWidth = 1.2;
    line.lineColor = RGB(202, 71, 33);
    line.lineDataAry = stockPrice;
    line.scalerType = ScalerAxisRight;
    
    LineDataSet * lineSet = [[LineDataSet alloc] init];
    lineSet.insets = UIEdgeInsetsMake(30, 50, 30, 50);
    lineSet.lineAry = @[liney1, liney2, line];
    lineSet.gridColor = RGB(186, 167, 169);
    lineSet.gridLineWidth = .7f;
    lineSet.isCenterAlignment = NO;
    
    lineSet.bottomAxis.titles = @[@"2017.02", @"2017.03", @"2017.03", @"2017.04", @"2017.04", @"2017.05", @"2017.05", @"2017.06", @"2017.06", @"2017.07", @"2017.07"];
    lineSet.bottomAxis.needShowGridLine = YES;
    lineSet.bottomAxis.over = 2;
    lineSet.bottomAxis.axisColor = [UIColor blackColor];
    lineSet.bottomAxis.axisFont = [UIFont systemFontOfSize:9];
    lineSet.bottomAxis.stringColor = RGB(186, 167, 169);
    lineSet.bottomAxis.hiddenPattern = @[@2];
    
    lineSet.leftAxis.splitCount = 5;
    lineSet.leftAxis.dataFormatter = @"%.2f";
    lineSet.leftAxis.axisColor = RGB(186, 167, 169);
    lineSet.leftAxis.needShowAxisLine = NO;
    lineSet.leftAxis.axisFont = [UIFont systemFontOfSize:9];
    lineSet.leftAxis.over = 0;
    lineSet.leftAxis.offset = -2;
    lineSet.leftAxis.drawAxisName.string = @"EPS";
    lineSet.leftAxis.drawAxisName.offsetOfEndPoint = 15;
    lineSet.leftAxis.drawAxisName.offsetRatio = CGPointMake(-1, -0.5);
    lineSet.leftAxis.drawAxisName.font = [UIFont boldSystemFontOfSize:10];
    lineSet.leftAxis.drawAxisName.color = RGB(181, 220, 249);
    
    lineSet.rightAxis.splitCount = 5;
    lineSet.rightAxis.axisFont = [UIFont systemFontOfSize:9];
    lineSet.rightAxis.over = 0;
    lineSet.rightAxis.axisColor = RGB(186, 167, 169);
    lineSet.rightAxis.offset = 2;
    lineSet.rightAxis.drawAxisName.string = @"股票价格";
    lineSet.rightAxis.drawAxisName.font = [UIFont boldSystemFontOfSize:10];
    lineSet.rightAxis.drawAxisName.offsetOfEndPoint = 15;
    lineSet.rightAxis.drawAxisName.color = RGB(181, 220, 249);
    
    GGLineChart * lineChart = [[GGLineChart alloc] initWithFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 250)];
    lineChart.lineDataSet = lineSet;
    [lineChart drawLineChart];
    [self.view addSubview:lineChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)epsStockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"eps_line_data" ofType:@"json"];
}

@end
