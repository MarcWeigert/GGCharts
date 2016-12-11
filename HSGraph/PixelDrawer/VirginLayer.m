//
//  VirginLayer.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "VirginLayer.h"
#import "GraphLizard.h"

typedef void(^draw)(CGContextRef ctx);

@interface VirginLayer ()

@property (nonatomic) NSArray *drawBlockAry;

@end

@implementation VirginLayer

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.masksToBounds = YES;   // 剪裁是否可以超出范围
        
        self.contentsScale = [[UIScreen mainScreen] scale];   // 绘制的最低像素点
    }
    
    return self;
}

- (void)draw_updateFrame:(CGRect)frame lizard:(void (^) (GraphLizard *make))block;
{    
    GraphLizard *lizard = [[GraphLizard alloc] initWithFrame:frame];
    block(lizard);
    
    _drawBlockAry = lizard.blockAry;
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    // 关闭隐士动画
    [CATransaction setDisableActions:YES];
    
    for (draw block in _drawBlockAry) {
        
        block(ctx);
    }
}

@end
