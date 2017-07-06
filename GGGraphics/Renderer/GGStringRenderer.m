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
    CGRect fillRect = CGRectMake(drawPoint.x, drawPoint.y, size.width + _edgeInsets.left + _edgeInsets.right, size.height + _edgeInsets.bottom + _edgeInsets.top);
    CGRect textRect = UIEdgeInsetsInsetRect(fillRect, _edgeInsets);
    
    if (_fillColor) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:1];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, RGB(235, 235, 235).CGColor);
        CGContextFillPath(ctx);
        CGContextStrokePath(ctx);
    }
    
    UIGraphicsPushContext(ctx);
    [_string drawAtPoint:textRect.origin withAttributes:_param];
    UIGraphicsPopContext();
}

@end
