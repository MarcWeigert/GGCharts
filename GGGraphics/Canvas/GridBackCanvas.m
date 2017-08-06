//
//  GridBackCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GridBackCanvas.h"

@interface GridBackCanvas ()

@property (nonatomic, strong) GGGridRenderer * gridRenderer;

@end

@implementation GridBackCanvas

- (void)drawChart
{
    [super drawChart];
    [self removeAllRenderer];
    
    CGRect frame = UIEdgeInsetsInsetRect(CGRectMake(0, 0, self.gg_width, self.gg_height), [_gridDrawConfig insets]);
    CGFloat x_dis = CGRectGetWidth(frame) / [_gridDrawConfig horizontalCount];
    CGFloat y_dis = CGRectGetHeight(frame) / [_gridDrawConfig verticalCount];
    
    GGGridRenderer * gridRenderer = [[GGGridRenderer alloc] init];
    gridRenderer.grid = GGGridRectMake(frame, y_dis, x_dis);
    gridRenderer.width = [_gridDrawConfig gridLineWidth];
    gridRenderer.color = [_gridDrawConfig gridColor];
    gridRenderer.isNeedRect = NO;
    [self addRenderer:gridRenderer];
    
    for (NSInteger i = 0; i < [_gridDrawConfig axiss].count; i++) {
        
        id <AxisAbstract> axisAbstract = [_gridDrawConfig axiss][i];
        
        CGFloat s_x = frame.origin.x + CGRectGetWidth(frame) * [axisAbstract startLocalRatio].x;
        CGFloat s_y = frame.origin.y + CGRectGetHeight(frame) * [axisAbstract startLocalRatio].y;
        CGFloat e_x = frame.origin.x + CGRectGetWidth(frame) * [axisAbstract endLocalRatio].x;
        CGFloat e_y = frame.origin.y + CGRectGetHeight(frame) * [axisAbstract endLocalRatio].y;
        GGLine line = GGLineMake(s_x, s_y, e_x, e_y);
        NSInteger titleCount = [axisAbstract titles].count;
        CGFloat sep = GGLengthLine(line) / ([axisAbstract drawStringAxisCenter] ? titleCount : (titleCount - 1));
        NSArray * titles = [axisAbstract titles];
        
        if (titles.count > 0) {
            
            GGAxisRenderer * axis = [[GGAxisRenderer alloc] init];
            axis.width = [axisAbstract axisLineWidth];
            axis.color = [axisAbstract axisColor];
            axis.strColor = [axisAbstract axisColor];
            axis.drawAxisCenter = [axisAbstract drawStringAxisCenter];
            axis.showLine = YES;
            axis.showSep = YES;
            axis.axis = GGAxisMake(s_x, s_y, e_x, e_y, [axisAbstract over], sep);
            axis.aryString = titles;
            axis.offSetRatio = [axisAbstract textRatio];
            [self addRenderer:axis];
        }
    }
    
    [self setNeedsDisplay];
}

@end
