//
//  CAAnimation+CGPathCategory.h
//  111
///Users/huangshun/HSCharts/GGGraphics
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GGChartGeometry.h"

CG_EXTERN void CGPathAddGGAxis(CGMutablePathRef ref, GGAxis axis);

CG_EXTERN void CGPathAddGGGrid(CGMutablePathRef ref, GGGrid grid);

CG_EXTERN void GGPathAddLine(CGMutablePathRef ref, GGLine line);

CG_EXTERN void GGPathAddCGRect(CGMutablePathRef ref, CGRect rect);
