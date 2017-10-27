//
//  GGPolygonRenderder.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGPolygonRenderder.h"

@implementation GGPolygonRenderder

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _strockColor.CGColor);
    
    CGMutablePathRef ref = CGPathCreateMutable();
    
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, _borderWidth > 0 ? _borderWidth : _width);
    _isCircle ? GGPathAddCircle(ref, GGCirclePointMake(_polygon.center, _polygon.radius)) : GGPathAddGGPolygon(ref, _polygon);
    CGContextAddPath(ctx, ref);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, _width);
    
    if (_fillColor) {
        
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, ref);
        CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
        CGContextFillPath(ctx);
    }
    
    CGPathRelease(ref);

    [self drawSplitPolygon:ctx];
    [self drawPieceLine:ctx];
    [self drawPolygonString:ctx];
}

/** 嵌套多边形 */
- (void)drawSplitPolygon:(CGContextRef)ctx
{
    if (_splitCount) {
        
        NSMutableArray * paths = [NSMutableArray array];
        CGFloat splitMove = _polygon.radius / _splitCount;
        GGPolygon polygon = GGPolygonCopy(_polygon);
        
        while (polygon.radius > 0) {
            
            CGMutablePathRef refSplit = CGPathCreateMutable();
            polygon.radius -= splitMove;
            _isCircle ? GGPathAddCircle(refSplit, GGCirclePointMake(polygon.center, polygon.radius)) : GGPathAddGGPolygon(refSplit, polygon);
            [paths addObject:(__bridge id)refSplit];
            CGPathRelease(refSplit);
        }
        
        CGContextBeginPath(ctx);
        CGMutablePathRef refSplit = CGPathCreateMutable();
        
        for (NSInteger i = 0; i < paths.count; i++) {
            
            CGPathAddPath(refSplit, NULL, (CGPathRef)paths[i]);
        }
        
        CGContextAddPath(ctx, refSplit);
        CGContextStrokePath(ctx);
        
        // 填充
        CGMutablePathRef refBorderPolygon = CGPathCreateMutable();
        _isCircle ? GGPathAddCircle(refBorderPolygon, GGCirclePointMake(_polygon.center, _polygon.radius)) : GGPathAddGGPolygon(refBorderPolygon, _polygon);
        [paths insertObject:(__bridge id)refBorderPolygon atIndex:0];
        CGPathRelease(refBorderPolygon);
        
        if (_singleFillColor) {         // 单填充
            
            CGContextBeginPath(ctx);
            CGMutablePathRef singleFillRef = CGPathCreateMutable();
            CGContextSetFillColorWithColor(ctx, _singleFillColor.CGColor);
            
            for (NSInteger i = 0; i < paths.count; i += 2) {
                
                if (i + 1 >= paths.count) { break; }
                
                CGPathAddPath(singleFillRef, NULL, (CGPathRef)paths[i]);
                CGPathAddPath(singleFillRef, NULL, (CGPathRef)paths[i + 1]);
                CGContextAddPath(ctx, singleFillRef);
                CGContextEOFillPath(ctx);
            }

            CGPathRelease(singleFillRef);
        }
        
        if (_doubleFillColor) {         // 双填充
            
            CGContextBeginPath(ctx);
            CGMutablePathRef doubleFillRef = CGPathCreateMutable();
            CGContextSetFillColorWithColor(ctx, _doubleFillColor.CGColor);
            
            for (NSInteger i = 1; i < paths.count; i += 2) {
                
                if (i + 1 >= paths.count) { break; }
                
                CGPathAddPath(doubleFillRef, NULL, (CGPathRef)paths[i]);
                CGPathAddPath(doubleFillRef, NULL, (CGPathRef)paths[i + 1]);
                CGContextAddPath(ctx, doubleFillRef);
                CGContextEOFillPath(ctx);
            }
            
            CGPathRelease(doubleFillRef);
        }
    }
}

/** 分割线 */
- (void)drawPieceLine:(CGContextRef)ctx
{
    if (_isPiece) {
        
        CGContextBeginPath(ctx);
        CGMutablePathRef ref = CGPathCreateMutable();
        
        for (NSInteger i = 0; i < _polygon.side; i++) {
            
            GGLine line = GGPolygonGetLine(_polygon, i);
            GGPathAddLine(ref, line);
        }
        
        CGContextAddPath(ctx, ref);
        CGPathRelease(ref);
        CGContextStrokePath(ctx);
    }
}

/** 绘制文字 */
- (void)drawPolygonString:(CGContextRef)ctx
{
    if (_stringColor == nil || _stringFont == nil) { return; }
    
    NSDictionary * dictionary = @{NSForegroundColorAttributeName : _stringColor, NSFontAttributeName : _stringFont};
    
    if (_titles.count) {
        
        NSInteger count = _polygon.side > _titles.count ? _titles.count : _polygon.side;
        UIGraphicsPushContext(ctx);
        
        for (NSInteger i = 0; i < count; i++) {
            
            NSString * string = _titles[i];
            CGSize size = [string sizeWithAttributes:dictionary];
            
            GGLine line = GGPolygonGetLine(_polygon, i);

            CGFloat a = _polygon.radius + size.width / 2 + _titleSpacing;
            CGFloat b = _polygon.radius + size.height / 2 + _titleSpacing;
            CGPoint point = CGPointMake(a * cos(GGXCircular(line)), b * sin(GGXCircular(line)));
            point.x += _polygon.center.x;
            point.y += _polygon.center.y;
            
            CGRect rect = CGRectMake(point.x - size.width / 2, point.y - size.height / 2, size.width, size.height);
            [string drawAtPoint:rect.origin withAttributes:dictionary];
        }
        
        UIGraphicsPopContext();
    }
}

@end
