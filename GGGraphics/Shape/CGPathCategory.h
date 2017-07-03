//
//  CAAnimation+CGPathCategory.h
//  111
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GGChartGeometry.h"

CG_EXTERN void GGPathAddGGAxis(CGMutablePathRef ref, GGAxis axis);

CG_EXTERN void GGPathAddLine(CGMutablePathRef ref, GGLine line);

CG_EXTERN void GGPathAddCGRect(CGMutablePathRef ref, CGRect rect);

CG_EXTERN void GGpathAddCGRects(CGMutablePathRef ref, CGRect * rects, size_t size);

CG_EXTERN void GGPathAddCircle(CGMutablePathRef ref, GGCircle circle);

CG_EXTERN void GGPathAddCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, size_t count);

CG_EXTERN void GGPathAddRangeCircles(CGMutablePathRef ref, CGPoint *center, CGFloat radius, int from, int to);

CG_EXTERN void GGPathAddAnnular(CGMutablePathRef ref, GGAnnular annular);

CG_EXTERN void GGPathAddSector(CGMutablePathRef ref, GGSector sector);

CG_EXTERN NSArray * GGPathAnimationSectorEject(GGSector sector, long frame, CGFloat outSide);

CG_EXTERN NSArray * GGPathAnimationArrayFor(GGSector sector, long frame);

CG_EXTERN NSArray * GGPathAnnularAnimationArrayFor(GGAnnular annular, long frame);

CG_EXTERN NSArray * GGPathRectsStretchAnimation(CGRect * rects, size_t size, CGFloat y);

CG_EXTERN NSArray * GGPathLinesStretchAnimation(CGPoint * points, size_t size, CGFloat y);

CG_EXTERN NSArray * GGPathCirclesStretchAnimation(CGPoint * points, CGFloat radius, size_t size, CGFloat y);
