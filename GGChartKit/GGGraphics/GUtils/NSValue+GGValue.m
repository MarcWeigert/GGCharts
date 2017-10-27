//
//  NSValue+GGValue.m
//  GGPlatform
//
//  Created by _ | Durex on 17/6/1.
//  Copyright © 2017年 Shanghai Suntime Information technology co., LTD. All rights reserved.
//

#import "NSValue+GGValue.h"
#include <objc/runtime.h>

#define GGValueMethodImplementation(type)                           \
                                                                    \
+ (NSValue *)valueWith##type:(type)ggStruct                         \
{                                                                   \
    return [NSValue value:&ggStruct withObjCType:@encode(type)];    \
}                                                                   \
                                                                    \
- (type)type##Value                                                 \
{                                                                   \
    type ggStruct;                                                  \
    [self getValue:&ggStruct];                                      \
    return ggStruct;                                                \
}

#define GGValueForGGPathRefImplementation(type)                     \
                                                                    \
- (CGMutablePathRef)GGValueFor##type##Ref                           \
{                                                                   \
    CGMutablePathRef ref = CGPathCreateMutable();                   \
    GGPathAdd##type(ref, [self type##Value]);                       \
    return ref;                                                     \
}

@implementation NSValue (GGValue)

GGValueMethodImplementation(GGLine)
GGValueMethodImplementation(GGPolygon)
GGValueMethodImplementation(GGAxis)
GGValueMethodImplementation(GGArrow)
GGValueMethodImplementation(GGGrid)
GGValueMethodImplementation(GGKShape)

@end
