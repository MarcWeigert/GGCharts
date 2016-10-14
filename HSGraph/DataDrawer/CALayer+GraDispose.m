//
//  NSObject+GraDispose.m
//  HCharts
//
//  Created by 黄舜 on 16/6/16.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "CALayer+GraDispose.h"
#import "GraphSpider.h"
#import "objc/runtime.h"

@implementation CALayer (GraDispose)

#pragma mark - Public 

- (void)setMax:(CGFloat)max
{
    objc_setAssociatedObject(self, @selector(max), @(max), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)max
{
    return [(NSNumber *)objc_getAssociatedObject(self, @selector(max)) floatValue];
}

- (void)setMin:(CGFloat)min
{
    objc_setAssociatedObject(self, @selector(min), @(min), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)min
{
    return [(NSNumber *)objc_getAssociatedObject(self, @selector(min)) floatValue];
}

#pragma mark - 绘制管理类

- (void)addAnimationForSubLayers:(CAAnimation *)ani
{
    for (CALayer *layer in self.sublayers) {
        
        [layer addAnimation:ani forKey:nil];
    }
}

/** 子层加动画 */
- (void)addAnimation:(CAAnimation *)ani layerIndex:(NSInteger)index
{
    if (index >= self.sublayers.count) return;
    
    CALayer *layer = self.sublayers[index];
    
    [layer addAnimation:ani forKey:nil];
}

- (NSArray *)draw_makeSpiders:(void (^) (GraphSpider *make))block
{
    GraphSpider *spider = [[GraphSpider alloc] initWithLayer:self];
    
    block(spider);
    
    return [spider stockShapeLayer];
}

- (NSArray *)draw_updateSpiders:(void (^) (GraphSpider *make))block
{
    GraphSpider *spider = [[GraphSpider alloc] initWithLayer:self];
    
    spider.updateLayers = YES;
    
    block(spider);
    
    return [spider stockShapeLayer];
}

- (NSArray *)draw_remakeSpiders:(void (^) (GraphSpider *make))block
{
    GraphSpider *spider = [[GraphSpider alloc] initWithLayer:self];
    
    spider.removeLayers = YES;
    
    block(spider);
    
    return [spider stockShapeLayer];
}

@end
