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

@interface GGNumberRenderer : NSObject <GGRenderProtocol>

@property (nonatomic, assign) CGFloat fromNumber;   ///< 开始数字
@property (nonatomic, assign) CGFloat toNumber;     ///< 结束数字

@property (nonatomic, assign) CGPoint fromPoint;    ///< 开始绘制点
@property (nonatomic, assign) CGPoint toPoint;      ///< 运动点

@property (nonatomic, strong) UIFont * font;        ///< 字体
@property (nonatomic, strong) UIColor * color;      ///< 颜色
@property (nonatomic, assign) CGPoint offSetRatio;  ///< 文字
@property (nonatomic, assign) NSString * formatter; ///< 格式化字符串

- (void)drawAtLastNumber;

- (void)updateAnimationRenderer:(NSTimeInterval)duation current:(NSTimeInterval)current;

@end
