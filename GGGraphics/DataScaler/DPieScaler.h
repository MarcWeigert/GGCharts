//
//  DPieScaler.h
//  HSCharts
//
//  Created by _ | Durex on 2017/7/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseScaler.h"

@interface DPieScaler : BaseScaler

@property (nonatomic, readonly) CGFloat sum;            ///< 扇形图数据总和

@property (nonatomic, readonly) NSArray <NSObject *> *pieObjAry;    ///< 扇形图数据

@property (nonatomic, readonly) CGFloat * arcs;     ///< 扇形图开角
@property (nonatomic, readonly) CGFloat * transArcs;    ///< 扇形移动角度
@property (nonatomic, readonly) CGFloat * ratios;    ///< 比例

@property (nonatomic, assign) CGFloat baseArc;  ///< 扇形图旋转角度, 默认 M_PI_2 (12点钟方向)

/**
 * 自定义对象转换转换, 如果设置则忽略dataAry
 *
 * @param objAry 模型类数组
 * @param getter 模型类方法, 方法无参数, 返回值为CGFloat, 否则会崩溃。
 */
- (void)setObjAry:(NSArray <NSObject *> *)objAry getSelector:(SEL)getter;

/** 更新计算点 */
- (void)updateScaler;

@end
