//
//  Animator.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AnimationEaseInOut,
    AnimationEaseIn,
    AnimationEaseOut,
    AnimationLinear
} AnimationType;

@protocol AnimatorProtocol <NSObject>

/**
 * 动画回调
 *
 * @param progress 进度条
 */
- (void)startUpdateWithProgress:(CGFloat)progress;

@end

/**
 * 动画回调Block
 */
typedef void(^AnimationUpdateBlock)(CGFloat progress);

@interface Animator : NSObject

/**
 * 动画时长
 */
@property (nonatomic, assign) NSTimeInterval duration;

/**
 * 动画曲线
 */
@property (nonatomic, assign) AnimationType animationType;

/**
 * 动画更新回调
 */
@property (nonatomic, copy) AnimationUpdateBlock updateBlock;

/**
 * 增加动画类
 */
- (void)addAnimatior:(id <AnimatorProtocol>)animator;

/** 
 * 开始动画 
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration;

/**
 * 开始动画 
 * 
 * @param duration 时间
 * @param animators 动画更新数组
 * @param block 每次更新轮询blk
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration
                    animationArray:(NSArray <id <AnimatorProtocol>> *)animators
                       updateBlock:(AnimationUpdateBlock)block;

@end
