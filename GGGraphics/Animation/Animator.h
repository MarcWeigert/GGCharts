//
//  Animator.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AnimationEaseInOut,
    AnimationEaseIn,
    AnimationEaseOut,
    AnimationLinear
} AnimationType;

typedef void(^AnimationUpdateBlock)(CGFloat progress);

@interface Animator : NSObject

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) AnimationType animationType;

@property (nonatomic, copy) AnimationUpdateBlock updateBlock;

/** 开始动画 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration;

@end
