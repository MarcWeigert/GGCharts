//
//  GGShapeCanvas.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGShapeCanvas.h"

@interface GGShapeCanvas ()

@property (nonatomic) CGPathRef oldRef;

@property (nonatomic, strong) NSMutableDictionary * animationDictonary;

@end

@implementation GGShapeCanvas

- (void)setOldRef:(CGPathRef)oldRef
{
    if (_oldRef) {
        
        CGPathRelease(_oldRef);
    }
    
    _oldRef = oldRef;
    CGPathRetain(_oldRef);
}

- (void)setPath:(CGPathRef)path
{
    if (self.path) { self.oldRef = self.path; }
    
    [super setPath:path];
}

- (NSMutableDictionary *)animationDictonary
{
    if (!_animationDictonary) {
        
        _animationDictonary = [NSMutableDictionary dictionary];
    }
    
    return _animationDictonary;
}

- (void)dealloc
{
    CGPathRelease(_oldRef);
}

//- (void)startShapeAnimation:(NSTimeInterval)duration
//{
//    if (_oldRef) {
//        
//        CABasicAnimation * shapeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//        shapeAnimation.fromValue = (__bridge id)_oldRef;
//        shapeAnimation.toValue = (__bridge id)self.path;
//        shapeAnimation.duration = duration;
//        [self addAnimation:shapeAnimation forKey:@"shapeAnimation"];
//    }
//}

- (CAAnimation *)animationForName:(NSString *)name
{
    return [self.animationDictonary valueForKey:name];
}

- (void)startAnimation:(NSString *)name duration:(NSTimeInterval)duration
{
    if ([name isEqualToString:@"oldPush"]) {
        
        if (_oldRef) {
            
            CABasicAnimation * shapeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            shapeAnimation.fromValue = (__bridge id)_oldRef;
            shapeAnimation.toValue = (__bridge id)self.path;
            shapeAnimation.duration = duration;
            [self addAnimation:shapeAnimation forKey:@"shapeAnimation"];
        }
    }
    
    CAAnimation * animation = [self.animationDictonary objectForKey:name];
    
    if (animation) {
        
        animation.duration = duration;
        [self addAnimation:animation forKey:name];
    }
}

- (CAKeyframeAnimation *)registerKeyAnimation:(NSString *)key name:(NSString *)name values:(NSArray *)values
{
    CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:key];
    keyAnimation.values = values;
    [self.animationDictonary setObject:keyAnimation forKey:name];
    return keyAnimation;
}

@end
