//
//  GGCanvas.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GGRenderProtocol.h"
#import "GGShapeCanvas.h"

@interface GGCanvas : CALayer

@property (nonatomic, assign) BOOL isCloseDisableActions;

/**
 * 绘制图表(子类重写)
 */
- (void)drawChart;

/**
 * 取图层视图大小为正方形
 */
- (GGShapeCanvas *)getGGCanvasSquareFrame;

/**
 * 取图层视图大小与Chart一致
 */
- (GGShapeCanvas *)getGGCanvasEqualFrame;

/**
 * 增加一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)addRenderer:(id <GGRenderProtocol>)renderer;

/**
 * 删除一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)removeRenderer:(id <GGRenderProtocol>)renderer;

/**
 * 删除所有绘图工具
 */
- (void)removeAllRenderer;

@end
