//
//  GGGride.m
//  111
//
//  Created by _ | Durex on 2017/5/22.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGGridRenderer.h"

@implementation GGGridRenderer

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat x = _grid.rect.origin.x;
    CGFloat y = _grid.rect.origin.y;
    
    NSInteger h_count = CGRectGetHeight(_grid.rect) / _grid.y_dis;    ///< 横线个数
    NSInteger v_count = CGRectGetWidth(_grid.rect) / _grid.x_dis;     ///< 纵线个数
    
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    if (!CGSizeEqualToSize(_dash, CGSizeZero)) {
        
        CGFloat dashPattern[2] = {_dash.width, _dash.height};
        CGContextSetLineDash(ctx, 0, dashPattern, 2);
    }
    
    for (int i = 1; i < h_count + 1; i++) {
    
        CGPoint start = CGPointMake(x, y + _grid.y_dis * i);
        CGPoint end = CGPointMake(CGRectGetMaxX(_grid.rect), y + _grid.y_dis * i);
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    for (int i = 1; i < v_count + 1; i++) {
        
        CGPoint start = CGPointMake(x + _grid.x_dis * i, y);
        CGPoint end = CGPointMake(x + _grid.x_dis * i, CGRectGetMaxY(_grid.rect));
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    CGContextAddRect(ctx, _grid.rect);
    CGContextStrokePath(ctx);
}

@end
