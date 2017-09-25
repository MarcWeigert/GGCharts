//
//  DrawHeader.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/16.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef DrawHeader_h
#define DrawHeader_h

/**
 * 懒加载
 */
#define GGLazyGetMethod(type, attribute)            \
- (type *)attribute                                 \
{                                                   \
    if (!_##attribute) {                            \
        _##attribute = [[type alloc] init];         \
    }                                               \
    return _##attribute;                            \
}

/**
 * Value
 */
#define GGValueMethod(type)                     \
                                                \
+ (NSValue *)valueWith##type:(type)ggStruct;    \
                                                \
- (type)type##Value;

#define GGValueMethodImplementation(type)                               \
                                                                        \
+ (NSValue *)valueWith##type:(type)ggStruct                             \
{                                                                       \
    return [NSValue value:&ggStruct withObjCType:@encode(type)];        \
}                                                                       \
                                                                        \
- (type)type##Value                                                 \
{                                                                   \
    type ggStruct;                                                  \
    [self getValue:&ggStruct];                                      \
    return ggStruct;                                                \
}

/**
 * Color
 */
#define RGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

#define C_HEXA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0x0000FF)) / 255.0 \
alpha:alphaValue]

#define C_HEX(rgbValue) C_HEXA(rgbValue, 1.0)

/**
 * 柱状图关联key
 */
static const void * barUpLayer = @"barUpLayer";
static const void * barDownLayer = @"barDownLayer";
static const void * barNumberArray = @"barNumberArray";
static const void * barStringLayer = @"barStringLayer";

/**
 * 折线图关联key
 */
static const void * lineLayer = @"lineLayer";
static const void * lineShapeLayer = @"lineShapeLayer";
static const void * lineFillLayer = @"lineFillLayer";
static const void * lineStringLayer = @"lineStringLayer";
static const void * lineNumberArray = @"lineNumberArray";

/**
 * 扇形图关联key
 */
static const void * pieShapeLayerArray = @"pieShapeLayerArray";
static const void * pieBaseShapeLayer = @"pieBaseShapeLayer";

static const void * pieOutSideLayerArray = @"pieInnerLayerArray";
static const void * pieOutSideNumberArray = @"pieOutSideNumberArray";
static const void * pieOutSideLayer = @"pieOutSideLayer";

static const void * pieInnerNumberArray = @"pieInnerNumberArray";
static const void * pieInnerLayer = @"pieInnerLayer";

/**
 * 关联对象(强引用)
 */
#define SET_ASSOCIATED_ASSIGN(obj, key, value)      \
    objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_ASSIGN)

/**
 * 关联对象(弱引用)
 */
#define SET_ASSOCIATED_RETAIN(obj, key, value)      \
    objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN)

/**
 * 获取关联对象
 */
#define GET_ASSOCIATED(obj, key)                    \
    objc_getAssociatedObject(obj, key)

/**
 * 输出日志
 */
#ifdef DEBUG
    #define GGLog(s, ...) NSLog(@"%@%s %@", @"[GG_CHART_LOG]", __PRETTY_FUNCTION__, [NSString stringWithFormat:s,##__VA_ARGS__])
#else
    #define GGLog(s, ...) [NSString stringWithFormat:s,##__VA_ARGS__]
#endif

#endif /* DrawHeader_h */
