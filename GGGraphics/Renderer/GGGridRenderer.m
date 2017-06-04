//
//  GGGride.m
//  111
//
//  Created by _ | Durex on 2017/5/22.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGGridRenderer.h"

@implementation GGGridRenderer

AAPropSetFuncImplementation(GGGridRenderer, CGFloat, width);

AAPropSetFuncImplementation(GGGridRenderer, UIColor *, color);

AAPropSetFuncImplementation(GGGridRenderer, GGGrid, grid);

- (void)drawInContext:(CGContextRef)ctx
{    
    CGPoint ** result = GGGridPointAryMake(_grid);
    
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    NSInteger xcount = _grid.horizontal;
    NSInteger ycount = _grid.vertical;
    
    if (_x_count) {
        
        xcount = _x_count.integerValue > _grid.horizontal ? xcount : _x_count.integerValue;
    }
    
    if (_y_count ) {
        
        ycount = _y_count.integerValue > _grid.vertical ? ycount : _y_count.integerValue;
    }
    
    for (int i = 0; i < ycount; i++) {
    
        CGPoint start = result[i][0];
        CGPoint end = result[i][_grid.vertical - 1];
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    for (int i = 0; i < xcount; i++) {
        
        CGPoint start = result[0][i];
        CGPoint end = result[_grid.vertical - 1][i];
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    CGContextStrokePath(ctx);
    
    for (int i = 0; i < _grid.horizontal; i++) {
        
        free(result[i]);
    }
    
    free(result);
}

@end
