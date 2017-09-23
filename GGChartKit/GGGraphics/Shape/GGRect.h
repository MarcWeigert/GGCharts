//
//  GGRect.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

CG_INLINE CGRect
GGLineDownRectMake(CGPoint start, CGPoint end, CGFloat width)
{
    CGPoint ben = start.y > end.y ? end : start;
    CGRect rect;
    rect.origin = CGPointMake(ben.x - width / 2, ben.y);
    rect.size = CGSizeMake(width, fabs(start.y - end.y));
    return rect;
}

CG_INLINE CGRect
GGLineSideRect(CGPoint start, CGPoint end, CGFloat width)
{
    CGRect rect;
    rect.origin = CGPointMake(start.x - width / 2, start.y);
    rect.size = CGSizeMake(width, start.y - end.y);
    return rect;
}

CG_EXTERN void GGPathAddCGRect(CGMutablePathRef ref, CGRect rect);

CG_EXTERN void GGpathAddCGRects(CGMutablePathRef ref, CGRect * rects, size_t size);

CG_EXTERN NSArray * GGPathRectsStretchAnimation(CGRect * rects, size_t size, CGFloat y);
