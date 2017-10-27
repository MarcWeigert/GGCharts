//
//  YNumberAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef NumberAxisAbstract_h
#define NumberAxisAbstract_h

#import "BaseAxisAbstract.h"

#pragma mark - 数字轴标题

@protocol NumberAxisNameAbstract <NSObject>

/**
 * 标题文字
 */
@property (nonatomic, strong, readonly) NSString * string;

/**
 * 标题文字字体
 */
@property (nonatomic, strong, readonly) UIFont * font;

/**
 * 标题文字颜色
 */
@property (nonatomic, strong, readonly) UIColor * color;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign, readonly) CGPoint offSetRatio;

/**
 * 标题文字偏移量
 */
@property (nonatomic, assign, readonly) CGSize offSetSize;

@end

#pragma mark - 数字轴

@protocol NumberAxisAbstract <BaseAxisAbstract>

/**
 * 轴格式化字符串
 */
@property (nonatomic, strong, readonly) NSString * dataFormatter;

/**
 * Y轴分割个数
 */
@property (nonatomic, assign, readonly) NSUInteger splitCount;

/**
 * 轴标题
 */
@property (nonatomic, strong, readonly) id <NumberAxisNameAbstract> name;

/**
 * 通过轴线当前长度获取数据
 *
 * @param pix 像素
 *
 * @return 数据
 */
- (CGFloat)getNumberWithPix:(CGFloat)pix;

/**
 * 设置轴内极大极小值
 *
 * @param maxValue 极大值
 * @param minValue 极小值
 */
- (void)setDataAryMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

@end

#endif /* NumberAxisAbstract_h */
