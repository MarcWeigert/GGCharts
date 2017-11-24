//
//  BaseMinimaxScaler.h
//  GGCharts
//
//  Created by 黄舜 on 2017/11/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseMinimaxScaler : NSObject

/**
 * 数组中极大值
 */
@property (nonatomic, readonly, assign) double dataAryMax;

/**
 * 数组中极小值
 */
@property (nonatomic, readonly, assign) double dataAryMin;

/**
 * 定标范围
 */
@property (nonatomic, assign) int scope;

/**
 * 当前的位置
 */
@property (nonatomic, assign) int index;

/**
 * 极大极小值方法定标方法
 *
 * @param array 定标器数组
 * @param getters 获取方法
 */
- (void)setObjectAry:(NSArray <NSObject *> *)array floatOrDoubleGetters:(NSArray *)getters;

@end
