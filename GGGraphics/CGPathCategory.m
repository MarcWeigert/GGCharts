//
//  CAAnimation+CGPathCategory.m
//  111
//
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "CGPathCategory.h"

void CGPathAddGGAxis(CGMutablePathRef ref, GGAxis axis)
{
    CGPathMoveToPoint(ref, NULL, axis.line.start.x, axis.line.start.y);
    CGPathAddLineToPoint(ref, NULL, axis.line.end.x, axis.line.end.y);
    
    CGFloat len = GGLengthLine(axis.line);
    NSInteger count = abs((int)(len / axis.sep)) + 1;
    
    for (int i = 0; i < count; i++) {
        
        CGPoint axis_pt = GGMoveStart(axis.line, axis.sep * i);
        CGPoint over_pt = GGPerpendicularMake(axis.line, axis_pt, axis.over);
        
        CGPathMoveToPoint(ref, NULL, axis_pt.x, axis_pt.y);
        CGPathAddLineToPoint(ref, NULL, over_pt.x, over_pt.y);
    }
}

void CGPathAddGGGrid(CGMutablePathRef ref, GGGrid grid)
{
    CGPoint ** result = GGGridPointAryMake(grid);
    
    for (int i = 0; i < grid.horizontal; i++) {
        
        CGPoint start = result[i][0];
        CGPoint end = result[i][grid.vertical - 1];
        
        CGPathMoveToPoint(ref, NULL, start.x, start.y);
        CGPathAddLineToPoint(ref, NULL, end.x, end.y);
    }
    
    for (int i = 0; i < grid.vertical; i++) {
        
        CGPoint start = result[0][i];
        CGPoint end = result[grid.vertical - 1][i];
        
        CGPathMoveToPoint(ref, NULL, start.x, start.y);
        CGPathAddLineToPoint(ref, NULL, end.x, end.y);
    }
    
    for (int i = 0; i < grid.horizontal; i++) {
        
        free(result[i]);
    }
    
    free(result);
}
