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
    
    if (!CGSizeEqualToSize(_dash, CGSizeZero)) {
        
        CGFloat dashPattern[2] = {_dash.width, _dash.height};
        CGContextSetLineDash(ctx, 0, dashPattern, 2);
    }
    
    CGContextMoveToPoint(ctx, _line.start.x, _line.start.y);
    CGContextAddLineToPoint(ctx, _line.end.x,_line.end.y);

    CGContextStrokePath(ctx);
}

@end
