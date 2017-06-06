//
//  GGAxisRenderer.m
//  111
//
//  Created by _ | Durex on 2017/5/27.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGAxisRenderer.h"

@interface GGAxisRenderer ()

@property (nonatomic, strong) NSMutableDictionary * paramStr;

@end

@implementation GGAxisRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _showSep = YES;
        _showLine = YES;
        _showText = YES;
    }
    
    return self;
}

- (void)setStrColor:(UIColor *)strColor
{
    _strColor = strColor;
    [self.paramStr setObject:_strColor forKey:NSForegroundColorAttributeName];
}

- (void)setStrFont:(UIFont *)strFont
{
    _strFont = strFont;
    [self.paramStr setObject:_strFont forKey:NSFontAttributeName];
}

- (NSMutableDictionary *)paramStr
{
    if (!_paramStr) {
        
        _paramStr = [NSMutableDictionary dictionary];
    }
    
    return _paramStr;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    if (_showLine) {
        
        CGContextMoveToPoint(ctx, _axis.line.start.x + _lineOffSet.width, _axis.line.start.y + _lineOffSet.height);
        CGContextAddLineToPoint(ctx, _axis.line.end.x + _lineOffSet.width, _axis.line.end.y + _lineOffSet.height);
    }
    
    CGFloat len = GGLengthLine(_axis.line);
    NSInteger count = abs((int)(len / _axis.sep)) + 1;
    
    CGPoint from[count];
    CGPoint to[count];
    
    for (int i = 0; i < count; i++) {
        
        CGPoint axis_pt = GGMoveStart(_axis.line, _axis.sep * i);
        CGPoint over_pt = GGPerpendicularMake(_axis.line, axis_pt, _axis.over);
        
        from[i] = axis_pt;
        to[i] = over_pt;
    }
    
    if (_showSep) {
        
        for (int i = 0; i < count; i++) {
            
            CGPoint axis_pt = from[i];
            CGPoint over_pt = to[i];
            
            CGContextMoveToPoint(ctx, axis_pt.x, axis_pt.y);
            CGContextAddLineToPoint(ctx, over_pt.x, over_pt.y);
        }
    }
    
    CGContextStrokePath(ctx);
    
    if (_showText) {
        
        UIGraphicsPushContext(ctx);
        
        NSInteger drawCount = _aryString.count > count ? count : _aryString.count;
        
        for (NSInteger i = 0; i < drawCount; i++) {
            
            NSString * string = _aryString[i];
            CGPoint point = to[i];
            CGSize size = [string sizeWithAttributes:_paramStr];
            point = CGPointMake(point.x - size.width / 2 + _axis.sep / 2, point.y);
            [string drawAtPoint:point withAttributes:_paramStr];
        }
        
        UIGraphicsPopContext();
    }
}

@end
