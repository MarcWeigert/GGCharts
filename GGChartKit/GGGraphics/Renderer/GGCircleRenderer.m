//
//  GGCircle.m
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGCircleRenderer.h"

@implementation GGCircleRenderer

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _borderWidth);
    CGContextSetStrokeColorWithColor(ctx, _borderColor.CGColor);
    CGContextAddEllipseInRect(ctx, CGRectMake(_circle.center.x - _circle.radius, _circle.center.y - _circle.radius, _circle.radius * 2, _circle.radius * 2));
    
    if (_fillColor) {
        
        CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
        CGContextFillEllipseInRect(ctx, CGRectMake(_circle.center.x - _circle.radius, _circle.center.y - _circle.radius, _circle.radius * 2, _circle.radius * 2));
    }
    
    if (_gradentColors.count) {
        
        CGColorSpaceRef clearCircleRGB = CGColorSpaceCreateDeviceRGB();
        CGFloat rato[2] = {0.25, 0.75};
        CGGradientRef gradentRef = CGGradientCreateWithColors(clearCircleRGB, (__bridge CFArrayRef)_gradentColors, rato);
        CGContextDrawRadialGradient(ctx, gradentRef, _circle.center, 0, _circle.center, _circle.radius, kCGGradientDrawsBeforeStartLocation);
        CGGradientRelease(gradentRef);
    }
    
    CGContextStrokePath(ctx);
}

@end
