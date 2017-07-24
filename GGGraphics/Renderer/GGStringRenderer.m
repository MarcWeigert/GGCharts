//
//  GGStringRenderer.m
//  111
//
//  Created by _ | Durex on 2017/6/4.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGStringRenderer.h"
#import "Colors.h"

typedef enum : NSUInteger {
    AxisType,
    PathType,
    PointType,
} RendererType;

@interface GGStringRenderer ()

@property (nonatomic, strong) NSMutableDictionary * param;

@end

@implementation GGStringRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _param = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [_param setObject:font forKey:NSFontAttributeName];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [_param setObject:color forKey:NSForegroundColorAttributeName];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGPoint drawPoint = CGPointMake(_point.x + _offset.width, _point.y + _offset.height);
    CGSize size = [_string sizeWithAttributes:_param];
    drawPoint = CGPointMake(drawPoint.x + size.width * _offSetRatio.x, drawPoint.y + size.height * _offSetRatio.y);
    CGRect fillRect = CGRectMake(drawPoint.x, drawPoint.y, size.width, size.height);
    CGRect textRect = UIEdgeInsetsInsetRect(fillRect, UIEdgeInsetsMake(-_edgeInsets.top, -_edgeInsets.left, -_edgeInsets.bottom, -_edgeInsets.right));
    
    if (_fillColor) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:textRect cornerRadius:1];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
        CGContextFillPath(ctx);
        CGContextStrokePath(ctx);
    }
    
    UIGraphicsPushContext(ctx);
    [_string drawAtPoint:drawPoint withAttributes:_param];
    UIGraphicsPopContext();
}

@end
