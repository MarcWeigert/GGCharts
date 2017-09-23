//
//  GGArrow.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGArrow.h"

/**
 * 绘制箭头
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
