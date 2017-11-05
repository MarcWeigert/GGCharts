//
//  GGGraphicsConstants.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 柱状图动画枚举
 */
typedef enum : NSUInteger {
    BarAnimationRiseType,
    BarAnimationChangeType,
} BarAnimationsType;

/**
 * 折线图动画枚举
 */
typedef enum : NSUInteger {
    LineAnimationRiseType,
    LineAnimationStrokeType,
    LineAnimationChangeType,
} LineAnimationsType;

/**
 * 扇形图动画枚举
 */
typedef enum : NSUInteger {
    RotationAnimation,
    EjectAnimation,
    ChangeAnimation,
} PieAnimationType;

/**
 * 渐变曲线枚举
 */
typedef enum : NSUInteger {
    GradientX,
    GradientY,
} GradientCurve;

/**
 * 纯小数(-1 <= x <= 1)
 */
#define PURE_DECIMAL(x)     (x - 1 > 0 ? 1 : (x - 1 < -2 ? -1 : x))

/**
 * 偏移比例转换
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
#define RATIO_POINT_CONVERT(p)              \
    CGPointMake((-1 + PURE_DECIMAL(p.x)) / 2, (-1 + PURE_DECIMAL(p.y)) / 2)

/**
 * 文字偏移比例
 */
CG_EXTERN CGPoint const GGRatioTopLeft;
CG_EXTERN CGPoint const GGRatioTopCenter;
CG_EXTERN CGPoint const GGRatioTopRight;

CG_EXTERN CGPoint const GGRatioBottomLeft;
CG_EXTERN CGPoint const GGRatioBottomCenter;
CG_EXTERN CGPoint const GGRatioBottomRight;

CG_EXTERN CGPoint const GGRatioCenterLeft;
CG_EXTERN CGPoint const GGRatioCenter;
CG_EXTERN CGPoint const GGRatioCenterRight;

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
 * PathKeyFrameAnimations
 */
#define GGPathKeyFrameAnimation(layer, name, dur, frames)                                      \
    CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];  \
    pathAnimation.duration = dur;                                                              \
    pathAnimation.values = frames;                                                             \
    pathAnimation.fillMode = kCAFillModeForwards;                                              \
    pathAnimation.removedOnCompletion = NO;                                                    \
    [layer addAnimation:pathAnimation forKey:name];                                            \

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
 * 颜色
 */
#define __RGB_RED           RGB(180, 65, 56)
#define __RGB_GREEN         RGB(54, 70, 85)
#define __RGB_GRAY          RGB(107, 112, 114)
#define __RGB_BLUE          RGB(112, 159, 167)
#define __RGB_BLACK         RGB(45, 52, 59)
#define __RGB_ORIGE         RGB(201, 134, 107)
#define __RGB_CYAN          RGB(157, 198, 176)
#define __RGB_PINK          RGB(189, 162, 154)

/**
 * float 格式化字符串
 * A : 格式化位数
 */
#define DECIMAL_FLOAT(A)  [NSString stringWithFormat:@"%%.%zdf", (A)]

/**
 * 格式化字符串
 * A : float 数值
 * B : 格式化位数
 */
#define FLOAT_STR(A, B) [NSString stringWithFormat:DECIMAL_FLOAT(B), (A)]

/**
 * 格式化字符串
 * A : 数值
 * B : 格式化位数
 * C : 格式化尾部字符
 */
#define FLT_END_STR(A, B, C) [NSString stringWithFormat:@"%@%@", (FLOAT_STR(A, B)), (C)]

/**
 * NSIntger 格式化字符串
 * A : 格式化位数
 */
#define DECIMAL_INT(A)  [NSString stringWithFormat:@"%%.%zdzd", (A)]

/**
 * 整形格式化字符串
 * A : NSIntger 数值
 */
#define INT_STR(A) [NSString stringWithFormat:@"%zd", (A)]

/**
 * 格式化字符串
 * A : NSIntger 数值
 * B : 格式化位数
 */
#define INT_STR_DML(A, B) [NSString stringWithFormat:DECIMAL_INT(B), (A)]

/**
 * 适配
 */
#define GG_SIZE_CONVERT(A)  ([UIScreen mainScreen].bounds.size.width / 414 * A)


/**
 * 柱状图关联key
 */
static const void * barUpLayer = (__bridge void *)@"barUpLayer";
static const void * barDownLayer = (__bridge void *)@"barDownLayer";
static const void * barNumberArray = (__bridge void *)@"barNumberArray";
static const void * barStringLayer = (__bridge void *)@"barStringLayer";

/**
 * 折线图关联key
 */
static const void * lineLayer = (__bridge void *)@"lineLayer";
static const void * lineShapeLayer = (__bridge void *)@"lineShapeLayer";
static const void * lineShapeGradientLayer = (__bridge void *)@"lineShapeGradientLayer";
static const void * lineFillLayer = (__bridge void *)@"lineFillLayer";
static const void * lineFillGradientLayer = (__bridge void *)@"lineFillGradientLayer";
static const void * lineStringLayer = (__bridge void *)@"lineStringLayer";
static const void * lineStringGradientLayer = (__bridge void *)@"lineStringGradientLayer";
static const void * lineNumberArray = (__bridge void *)@"lineNumberArray";

/**
 * 扇形图关联key
 */
static const void * pieShapeLayerArray = (__bridge void *)@"pieShapeLayerArray";
static const void * pieBaseShapeLayer = (__bridge void *)@"pieBaseShapeLayer";

static const void * pieOutSideLayerArray = (__bridge void *)@"pieOutSideLayerArray";
static const void * pieOutSideNumberArray = (__bridge void *)@"pieOutSideNumberArray";
static const void * pieOutSideLayer = (__bridge void *)@"pieOutSideLayer";

static const void * pieInnerNumberArray = (__bridge void *)@"pieInnerNumberArray";
static const void * pieInnerLayer = (__bridge void *)@"pieInnerLayer";

/**
 * 关联对象(强引用)
 */
#define SET_ASSOCIATED_ASSIGN(obj, key, value)      \
    objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_ASSIGN)

/**
 * 关联对象(弱引用)
 */
#define SET_ASSOCIATED_RETAIN(obj, key, value)      \
    objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

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

