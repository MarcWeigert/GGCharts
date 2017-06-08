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

- (void)dealloc
{
    CGPathRelease(_oldRef);
}

- (void)startShapeAnimation:(NSTimeInterval)duration
{
    if (_oldRef) {
        
        CABasicAnimation * shapeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        shapeAnimation.fromValue = (__bridge id)_oldRef;
        shapeAnimation.toValue = (__bridge id)self.path;
        shapeAnimation.duration = duration;
        [self addAnimation:shapeAnimation forKey:@"shapeAnimation"];
    }
}

@end
