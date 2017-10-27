//
//  GGGride.h
//  111
//
//  Created by _ | Durex on 2017/5/22.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"

@interface GGGridRenderer : NSObject <GGRenderProtocol>

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat width;

/**
 * 线颜色
 */
@property (nonatomic, strong) UIColor *color;

/**
 * 虚线样式
 */
@property (nonatomic, assign) CGSize dash;

/**
 * 网格结构体
 */
@property (nonatomic, assign) GGGrid grid;

/**
 * 是否需要外框
 */
@property (nonatomic, assign) BOOL isNeedRect;

/**
 * 网格加线 
 */
- (void)addLine:(GGLine)line;

/**
 * 删除Line 
 */
- (void)removeAllLine;

@end
