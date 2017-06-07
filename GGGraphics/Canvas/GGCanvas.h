//
//  GGCanvas.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GGRenderProtocol.h"

@interface GGCanvas : CALayer

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

@end
