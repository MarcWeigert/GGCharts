//
//  GGRectRenderer.m
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGRectRenderer.h"

@implementation GGRectRenderer

/**
 * 绘制
 */
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _borderWidth);
    
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextAddRect(ctx, _rect);
    CGContextStrokePath(ctx);
    
    if (_fillColor) {
 
        CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
        CGContextFillRect(ctx, _rect);
        CGContextStrokePath(ctx);
    }
}

@end
