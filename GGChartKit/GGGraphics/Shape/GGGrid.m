//
//  GGGrid.m
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGGrid.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 绘制网格
 */
void GGPathAddGrid(CGMutablePathRef ref, GGGrid grid)
{
    CGFloat x = grid.rect.origin.x;
    CGFloat y = grid.rect.origin.y;
    
    NSInteger h_count = grid.y_dis == 0 ? 0 : CGRectGetHeight(grid.rect) / grid.y_dis + 1;    ///< 横线个数
    NSInteger v_count = grid.x_dis == 0 ? 0 : CGRectGetWidth(grid.rect) / grid.x_dis + 1;     ///< 纵线个数
    
    for (int i = 1; i < h_count; i++) {
        
        CGPoint start = CGPointMake(x, y + grid.y_dis * i);
        CGPoint end = CGPointMake(CGRectGetMaxX(grid.rect), y + grid.y_dis * i);
        
        CGPathMoveToPoint(ref, NULL, start.x, start.y);
        CGPathAddLineToPoint(ref, NULL, end.x, end.y);
    }
    
    for (int i = 1; i < v_count; i++) {
        
        CGPoint start = CGPointMake(x + grid.x_dis * i, y);
        CGPoint end = CGPointMake(x + grid.x_dis * i, CGRectGetMaxY(grid.rect));
        
        CGPathMoveToPoint(ref, NULL, start.x, start.y);
        CGPathAddLineToPoint(ref, NULL, end.x, end.y);
    }
    
    CGPathAddRect(ref, NULL, grid.rect);
}

/**
 * NSValue 扩展
 */
@implementation NSValue (GGValueGGGridExtensions)

GGValueMethodImplementation(GGGrid);

@end

NS_ASSUME_NONNULL_END
