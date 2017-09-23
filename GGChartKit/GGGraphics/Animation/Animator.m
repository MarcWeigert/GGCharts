//
//  Animator.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "Animator.h"

#define GGAnimationRate 3.0

@protocol AnimationConvertTimer <NSObject>

- (CGFloat)updateConvert:(CGFloat)time;

@end

@interface AnimatorLinear : NSObject <AnimationConvertTimer>

@end

@implementation AnimatorLinear

- (CGFloat)updateConvert:(CGFloat)time
{
    return time;
}

@end

@interface AnimatorEaseIn : NSObject <AnimationConvertTimer>

@end

@implementation AnimatorEaseIn

- (CGFloat)updateConvert:(CGFloat)time
{
    return powf(time, GGAnimationRate);
}

@end

@interface AnimatorEaseOut : NSObject <AnimationConvertTimer>

@end

@implementation AnimatorEaseOut

- (CGFloat)updateConvert:(CGFloat)time
{
    return 1.0 - powf((1.0 - time), GGAnimationRate);
}

@end

@interface AnimatorEaseInOut : NSObject <AnimationConvertTimer>

@end

@implementation AnimatorEaseInOut

- (CGFloat)updateConvert:(CGFloat)time
{
    time *= 2;
    if (time < 1) return 0.5f * powf (time, GGAnimationRate);
    else return 0.5f * (2.0f - powf(2.0 - time, GGAnimationRate));
}

@end

#pragma mark - Animator

@interface Animator ()

@property (nonatomic, strong) id <AnimationConvertTimer> animatorCounter;

@property (nonatomic, strong) CADisplayLink * disPlaylink;

@property (nonatomic, assign) NSTimeInterval maximumProgress;

@property (nonatomic, assign) NSTimeInterval lastUpdateTime;

@property (nonatomic, assign) NSTimeInterval progress;

@property (nonatomic, strong) NSArray <id <AnimatorProtocol>> * animators;

@end

@implementation Animator

- (void)setAnimationType:(AnimationType)animationType
{
    _animationType = animationType;
    
    switch (_animationType) {
        case AnimationEaseInOut:
            self.animatorCounter = [AnimatorEaseInOut new];
            break;
        case AnimationEaseIn:
            self.animatorCounter = [AnimatorEaseIn new];
            break;
        case AnimationEaseOut:
            self.animatorCounter = [AnimatorEaseOut new];
            break;
        case AnimationLinear:
            self.animatorCounter = [AnimatorLinear new];
            break;
        default:
            self.animatorCounter = [AnimatorLinear new];
            break;
    }
}

- (void)startAnimationWithDuration:(NSTimeInterval)duration
{
    [self.disPlaylink invalidate];
    self.disPlaylink = nil;
    
    if (duration == 0.0) {
        
        return;
    }
    
    self.progress = 0;
    self.maximumProgress = duration;
    self.lastUpdateTime = [NSDate timeIntervalSinceReferenceDate];
    
    self.disPlaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
    self.disPlaylink.frameInterval = 1;
    [self.disPlaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.disPlaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}

- (void)startAnimationWithDuration:(NSTimeInterval)duration
                    animationArray:(NSArray <id <AnimatorProtocol>> *)animators
                       updateBlock:(AnimationUpdateBlock)block
{
    self.updateBlock = block;
    self.animators = animators;
    [self startAnimationWithDuration:duration];
}

- (void)updateDisplay:(CADisplayLink *)link
{
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    self.progress += now - self.lastUpdateTime;
    self.lastUpdateTime = now;
    
    if (self.progress >= self.maximumProgress) {
        
        [self.disPlaylink invalidate];
        self.disPlaylink = nil;
        self.progress = self.maximumProgress;
    }
    
    CGFloat percent = self.progress / self.maximumProgress;
    CGFloat progressValue = [self.animatorCounter updateConvert:percent];
    
    for (id <AnimatorProtocol> animator in self.animators) {    // 多次轮询
        
        [animator startUpdateWithProgress:progressValue];
    }
    
    if (self.updateBlock) {
        
        self.updateBlock(progressValue);
    }
}

@end
