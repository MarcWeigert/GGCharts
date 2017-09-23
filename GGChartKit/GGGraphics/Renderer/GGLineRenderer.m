//
//  GGLine.m
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGLineRenderer.h"

@implementation GGLineRenderer

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    CGFloat * dashPattern = malloc(sizeof(CGFloat) * _dashPattern.count);
    
    for (NSInteger i = 0; i < _dashPattern.count; i++) {
        
        dashPattern[i] = _dashPattern[i].floatValue;
    }
    
    CGContextSetLineDash(ctx, 0, dashPattern, _dashPattern.count);
    free(dashPattern);
    
    CGContextMoveToPoint(ctx, _line.start.x, _line.start.y);
    CGContextAddLineToPoint(ctx, _line.end.x,_line.end.y);

    CGContextStrokePath(ctx);
}

@end
