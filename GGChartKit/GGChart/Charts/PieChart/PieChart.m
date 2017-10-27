//
//  PieChart.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/22.
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

/**
 * 当前选择
 */
@property (nonatomic, strong) NSIndexPath * selectIndexPath;

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
 * 长按相应时间
 */
- (NSTimeInterval)minimumPressDuration
{
    return 0;
}

/**
 * 即将响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateBegan:(CGPoint)point
{
    [self onTouchOrMoveWithPoint:point];
}

/**
 * 即将结束响应长按手势
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateEnded:(CGPoint)point
{
    
}

/**
 * 响应长按手势点变换
 *
 * @param point 视图响应的点
 */
- (void)longPressGestureRecognizerStateChanged:(CGPoint)point
{
    [self onTouchOrMoveWithPoint:point];
}

/**
 * 扇形图响应事件
 */
- (void)onTouchOrMoveWithPoint:(CGPoint)point
{
    for (NSInteger i = 0; i < self.pieDataSet.pieAry.count; i++) {
        
        PieData * pieData = self.pieDataSet.pieAry[i];
        
        for (NSInteger j = 0; j < pieData.dataAry.count; j++) {
            
            GGPie pie = pieData.pies[j];
            
            if (GGPieContainsPoint(point, pie)) {
                
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                
                if (_selectIndexPath == nil || !(_selectIndexPath.row == indexPath.row &&
                                                 _selectIndexPath.section == indexPath.section)) {
                    
                    [self.pieCanvas.pieAnimation startAnimationForIndexPath:indexPath];
                }
                
                _selectIndexPath = indexPath;
                
                break;
            }
        }
    }
}

#pragma mark - Chart

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
    
    _selectIndexPath = nil;
    self.centerCanvas.hidden = !self.pieDataSet.showCenterLable;
}

/**
 * 动画
 *
 * @param pieAnimationType 动画类型
 * @param duration 动画时间
 */
- (void)startAnimationsWithType:(PieAnimationType)pieAnimationType duration:(NSTimeInterval)duration
{
    [_pieCanvas startAnimationsWithType:pieAnimationType duration:duration];
}

@end
