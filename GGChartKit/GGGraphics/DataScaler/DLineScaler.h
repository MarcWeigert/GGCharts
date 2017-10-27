//
//  DLineScaler.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseScaler.h"
#import "GGChartGeometry.h"

@interface DLineScaler : BaseScaler

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
@property (nonatomic, assign) NSUInteger xMaxCount;

/**
 * 环绕点数据
 */
@property (nonatomic, strong) NSNumber * aroundNumber;

/**
 * x轴偏移比例 0-1 默认 0.5
 */
@property (nonatomic, assign) CGFloat xRatio;

/**
 * 数据与lineObjAry二选一
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dataAry;

/**
 * 数据与dataAry二选一
 */
@property (nonatomic, readonly) NSArray <NSObject *> *lineObjAry;

/**
 * 数据点 size 与数据一致
 */
@property (nonatomic, readonly) CGPoint * linePoints;

/**
 * linePoints指针长度
 */
@property (nonatomic, readonly) NSInteger pointSize;

/**
 * 根据 aroundNumber 计算出的最低点
 *
 * 注意 : 如果 aroundNumber == nil, 则 : CGRectGetMaxY(self.rect)
 */
@property (nonatomic, readonly) CGFloat aroundY;

/**
 * 自定义对象转换转换, 如果设置则忽略dataAry
 *
 * @param objAry 模型类数组
 * @param getter 模型类方法, 方法无参数, 返回值为CGFloat, 否则会崩溃。
 */
- (void)setObjAry:(NSArray <NSObject *> *)objAry getSelector:(SEL)getter;

/** 
 * 靠近点的数据index 
 *
 * @param 当前屏幕触碰的店
 */
- (NSUInteger)indexOfPoint:(CGPoint)point;

/** 
 * 根据数据更新屏幕的点
 */
- (void)updateScaler;

/** 
 * 根据数据区域更新计算点 
 *
 * @param range 更新数据数组区域
 */
- (void)updateScalerWithRange:(NSRange)range;

/** 
 * 数据转换成Y轴坐标
 *
 * @param data 数据
 */
- (CGFloat)getYPixelWithData:(CGFloat)data;

/** 
 * 点坐标转成数值
 *
 * @param point 点坐标
 */
- (CGFloat)getPriceWithPoint:(CGPoint)point;

/** 
 * 根据点获取价格 
 *
 * @param y y轴坐标
 */
- (CGFloat)getPriceWithYPixel:(CGFloat)y;

/**
 * 根据点获取价格
 *
 * @param y y轴坐标
 * @param max 最大值
 * @param min 最小值
 *
 * @return 价格点
 */
+ (CGFloat)getPriceWithYPixel:(CGFloat)y line:(GGLine)line max:(CGFloat)max min:(CGFloat)min;

@end
