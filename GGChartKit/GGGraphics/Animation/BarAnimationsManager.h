//
//  BarAnimationsManager.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/16.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarAnimationsManager : NSObject

/**
 * 绘制区域
 */
@property (nonatomic, assign) CGRect drawRect;

/**
 * 中轴线动画层
 */
@property (nonatomic, weak) GGShapeCanvas * midLineLayer;

/**
 * 注册柱状图动画类
 *
 * @param 柱状抽象类
 */
- (void)registerBarDrawAbstract:(id <BarDrawAbstract>)barDrawAbstract;

/**
 * 清空动画类
 */
- (void)resetAnimationManager;

/**
 * 开始动画
 *
 * @param 动画时长
 * @param 动画类型
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration animationType:(BarAnimationsType)type;

@end
