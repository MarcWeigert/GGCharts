//
//  LineAnimationsManager.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/17.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineAnimationsManager : NSObject

/**
 * 绘制区域
 */
@property (nonatomic, assign) CGRect drawRect;

/**
 * 最底层
 */
@property (nonatomic, weak) CALayer * baseLineLayer;

/**
 * 注册折线图动画类
 *
 * @param 折线抽象类
 */
- (void)registerLineDrawAbstract:(id <LineDrawAbstract>)lineDrawAbstract;

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
- (void)startAnimationWithDuration:(NSTimeInterval)duration animationType:(LineAnimationsType)type;

@end
