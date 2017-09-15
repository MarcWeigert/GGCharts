//
//  GGNumberRenderer.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"
#import "Animator.h"

@interface GGNumberRenderer : NSObject <GGRenderProtocol, AnimatorProtocol>

@property (nonatomic, assign) CGFloat fromNumber;   ///< 开始数字
@property (nonatomic, assign) CGFloat toNumber;     ///< 结束数字

@property (nonatomic, assign) CGPoint fromPoint;    ///< 开始绘制点
@property (nonatomic, assign) CGPoint toPoint;      ///< 运动点

@property (nonatomic, strong) UIFont * font;        ///< 字体
@property (nonatomic, strong) UIColor * color;      ///< 颜色
@property (nonatomic, assign) CGPoint offSetRatio;  ///< 文字
@property (nonatomic, strong) NSString * format;    ///< 格式化字符串

@property (nonatomic, assign) CGSize offSet;        ///< 文字偏移量

@property (nonatomic, assign) BOOL hidden;          ///< 是否显示

/**
 * 获取文字颜色
 */
@property (nonatomic, copy) UIColor *(^getNumberColorBlock)(CGFloat value);


/** 绘制起始点文字 */
- (void)drawAtToNumberAndPoint;

/** 绘制终点文字 */
- (void)drawAtFromNumberAndPoint;

@end
