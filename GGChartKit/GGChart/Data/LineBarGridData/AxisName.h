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
 * 轴文字偏移比例
 *
 * {0, 0} 数据点左下方绘制, {-0.5, -0.5} 数据点中心绘制, {-1, -1} 数据点右上方绘制
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 标题文字偏移量
 */
@property (nonatomic, assign) CGSize offSetSize;

@end
