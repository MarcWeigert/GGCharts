//
//  GGPolygonRenderder.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"

@interface GGPolygonRenderder : NSObject <GGRenderProtocol>

@property (nonatomic, assign) GGPolygon polygon;    ///< 多边形结构体

@property (nonatomic, assign) CGFloat width;            ///< 线宽
@property (nonatomic, strong) UIColor * strockColor;        ///< 绘制颜色
@property (nonatomic, strong) UIColor * fillColor;      ///< 填充颜色

@property (nonatomic, assign) NSInteger splitCount;      ///< 层数
@property (nonatomic, strong) UIColor * singleFillColor;    ///< (单)填充颜色
@property (nonatomic, strong) UIColor * doubleFillColor;    ///< (双)填充颜色

@property (nonatomic, assign) BOOL isPiece;         ///< 是否要分割线
@property (nonatomic, strong) UIFont * stringFont;      ///< 文字字体
@property (nonatomic, strong) UIColor * stringColor;        ///< 文字颜色
@property (nonatomic, strong) NSArray * titles;         ///< 顶头文字
@property (nonatomic, assign) CGFloat titleSpacing;         ///< 文字雷达图距离

@end
