//
//  GGRect.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGRect.h"

void GGPathAddCGRect(CGMutablePathRef ref, CGRect rect)
{
    GGLine top = GGTopLineRect(rect);
    GGLine bottom = GGBottomLineRect(rect);
    GGLine left = GGLeftLineRect(rect);
    GGLine right = GGRightLineRect(rect);
    
    GGPathAddLine(ref, GGTopLineRect(rect));
    CGPathAddLineToPoint(ref, NULL, right.end.x, right.end.y);
    CGPathAddLineToPoint(ref, NULL, top.end.x, top.end.y);
    CGPathAddLineToPoint(ref, NULL, top.start.x, top.start.y);
    CGPathAddLineToPoint(ref, NULL, left.end.x, left.end.y);
    CGPathAddLineToPoint(ref, NULL, bottom.end.x, bottom.end.y);
    CGPathAddLineToPoint(ref, NULL, top.end.x, top.end.y);
}

void GGpathAddCGRects(CGMutablePathRef ref, CGRect * rects, size_t size)
{
    for (NSInteger i = 0; i < size; i++) {
        
        GGPathAddCGRect(ref, rects[i]);
    }
}

NSArray * GGPathRectsStretchAnimation(CGRect * rects, size_t size, CGFloat y)
{
    CGMutablePathRef start = CGPathCreateMutable();
    CGMutablePathRef end = CGPathCreateMutable();
    
    for (int i = 0; i < size; i++) {
        
        CGRect end_rect = rects[i];
        CGRect start_rect = CGRectMake(end_rect.origin.x, y, end_rect.size.width, 0);
        GGPathAddCGRect(start, start_rect);
        GGPathAddCGRect(end, end_rect);
    }
    
    NSArray * ary = @[(__bridge id)start, (__bridge id)end];
    CGPathRelease(start);
    CGPathRelease(end);
    
    return ary;
}
