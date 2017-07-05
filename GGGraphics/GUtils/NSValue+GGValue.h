//
//  NSValue+GGValue.h
//  GGPlatform
//
//  Created by 黄舜 on 17/6/1.
//  Copyright © 2017年 Shanghai Suntime Information technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGChartGeometry.h"

#define GGValueMethod(type)                     \
                                                \
+ (NSValue *)valueWith##type:(type)ggStruct;    \
                                                \
- (type)type##Value;

#define GGValueForCGPathRef(type)               \
                                                \
- (CGMutablePathRef)GGValueFor##type##Ref;      \

@interface NSValue (GGValue)

GGValueMethod(GGLine)
GGValueMethod(GGArc)
GGValueMethod(GGSector)
GGValueMethod(GGAnnular)
GGValueMethod(GGSide)
GGValueMethod(GGAxis)
GGValueMethod(GGArrow)
GGValueMethod(GGGrid)
GGValueMethod(GGKShape)

@end
