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
    CGFloat h = _grid.rect.size.width / (_grid.horizontal - 1);
    CGFloat v = _grid.rect.size.height / (_grid.vertical - 1);
    
    NSInteger xcount = _grid.horizontal;
    NSInteger ycount = _grid.vertical;
    
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    if (!CGSizeEqualToSize(_dash, CGSizeZero)) {
        
        CGFloat dashPattern[2] = {_dash.width, _dash.height};
        CGContextSetLineDash(ctx, 0, dashPattern, 2);
    }
    
    if (_x_count) {
        
        xcount = _x_count.integerValue > _grid.horizontal ? xcount : _x_count.integerValue;
    }
    
    if (_y_count ) {
        
        ycount = _y_count.integerValue > _grid.vertical ? ycount : _y_count.integerValue;
    }
    
    for (int i = 0; i < ycount; i++) {
    
        CGPoint start = CGPointMake(x, y + h * i);
        CGPoint end = CGPointMake(CGRectGetMaxX(_grid.rect), y + h * i);
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    for (int i = 0; i < xcount; i++) {
        
        CGPoint start = CGPointMake(x + v * i, y);
        CGPoint end = CGPointMake(x + v * i, CGRectGetMaxY(_grid.rect));
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    
    
    CGContextStrokePath(ctx);
}

@end
