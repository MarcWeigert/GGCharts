//
//  GGGride.m
//  111
//
//  Created by _ | Durex on 2017/5/22.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGGridRenderer.h"

@interface GGGridRenderer ()

@property (nonatomic, strong) NSMutableArray * aryLines;

@end

@implementation GGGridRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _dash = CGSizeZero;
        _isNeedRect = YES;
    }
    
    return self;
}

/**
 * 网格加线
 */
- (void)addLine:(GGLine)line
{
    [self.aryLines addObject:[NSValue valueWithGGLine:line]];
}
/**
 * 删除Line
 */
- (void)removeAllLine
{
    [self.aryLines removeAllObjects];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat x = _grid.rect.origin.x;
    CGFloat y = _grid.rect.origin.y;
    
    NSInteger h_count = _grid.y_dis == 0 ? 0 : CGRectGetHeight(_grid.rect) / _grid.y_dis + 1;    ///< 横线个数
    NSInteger v_count = _grid.x_dis == 0 ? 0 : CGRectGetWidth(_grid.rect) / _grid.x_dis + 1;     ///< 纵线个数
    
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    if (!CGSizeEqualToSize(_dash, CGSizeZero)) {
        
        CGFloat dashPattern[2] = {_dash.width, _dash.height};
        CGContextSetLineDash(ctx, 0, dashPattern, 2);
    }
    
    for (int i = 1; i < h_count; i++) {
        
        CGPoint start = CGPointMake(x, y + _grid.y_dis * i);
        CGPoint end = CGPointMake(CGRectGetMaxX(_grid.rect), y + _grid.y_dis * i);
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    for (int i = 1; i < v_count; i++) {
        
        CGPoint start = CGPointMake(x + _grid.x_dis * i, y);
        CGPoint end = CGPointMake(x + _grid.x_dis * i, CGRectGetMaxY(_grid.rect));
        
        CGContextMoveToPoint(ctx, start.x, start.y);
        CGContextAddLineToPoint(ctx, end.x, end.y);
    }
    
    if (_isNeedRect) {
        
        CGFloat inner = _width / 2;
        UIEdgeInsets rect_inner = UIEdgeInsetsMake(inner, inner, inner, inner);
        CGContextAddRect(ctx, UIEdgeInsetsInsetRect(_grid.rect, rect_inner));
    }
    
    [_aryLines enumerateObjectsUsingBlock:^(NSValue * obj, NSUInteger idx, BOOL * stop) {
        
        GGLine line = [obj GGLineValue];
        
        CGContextMoveToPoint(ctx, line.start.x, line.start.y);
        CGContextAddLineToPoint(ctx, line.end.x,line.end.y);
    }];
    
    CGContextStrokePath(ctx);
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, aryLines);

@end
