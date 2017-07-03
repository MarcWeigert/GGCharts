//
//  PieChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseCountChart.h"
#import "PieData.h"

@interface PieChart : BaseCountChart

@property (nonatomic, assign) CGFloat radius;       ///< 半径

@property (nonatomic, strong) NSArray <PieData *> *dataAry;     ///< 数据

@property (nonatomic, strong) UIFont * titleFont;     ///< 标题字体
@property (nonatomic, strong) UIFont * perFont;           ///< 比例字体
@property (nonatomic, copy) NSString * attachedString;      ///< 附加字符串
@property (nonatomic, copy) NSString * format;  ///< 数据格式化字符串
@property (nonatomic, assign) BOOL isInside;    ///< 标题文字是否在中心显示

@property (nonatomic, copy) NSString * centerString;    ///< 中心标题
@property (nonatomic, strong) UIFont * centerFont;      ///< 中心文字字体
@property (nonatomic, strong) UIColor * centerStringColor;  ///< 中心文字颜色
@property (nonatomic, strong) UIColor * annularColor;   ///< 环颜色
@property (nonatomic, strong) UIColor * centerBackColor;    ///< 中心文字颜色

/**
 * 扇形图旋转动画
 *
 * @param duration 动画时长
 */
- (void)animationRotateForDuration:(NSTimeInterval)duration;

/**
 * 扇形图弹射动画
 *
 * @param duration 动画时长
 */

- (void)animationEjectForDuration:(NSTimeInterval)duration;

@end
