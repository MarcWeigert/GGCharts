//
//  DPieScaler.h
//  HSCharts
//
//  Created by _ | Durex on 2017/7/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseScaler.h"
#import "GGPie.h"

@interface DPieScaler : BaseScaler

/**
 * 扇形图数据
 */
@property (nonatomic, strong, readonly) NSArray <NSObject *> *pieObjAry;

/**
 * 扇形图数据总和
 */
@property (nonatomic, assign, readonly) CGFloat sum;

/**
 * 扇形图比例
 */
@property (nonatomic, assign, readonly) CGFloat * ratios;

/**
 * 扇形图结构体
 */
@property (nonatomic, assign, readonly) GGPie * pies;

/**
 * 内边半径
 */
@property (nonatomic, assign) CGFloat inRadius;

/**
 * 外边半径
 */
@property (nonatomic, assign) CGFloat outRadius;

/**
 * 扇形图旋转角度, 默认 M_PI + M_PI_2 (12点钟方向)
 */
@property (nonatomic, assign) CGFloat baseArc;

/**
 * 是否需要比例伸缩
 */
@property (nonatomic, assign) BOOL roseRadius;

/**
 * 自定义对象转换转换, 如果设置则忽略dataAry
 *
 * @param objAry 模型类数组
 * @param getter 模型类方法, 方法无参数, 返回值为CGFloat, 否则会崩溃。
 */
- (void)setObjAry:(NSArray <NSObject *> *)objAry getSelector:(SEL)getter;

/** 
 * 更新屏幕像素点数据
 */
- (void)updateScaler;

@end
