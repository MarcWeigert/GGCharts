//
//  GGArrow.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGArrow.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 绘制粗箭头
 *
 * @param ref 路径结构体
 * @param arrow 箭头结构体
 * @param barWidth 粗结构体
 */
void GGPathAddArrow(CGMutablePathRef ref, GGArrow arrow, CGFloat barWidth)
{
    CGPoint left = GGPerpendicularMake(arrow.line, arrow.line.end, arrow.side / 2);
    CGPoint right = GGPerpendicularMake(arrow.line, arrow.line.end, -arrow.side / 2);
    GGLine line = GGLineMoveEnd(arrow.line, arrow.side / 2);
    
    CGPathMoveToPoint(ref, NULL, line.end.x, line.end.y);
    CGPathAddLineToPoint(ref, NULL, left.x, left.y);
    CGPathAddLineToPoint(ref, NULL, right.x, right.y);
    
    CGPoint barLeftStart = GGPerpendicularMake(arrow.line, arrow.line.start, barWidth / 2);
    CGPoint barRightStart = GGPerpendicularMake(arrow.line, arrow.line.start, -barWidth / 2);
    CGPoint barLeftEnd = GGPerpendicularMake(arrow.line, arrow.line.end, barWidth / 2);
    CGPoint barRightEnd = GGPerpendicularMake(arrow.line, arrow.line.end, -barWidth / 2);
    
    CGPathMoveToPoint(ref, NULL, barLeftStart.x, barLeftStart.y);
    CGPathAddLineToPoint(ref, NULL, barRightStart.x, barRightStart.y);
    CGPathAddLineToPoint(ref, NULL, barRightEnd.x, barRightEnd.y);
    CGPathAddLineToPoint(ref, NULL, barLeftEnd.x, barLeftEnd.y);
}

/**
 * NSValue 扩展
 */
@implementation NSValue (GGValueGGArrowExtensions)

GGValueMethodImplementation(GGArrow);

@end

NS_ASSUME_NONNULL_END
