//
//  PieCanvasAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef PieCanvasAbstract_h
#define PieCanvasAbstract_h

#import "PieDrawAbstract.h"

@protocol PieCanvasAbstract <NSObject>

/**
 * 扇形图数组
 */
@property (nonatomic, strong, readonly) NSArray <id <PieDrawAbstract>> * pieAry;

/**
 * 扇形图边框宽度
 */
@property (nonatomic, assign, readonly) CGFloat pieBorderWidth;

/**
 * 环形间距
 */
@property (nonatomic, assign, readonly) CGFloat borderRadius;

/**
 * 扇形图边框颜色
 */
@property (nonatomic, strong, readonly) UIColor * pieBorderColor;

/**
 * 扇形图动画
 */
@property (nonatomic, assign, readonly) PieAnimationType pieAnimationType;

@end

#endif /* PieCanvasAbstract_h */
