//
//  SawBoard.m
//  HCharts
//
//  Created by 黄舜 on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "BoardLayer.h"
#import "PaintBrush.h"

typedef void(^draw)(CGContextRef ctx);

@interface BoardLayer ()

@property (nonatomic) PaintBrush *brush;

@end

@implementation BoardLayer

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.masksToBounds = YES;   // 剪裁是否可以超出范围
        
        self.contentsScale = [[UIScreen mainScreen] scale];   // 绘制的最低像素点
    }
    
    return self;
}

- (void)drawWithBrush:(PaintBrush *)brush
{
    _brush = brush;
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    for (draw block in _brush.brushAry) {
        
        block(ctx);
    }
}

@end
