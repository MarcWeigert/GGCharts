//
//  PieAnimationManager.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PieAnimationManager : NSObject

/**
 * 初始化旋转角度
 */
@property (nonatomic, assign) CGFloat tansform;

/**
 * 绘制类
 */
@property (nonatomic, weak) id <PieCanvasAbstract> pieCanvasAbstract;

/**
 * 开始动画
 *
 * @param 动画时长
 * @param 动画类型
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration animationType:(PieAnimationType)type;

/**
 * 点击动画
 */
- (void)startAnimationForIndexPath:(NSIndexPath *)indexPath;

@end
