//
//  Brush.m
//  HCharts
//
//  Created by 黄舜 on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "PaintBrush.h"
#import <QuartzCore/QuartzCore.h>

@interface NSMutableArray (Block)

- (void)addDrawBlock:(void (^)(CGContextRef))block;

@end

@implementation NSMutableArray (Block)

- (void)addDrawBlock:(void (^)(CGContextRef))block
{
    [self addObject:block];
}

@end

@interface PaintBrush ()

@property (nonatomic) NSMutableArray *blockAry;

@end

@implementation PaintBrush

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _blockAry = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *)brushAry
{
    return [NSArray arrayWithArray:_blockAry];
}

- (void)drawEllipseWithPoint:(CGPoint)point radius:(CGFloat)radius
{
    UIColor *color = [_stockClr copy];
    UIColor *fillColor = [_fillClr copy];
    CGFloat width = _width;
    
    [_blockAry addDrawBlock:^(CGContextRef context) {
        
        CGFloat x = point.x - radius;
        CGFloat y = point.y - radius;
        CGRect rect = CGRectMake(x, y, radius * 2, radius * 2);
        
        CGContextSetLineWidth(context, width);
        
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGContextFillEllipseInRect(context, rect);
        
        CGContextStrokeEllipseInRect(context, rect);
        
        CGContextStrokePath(context);
    }];
}

/**  */
- (void)drawStart:(CGPoint)start end:(CGPoint)end
{
    UIColor *color = [_stockClr copy];
    CGFloat width = _width;
    
    [_blockAry addDrawBlock:^(CGContextRef context) {

        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGContextSetLineWidth(context, width);
        
        CGContextMoveToPoint(context, start.x, start.y);
        
        CGContextAddLineToPoint(context, end.x, end.y);
        
        CGContextStrokePath(context);
    }];
}

/**  */
- (void)drawTxt:(NSString *)txt at:(CGPoint)point
{
    UIFont *font = _font;
    UIColor *color = _stockClr;
    
    [_blockAry addDrawBlock:^(CGContextRef context) {
        
        UIGraphicsPushContext(context);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
        CGSize textSize = [txt sizeWithAttributes:dic];
        CGRect frame = CGRectMake(point.x, point.y, textSize.width, textSize.height);
        
        [txt drawInRect:frame withAttributes:dic];
        
        UIGraphicsPopContext();
    }];
}

/**  */
- (void)drawTxt:(NSString *)txt atLeft:(CGPoint)point
{
    UIFont *font = _font;
    UIColor *color = _stockClr;
    
    [_blockAry addDrawBlock:^(CGContextRef context) {
        
        UIGraphicsPushContext(context);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
        CGSize textSize = [txt sizeWithAttributes:dic];
        CGRect frame = CGRectMake(point.x - textSize.width, point.y - textSize.height / 2, textSize.width, textSize.height);
        
        [txt drawInRect:frame withAttributes:dic];
        
        UIGraphicsPopContext();
    }];
}

/**  */
- (void)drawTxt:(NSString *)txt atRight:(CGPoint)point
{
    UIFont *font = _font;
    UIColor *color = _stockClr;
    
    [_blockAry addDrawBlock:^(CGContextRef context) {
        
        UIGraphicsPushContext(context);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
        CGSize textSize = [txt sizeWithAttributes:dic];
        CGRect frame = CGRectMake(point.x, point.y - textSize.height / 2, textSize.width, textSize.height);
        
        [txt drawInRect:frame withAttributes:dic];
        
        UIGraphicsPopContext();
    }];
}

/**  */
- (void)drawTxt:(NSString *)txt atBottom:(CGPoint)point
{
    UIFont *font = _font;
    UIColor *color = _stockClr;
    
    [_blockAry addDrawBlock:^(CGContextRef context) {
        
        UIGraphicsPushContext(context);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
        CGSize textSize = [txt sizeWithAttributes:dic];
        CGRect frame = CGRectMake(point.x - textSize.width / 2, point.y, textSize.width, textSize.height);
        
        [txt drawInRect:frame withAttributes:dic];
        
        UIGraphicsPopContext();
    }];
}

@end
