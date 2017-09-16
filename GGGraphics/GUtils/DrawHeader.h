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

#endif /* DrawHeader_h */
