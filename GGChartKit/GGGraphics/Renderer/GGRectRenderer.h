//
//  GGRectRenderer.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGRenderProtocol.h"

@interface GGRectRenderer : NSObject <GGRenderProtocol>

/**
 * 绘制区域
 */
@property (nonatomic, assign) CGRect rect;

/**
 * 区域边框宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 区域边框颜色
 */
@property (nonatomic, strong) UIColor * borderColor;

/**
 * 区域填充颜色
 */
@property (nonatomic, strong) UIColor * fillColor;

@end
