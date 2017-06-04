//
//  GGAxisRenderer.m
//  111
//
//  Created by _ | Durex on 2017/5/27.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGAxisRenderer.h"

@implementation GGAxisRenderer

AAPropSetFuncImplementation(GGAxisRenderer, GGAxis, axis);

AAPropSetFuncImplementation(GGAxisRenderer, CGFloat, width);

AAPropSetFuncImplementation(GGAxisRenderer, UIColor *, color);

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    CGContextMoveToPoint(ctx, _axis.line.start.x, _axis.line.start.y);
    CGContextAddLineToPoint(ctx, _axis.line.end.x, _axis.line.end.y);
    
    CGFloat len = GGLengthLine(_axis.line);
    NSInteger count = abs((int)(len / _axis.sep)) + 1;
    
    for (int i = 0; i < count; i++) {
        
        CGPoint axis_pt = GGMoveStart(_axis.line, _axis.sep * i);
        CGPoint over_pt = GGPerpendicularMake(_axis.line, axis_pt, _axis.over);
        
        CGContextMoveToPoint(ctx, axis_pt.x, axis_pt.y);
        CGContextAddLineToPoint(ctx, over_pt.x, over_pt.y);
    }
    
    CGContextStrokePath(ctx);
}

@end
