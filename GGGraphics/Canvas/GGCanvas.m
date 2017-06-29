//
//  GGCanvas.m
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGCanvas.h"
#import <UIKit/UIKit.h>

@interface GGCanvas ()

@property (nonatomic) NSMutableArray <id <GGRenderProtocol>>*aryRenderer;

@end

@implementation GGCanvas

/** 初始化 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.masksToBounds = YES;
        _aryRenderer = [NSMutableArray array];
    }
    
    return self;
}

/**
 * 增加一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)addRenderer:(id <GGRenderProtocol>)renderer
{
    [self.aryRenderer addObject:renderer];
}

/**
 * 删除一个绘图工具
 *
 * @param renderer 绘制工具
 */
- (void)removeRenderer:(id <GGRenderProtocol>)renderer
{
    [self.aryRenderer removeObject:renderer];
}

/**
 * 删除所有绘图工具
 */
- (void)removeAllRenderer
{
    [self.aryRenderer removeAllObjects];
}

/**
 * 继承 CALayer 
 *
 * @param ctx 上下文
 */
- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    for (id <GGRenderProtocol> renderer in _aryRenderer) {
        
        [renderer drawInContext:ctx];
    }
}

@end
