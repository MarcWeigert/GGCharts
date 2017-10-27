//
//  DKLineScaler.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseShapeScaler.h"
#import "GGChartGeometry.h"

@interface DKLineScaler : BaseShapeScaler

/**
 * 区域内最大值
 */
@property (nonatomic, assign) CGFloat max;

/**
 * 区域内最小值
 */
@property (nonatomic, assign) CGFloat min;

/**
 * 横向最大点数 默认与数组一致
 */
@property (nonatomic, assign) NSInteger xMaxCount;

/**
 * 数据与dataAry二选一
 */
@property (nonatomic, readonly) NSArray <NSObject *> *kLineObjAry;

/**
 * k线形态指针长度与kLineObjAry一致
 */
@property (nonatomic, readonly) GGKShape * kShapes;

/**
 * 自定义k线对象转换转换
 *
 * @param kLineObjAry 模型类数组
 * @param open 模型类方法, 方法无参数, 返回值为CGFloat
 * @param close 模型类方法, 方法无参数, 返回值为CGFloat
 * @param high 模型类方法, 方法无参数, 返回值为CGFloat
 * @param low 模型类方法, 方法无参数, 返回值为CGFloat
 */
- (void)setObjArray:(NSArray <NSObject *> *)kLineObjAry
            getOpen:(SEL)open
           getClose:(SEL)close
            getHigh:(SEL)high
             getLow:(SEL)low;

/** 更新计算点 */
- (void)updateScaler;

/** 更新局部计算点 */
- (void)updateScalerWithRange:(NSRange)range;

/** 根据点获取价格 */
- (CGFloat)getPriceWithPoint:(CGPoint)point;

@end
