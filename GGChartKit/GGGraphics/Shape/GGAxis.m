//
//  GGAxis.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGAxis.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 绘制轴
 *
 * @param ref 路径结构
 * @param axis 绘制结构体
 */
void GGPathAddGGAxis(CGMutablePathRef ref, GGAxis axis)
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

/**
 * NSValue 扩展
 */
@implementation NSValue (GGValueGGAxisExtensions)

GGValueMethodImplementation(GGAxis);

@end

NS_ASSUME_NONNULL_END
