//
//  OutSideLable.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "InnerLable.h"
#import "PieOutSideLableAbstract.h"

@interface OutSideLable : InnerLable <PieOutSideLableAbstract>

/**
 * 线宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 折线与扇形图的间距
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 * 线长度
 */
@property (nonatomic, assign) CGFloat lineLength;

/**
 * 拐弯线长度
 */
@property (nonatomic, assign) CGFloat inflectionLength;

/**
 * 拐点线终点圆形半径
 */
@property (nonatomic, assign) CGFloat linePointRadius;

/**
 * 折线颜色
 */
@property (nonatomic, copy) UIColor * (^lineColorsBlock)(NSInteger index, CGFloat ratio);

@end
