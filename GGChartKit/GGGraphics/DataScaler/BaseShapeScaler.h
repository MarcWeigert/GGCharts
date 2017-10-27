//
//  BaseShapeScaler.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseScaler.h"

@interface BaseShapeScaler : BaseScaler

/**
 * 每一个模型的宽度
 */
@property (nonatomic, assign) CGFloat shapeWidth;

/**
 * 形间距模型间距
 */
@property (nonatomic, assign) CGFloat shapeInterval;

/**
 * 所有绘制模型区域
 */
@property (nonatomic, assign, readonly) CGSize contentSize;

/**
 * 模型之间中心点间距
 */
@property (nonatomic, assign, readonly) CGFloat interval;

@end
