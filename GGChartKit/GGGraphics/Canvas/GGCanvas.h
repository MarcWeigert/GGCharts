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
#import "GGNumberRenderer.h"
#import "GGPieLayer.h"

@interface GGCanvas : CALayer

/**
 * 是否关闭隐士动画
 */
@property (nonatomic, assign) BOOL isCloseDisableActions;

/**
 * 是否保存上级缓存
 *
 * 如果开启该缓存, 调用removeAllRenderers, 会保留上一次绘制内容
 */
@property (nonatomic, assign) BOOL isCashBeforeRenderers;

/**
 * 当前显示的NumberRenderer
 */
@property (nonatomic, strong, readonly) NSArray <GGNumberRenderer *> * visibleNumberRenderers;


#pragma mark - 渲染器

/**
 * 获取Number渲染器
 */
- (GGNumberRenderer *)getNumberRenderer;


#pragma mark - 取层

/**
 * 绘制图表(子类重写), 重绘时会重置所有的Layer
 */
- (void)drawChart;

/**
 * 取图层视图大小与Chart一致
 */
- (GGShapeCanvas *)getGGShapeCanvasEqualFrame;

/**
 * 取图层视图大小与Chart一致
 */
- (CAGradientLayer *)getCAGradientEqualFrame;

/**
 * 取图层视图大小与Chart一致
 */
- (GGCanvas *)getCanvasEqualFrame;

/**
 * 取图层视图大小与Chart一致
 */
- (GGPieLayer *)getPieLayerEqualFrame;

#pragma mark - 绘制

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
