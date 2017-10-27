//
//  ProgressChart.m
//  GGCharts
//
//  Created by _ | Durex on 17/10/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "ProgressChart.h"

@implementation ProgressChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _progressCanvas = [[ProgressCanvas alloc] init];
        _progressCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
        [self.layer addSublayer:_progressCanvas];
    }
    
    return self;
}

- (void)setProgressData:(ProgressData *)progressData
{
    _progressData = progressData;
    _progressCanvas.progressAbstract = progressData;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _progressCanvas.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

/**
 * 绘制进度条图
 */
- (void)drawProgressChart
{
    [_progressCanvas drawChart];
}

/**
 * 启动动画
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration
{
    [_progressCanvas startAnimationWithDuration:duration];
}

@end
