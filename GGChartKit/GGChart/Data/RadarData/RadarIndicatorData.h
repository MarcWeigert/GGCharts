//
//  RadarIndicatorData.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RardarIndicatorMake(title, maxs) [RadarIndicatorData indicatorWithTitle:title max:maxs]

@interface RadarIndicatorData : NSObject

/**
 * 标题
 */
@property (nonatomic, strong) NSString * title;

/**
 * 最大值
 */
@property (nonatomic, assign) CGFloat max;

/**
 * 初始化方法
 */
+ (RadarIndicatorData *)indicatorWithTitle:(NSString *)title max:(CGFloat)max;

@end
