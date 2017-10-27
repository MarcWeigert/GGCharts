//
//  AxisName.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/14.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AxisName : NSObject

/**
 * 标题文字
 */
@property (nonatomic, strong) NSString * string;

/**
 * 标题文字字体
 */
@property (nonatomic, strong) UIFont * font;

/**
 * 标题文字颜色
 */
@property (nonatomic, strong) UIColor * color;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 标题文字偏移量
 */
@property (nonatomic, assign) CGSize offSetSize;

@end
