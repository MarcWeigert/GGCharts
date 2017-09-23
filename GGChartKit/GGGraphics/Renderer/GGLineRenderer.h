//
//  GGLine.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGRenderProtocol.h"
#import "GGChartGeometry.h"

@interface GGLineRenderer : NSObject <GGRenderProtocol>

/**
 * 渲染器线结构体
 */
@property (nonatomic, assign) GGLine line;

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat width;

/**
 * 折线颜色
 */
@property (nonatomic, strong) UIColor *color;

/**
 * 虚线样式
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dashPattern;

@end
