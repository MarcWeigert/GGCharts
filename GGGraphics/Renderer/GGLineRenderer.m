//
//  GGLine.m
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGLineRenderer.h"

@implementation GGLineRenderer

AAPropSetFuncImplementation(GGLineRenderer, CGFloat, width);

AAPropSetFuncImplementation(GGLineRenderer, UIColor *, color);

AAPropSetFuncImplementation(GGLineRenderer, NSArray <NSValue *>*, pointAry);

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    for (int i = 0; i < _pointAry.count; i++) {
        
        CGPoint point = [_pointAry[i] CGPointValue];
        
        if (i == 0) {
            
            CGContextMoveToPoint(ctx, point.x, point.y);
        }
        else {
        
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }
    
    CGContextStrokePath(ctx);
}

@end
