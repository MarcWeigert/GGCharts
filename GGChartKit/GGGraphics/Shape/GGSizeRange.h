//
//  GGSizeRange.h
//  GGCharts
//
//  Created by _ | Durex on 2017/9/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 极大值极小值结构体
 */
struct GGSizeRange
{
    CGFloat max;
    CGFloat min;
};
typedef struct GGSizeRange GGSizeRange;

/**
 * 构造结构体
 */
CG_INLINE GGSizeRange
GGSizeRangeMake(CGFloat max, CGFloat min)
{
    GGSizeRange range;
    range.max = max;
    range.min = min;
    
    return range;
}

/**
 * 比较GGSizeRange 是否一致
 */
CG_INLINE BOOL
GGSizeRangeEqual(GGSizeRange size_range1, GGSizeRange size_range2)
{
    return size_range1.max == size_range2.max && size_range1.min == size_range2.min;
}

/**
 * NSValue 扩展
 */
@interface NSValue (GGValueGGSizeRangeExtensions)

GGValueMethod(GGSizeRange);

@end

NS_ASSUME_NONNULL_END
