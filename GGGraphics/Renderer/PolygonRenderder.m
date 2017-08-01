//
//  PolygonRenderder.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PolygonRenderder.h"
#import "CGPathCategory.h"

@implementation PolygonRenderder

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _strockColor.CGColor);
    
    CGMutablePathRef ref = CGPathCreateMutable();
    
    CGContextBeginPath(ctx);
    GGPathAddGGPolygon(ref, _polygon);
    CGContextAddPath(ctx, ref);
    CGContextStrokePath(ctx);
    
    if (_fillColor) {
        
        CGContextBeginPath(ctx);
        CGContextAddPath(ctx, ref);
        CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
        CGContextFillPath(ctx);
    }
    
    CGPathRelease(ref);

    [self drawSplitPolygon:ctx];
    [self drawPieceLine:ctx];
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
            GGPathAddGGPolygon(refSplit, polygon);
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
        GGPathAddGGPolygon(refBorderPolygon, _polygon);
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
        
        CGFloat width = 10;
        CGFloat high = 10;
        
        
        CGContextBeginPath(ctx);
        CGMutablePathRef ref = CGPathCreateMutable();
        
        for (NSInteger i = 0; i < _polygon.side; i++) {
            
            GGLine line = GGPolygonGetLine(_polygon, i);
            line = GGLineMoveEnd(line, 10.0f);
            GGPathAddLine(ref, line);
            
            CGFloat cir_x = GGXCircular(line);
            CGFloat tmp_x = fabs(fabs(cir_x) - M_PI_2);
            CGFloat baseWidth = tmp_x < 0.001f ? 1.0f : tan(cir_x);
            
            CGFloat cir_y = GGXCircular(line);
            CGFloat tmp_y = fabs(fabs(cir_y) - M_PI_2);
            CGFloat baseHight = tmp_y < 0.001f ? 1.0f : tan(cir_y);
            

            CGPoint start = line.end;
            CGPoint end1 = CGPointMake(baseWidth * width + start.x, start.y);
            CGPoint end2 = CGPointMake(start.x, start.y + baseHight * high);
            
            CGPathMoveToPoint(ref, NULL, start.x, start.y);
            CGPathAddLineToPoint(ref, NULL, end1.x, end1.y);
            
            CGPathMoveToPoint(ref, NULL, start.x, start.y);
            CGPathAddLineToPoint(ref, NULL, end2.x, end2.y);
        }
        
        CGContextAddPath(ctx, ref);
        CGPathRelease(ref);
        CGContextStrokePath(ctx);
    }
    
    
    
    if (_titles.count) {
    
        
    }
}

@end
