//
//  RadarData.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadarData : NSObject

@property (nonatomic, assign) CGFloat lineWidth;        ///< 线宽

@property (nonatomic, strong) UIColor *fillColor;       ///< 填充颜色

@property (nonatomic, strong) UIColor *strockColor;     ///< 线颜色

@property (nonatomic, assign) CGFloat baseRatio;        ///< 基础长度比例

@property (nonatomic, strong) NSArray <NSNumber *> *datas;    ///< 数据源

#pragma mark - Gradient

@property (nonatomic, strong) NSArray * gradientColors;     ///< CGColor

@property (nonatomic, strong) NSArray <NSNumber *> *locations;

@end
