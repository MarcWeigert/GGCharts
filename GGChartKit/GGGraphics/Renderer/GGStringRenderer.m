//
//  GGStringRenderer.m
//  111
//
//  Created by _ | Durex on 2017/6/4.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGStringRenderer.h"

const GGSizeRange GGSizeRangeZero = {0.0f, 0.0f};

@interface GGStringRenderer ()

/**
 * 绘制文字参数
 */
@property (nonatomic, strong) NSMutableDictionary * param;

@end

@implementation GGStringRenderer

/**
 * 初始化
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _param = [NSMutableDictionary dictionary];
        _radius = 1.0f;
        
        _horizontalRange = GGSizeRangeZero;
        _verticalRange = GGSizeRangeZero;
    }
    
    return self;
}

/**
 * 绘制文字字体
 */
- (void)setFont:(UIFont *)font
{
    _font = font;
    [_param setObject:font forKey:NSFontAttributeName];
}

/**
 * 绘制文字颜色
 */
- (void)setColor:(UIColor *)color
{
    _color = color;
    [_param setObject:color forKey:NSForegroundColorAttributeName];
}

/**
 * 绘制方法
 */
- (void)drawInContext:(CGContextRef)ctx
{
    CGPoint ratioPoint = RATIO_POINT_CONVERT(_offSetRatio);
    CGPoint drawPoint = CGPointMake(_point.x + _offset.width, _point.y + _offset.height);
    CGSize size = [_string sizeWithAttributes:_param];
    size = CGSizeMake(size.width + _edgeInsets.left + _edgeInsets.right, size.height + _edgeInsets.top + _edgeInsets.bottom);
    CGPoint origin = CGPointMake(drawPoint.x + size.width * ratioPoint.x, drawPoint.y + size.height * ratioPoint.y);
    
    CGRect fillRect = CGRectZero;
    fillRect.origin = origin;
    fillRect.size = size;
    
    // 横显示区域
    if (!GGSizeRangeEqual(_horizontalRange, GGSizeRangeZero)) {
        
        if (_horizontalRange.max < CGRectGetMaxX(fillRect)) {
            
            fillRect.origin = CGPointMake(_horizontalRange.max - size.width, origin.y);
        }
        
        if (_horizontalRange.min > CGRectGetMinX(fillRect)) {
            
            fillRect.origin = CGPointMake(_horizontalRange.min, origin.y);
        }
    }
    
    // 纵显示区域
    if (!GGSizeRangeEqual(_verticalRange, GGSizeRangeZero)) {
        
        if (_verticalRange.max < CGRectGetMaxY(fillRect)) {
            
            fillRect.origin = CGPointMake(origin.x, _verticalRange.max - size.height);
        }
        
        if (_verticalRange.min > CGRectGetMinY(fillRect)) {
            
            fillRect.origin = CGPointMake(origin.x, _verticalRange.min);
        }
    }
    
    CGRect textRect = UIEdgeInsetsInsetRect(fillRect, _edgeInsets);
    
    if (_fillColor) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:_radius];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
        CGContextFillPath(ctx);
        CGContextStrokePath(ctx);
    }
    
    UIGraphicsPushContext(ctx);
    [_string drawAtPoint:textRect.origin withAttributes:_param];
    UIGraphicsPopContext();
}

@end
