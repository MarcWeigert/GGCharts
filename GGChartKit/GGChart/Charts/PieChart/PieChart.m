//
//  PieChart.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieChart.h"
#import "PieCanvas.h"
#import "CenterCanvas.h"

@interface PieChart ()

/**
 * 扇形图画布
 */
@property (nonatomic, strong) PieCanvas * pieCanvas;

/**
 * 中心文字画布
 */
@property (nonatomic, strong) CenterCanvas * centerCanvas;

@end

@implementation PieChart

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _pieCanvas = [[PieCanvas alloc] init];
        [self.layer addSublayer:_pieCanvas];
        
        _centerCanvas = [[CenterCanvas alloc] init];
        [self.layer addSublayer:_centerCanvas];
        
        [self setFrame:frame];
    }
    
    return self;
}

/**
 * 设置视图大小
 */
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _pieCanvas.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _centerCanvas.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

/**
 * 绘制扇形图表
 */
- (void)drawPieChart
{
    [self.pieDataSet updateChartConfigs:CGRectMake(0, 0, self.gg_width, self.gg_height)];
    
    self.pieCanvas.pieCanvasConfig = self.pieDataSet;
    self.centerCanvas.centerConfig = (id <CenterAbstract>)self.pieDataSet.centerLable;
    
    [self.pieCanvas drawChart];
    [self.centerCanvas drawChart];
}

@end
