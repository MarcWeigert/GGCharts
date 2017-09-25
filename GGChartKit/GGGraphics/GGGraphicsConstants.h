//
//  GGGraphicsConstants.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 纯小数(-1 <= x <= 1)
 */
#define PURE_DECIMAL(x)     (x - 1 > 0 ? 1 : (x - 1 < -2 ? -1 : x))

/**
 * 偏移比例转换
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
#define RATIO_POINT_CONVERT(p)              \
    CGPointMake((-1 + PURE_DECIMAL(p.x)) / 2, (-1 + PURE_DECIMAL(p.y)) / 2)

/**
 * 文字偏移比例
 */
CG_EXTERN CGPoint const GGRatioTopLeft;
CG_EXTERN CGPoint const GGRatioTopCenter;
CG_EXTERN CGPoint const GGRatioTopRight;

CG_EXTERN CGPoint const GGRatioBottomLeft;
CG_EXTERN CGPoint const GGRatioBottomCenter;
CG_EXTERN CGPoint const GGRatioBottomRight;

CG_EXTERN CGPoint const GGRatioCenterLeft;
CG_EXTERN CGPoint const GGRatioCenter;
CG_EXTERN CGPoint const GGRatioCenterRight;
