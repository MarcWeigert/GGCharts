//
//  RankBarView.h
//  HSCharts
//
//  Created by 黄舜 on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//
//  多数据排列柱状图
//
//  dataArys = @[@[@12, @13, ...], @[@13, @1, ...]]
//
//  1.二维数组中每一个子数组长度需要保持一致。
//  2.颜色数组需要与二维数组长度保持一致。
//  3.标题数组需要与二位数组长度保持一致。
//  4.@(FLT_MIN) 表示无效值

#import <UIKit/UIKit.h>

@interface RankBarView : UIView

@property (nonatomic) NSArray <NSArray <NSNumber *>*>*dataArys;    ///< 图形数据

@property (nonatomic) NSArray <NSString *>*titleAry;   ///< 横坐标数据

@property (nonatomic) NSArray <UIColor *>*colorAry;    ///< 柱状图颜色

/** 绘制视图 */
- (void)stockChart;

/** 
 * 增加动画
 * 参数 duration 动画时间
 */
- (void)addAnimation:(NSTimeInterval)duration;

@end
