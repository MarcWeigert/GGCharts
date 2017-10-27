//
//  PieOutSideLable.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef PieOutSideLable_h
#define PieOutSideLable_h

#import "PieInnerLableAbstract.h"

@protocol PieOutSideLableAbstract <PieInnerLableAbstract>

/**
 * 线宽度
 */
@property (nonatomic, assign, readonly) CGFloat lineWidth;

/**
 * 折线与扇形图的间距
 */
@property (nonatomic, assign, readonly) CGFloat lineSpacing;

/**
 * 线长度
 */
@property (nonatomic, assign, readonly) CGFloat lineLength;

/**
 * 拐弯线长度
 */
@property (nonatomic, assign, readonly) CGFloat inflectionLength;

/**
 * 拐点线终点半径
 */
@property (nonatomic, assign, readonly) CGFloat linePointRadius;

/**
 * 折线颜色
 */
@property (nonatomic, copy, readonly) UIColor * (^lineColorsBlock)(NSInteger index, CGFloat ratio);

@end

#endif /* PieOutSideLable_h */
