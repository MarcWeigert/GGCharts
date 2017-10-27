//
//  GGCircle.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGRenderProtocol.h"
#import "GGChartGeometry.h"

@interface GGCircleRenderer : NSObject<GGRenderProtocol>

/**
 * 圆形结构体
 */
@property (nonatomic, assign) GGCircle circle;

/**
 * 圆环线宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 圆形填充颜色
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 * 圆环颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 * 中心点文字
 */
@property (nonatomic, copy) NSString *title;

/**
 * 渐变色, CGColors
 */
@property (nonatomic, strong) NSArray * gradentColors;

@end
