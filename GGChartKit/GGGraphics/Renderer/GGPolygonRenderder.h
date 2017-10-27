//
//  GGPolygonRenderder.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"

@interface GGPolygonRenderder : NSObject <GGRenderProtocol>

/**
 * 多边形结构体
 */
@property (nonatomic, assign) GGPolygon polygon;

/**
 * 是否绘制圆形
 */
@property (nonatomic, assign) BOOL isCircle;

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat width;

/**
 * 最外层线宽
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 绘制线颜色
 */
@property (nonatomic, strong) UIColor * strockColor;

/**
 * 填充颜色
 */
@property (nonatomic, strong) UIColor * fillColor;

/**
 * 分割层数
 */
@property (nonatomic, assign) NSInteger splitCount;

/**
 * 单层填充色
 */
@property (nonatomic, strong) UIColor * singleFillColor;

/**
 * 双层填充色
 */
@property (nonatomic, strong) UIColor * doubleFillColor;

/**
 * 是否需要分割线
 */
@property (nonatomic, assign) BOOL isPiece;

/**
 * 文字字体
 */
@property (nonatomic, strong) UIFont * stringFont;

/**
 * 文字颜色
 */
@property (nonatomic, strong) UIColor * stringColor;

/**
 * 字体数组
 */
@property (nonatomic, strong) NSArray <NSString *> * titles;

/**
 * 文字与定点间距
 */
@property (nonatomic, assign) CGFloat titleSpacing;

@end
