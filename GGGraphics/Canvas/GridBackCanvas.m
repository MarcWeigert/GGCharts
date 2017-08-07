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
    
    GGGridRenderer * gridRenderer = [[GGGridRenderer alloc] init];
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
            axis.strFont = [axisAbstract axisFont];
            axis.offSetRatio = [axisAbstract textRatio];
            [self addRenderer:axis];
            
            if ([axisAbstract needShowGridLine]) {
                
                CGFloat len = GGLengthLine(axis.axis.line);
                NSInteger count = axis.axis.sep == 0 ? 0 : abs((int)(len / axis.axis.sep + 0.1)) + 1;   // 八社九入
                
                if (fabs(axis.axis.line.start.y - axis.axis.line.end.y) < .001f) {      // 平行于x轴
                    
                    for (int i = 0; i < count; i++) {
                        
                        CGPoint axis_pt = GGMoveStart(axis.axis.line, axis.axis.sep * i);
                        GGLine line = GGLineMake(axis_pt.x, CGRectGetMinY(frame), axis_pt.x, CGRectGetMaxY(frame));
                        [gridRenderer addLine:line];
                    }
                }
                
                if (fabs(axis.axis.line.start.x - axis.axis.line.end.x) < .001f) {      // 平行于y轴
                    
                    for (int i = 0; i < count; i++) {
                        
                        CGPoint axis_pt = GGMoveStart(axis.axis.line, axis.axis.sep * i);
                        GGLine line = GGLineMake(CGRectGetMinX(frame), axis_pt.y, CGRectGetMaxX(frame), axis_pt.y);
                        [gridRenderer addLine:line];
                    }
                }
            }
        }
    }
    
    [self setNeedsDisplay];
}

@end
