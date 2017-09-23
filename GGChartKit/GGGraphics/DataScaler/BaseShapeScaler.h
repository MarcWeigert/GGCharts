//
//  BaseShapeScaler.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseScaler.h"

@interface BaseShapeScaler : BaseScaler

@property (nonatomic, assign) CGFloat shapeWidth;   ///< 形宽
@property (nonatomic, assign) CGFloat shapeInterval;  ///< 形间距

@property (nonatomic, assign, readonly) CGSize contentSize;    ///< 大小区域

@property (nonatomic, assign, readonly) CGFloat interval;   ///< 两个形之间中心间距

@end
