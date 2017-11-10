//
//  BaseLineBarData.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ScalerAxisLeft = 0,         ///< 左边轴
    ScalerAxisRight,            ///< 右边轴
} ScalerAxisMode;

@interface BaseLineBarData : NSObject

/**
 * 柱状图, 折线定标器
 */
@property (nonatomic, strong, readonly) DLineScaler * lineBarScaler;

/**
 * 用来显示的数据
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dataAry;

/**
 * 柱状, 折线定标轴, 默认左轴
 */
@property (nonatomic, assign) ScalerAxisMode scalerMode;

/**
 * 围绕该Y轴坐标点填充, FLT_MIN 代表不填充
 */
@property (nonatomic, strong) NSNumber * roundNumber;

/**
 * 环绕Y轴像素点
 */
@property (nonatomic, assign, readonly) CGFloat bottomYPix;


#pragma mark - 折线文字

/**
 * 柱状, 折线文字字体
 */
@property (nonatomic, strong) UIFont * stringFont;

/**
 * 柱状, 折线文字颜色
 */
@property (nonatomic, strong) UIColor * stringColor;

/**
 * 柱状, 折线格式化字符串
 */
@property (nonatomic, strong) NSString * dataFormatter;

/**
 * 折线文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 柱状, 折线文字偏移
 */
@property (nonatomic, assign) CGSize stringOffset;

@end
