//
//  RadarDataSet.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadarData.h"
#import "RadarIndicatorData.h"

@interface RadarDataSet : NSObject

@property (nonatomic, strong) NSArray <RadarData *> * radarSet;         ///< 图层数据

@property (nonatomic, strong) NSArray <RadarIndicatorData *> * indicatorSet;        ///< 基础摄制

@property (nonatomic, strong) UIColor * strockColor;        ///< 背景雷达线颜色

@property (nonatomic, assign) NSUInteger splitCount;        ///< 分割数

@property (nonatomic, strong) UIFont * titleFont;       ///< 标题字体

@property (nonatomic, assign) CGFloat lineWidth;        ///< 线宽

@property (nonatomic, assign) CGFloat radius;       ///< 雷达图半径

@property (nonatomic, strong) UIColor * stringColor;

@end
