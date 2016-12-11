//
//  LineBarView.h
//  HSCharts
//
//  Created by _ | Durex on 16/12/11.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineBarView : UIView

@property (nonatomic) NSArray *lineAry;                ///< 线数据

@property (nonatomic) NSArray *barAry;                 ///< 柱型图数据

@property (nonatomic) NSArray <NSString *>*titleAry;   ///< 横坐标数据

@property (nonatomic) UIColor *barColor;

@property (nonatomic) UIColor *lineColor;

/** 绘制视图 */
- (void)stockChart;

/**
 * 增加动画
 * 参数 duration 动画时间
 */
- (void)addAnimation:(NSTimeInterval)duration;

@end
