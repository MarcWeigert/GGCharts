//
//  GGAxis.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

struct GGAxis {
    GGLine line;
    CGFloat over;
    CGFloat sep;
};
typedef struct GGAxis GGAxis;

CG_INLINE GGAxis
GGAxisMake(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGFloat over, CGFloat sep) {
    GGAxis axis;
    axis.line = GGLineMake(x1, y1, x2, y2);
    axis.over = over;
    axis.sep = sep;
    return axis;
}

CG_INLINE GGAxis
GGAxisLineMake(GGLine line, CGFloat over, CGFloat sep) {
    GGAxis axis;
    axis.line = line;
    axis.over = over;
    axis.sep = sep;
    return axis;
}

CG_EXTERN void GGPathAddGGAxis(CGMutablePathRef ref, GGAxis axis);
