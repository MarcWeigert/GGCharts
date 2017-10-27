//
//  NSArray+Stock.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KLineAbstract.h"
#import "VolumeAbstract.h"

@interface NSArray (GGGraphics)

- (NSArray <NSNumber *> *)numbarArrayForKey:(NSString *)key;


/**
 * 获取数组对象的绝对值最大值
 *
 * @param max 最大值地址
 */
- (void)getAbsMax:(CGFloat *)max selGetter:(SEL)getter;

/**
 * 获取涨跌百分比字符传数组
 *
 * @param baseFloat 基数注意不可以为0
 */
- (NSArray *)percentageStringWithBase:(CGFloat)baseFloat;

/** 
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getMax:(CGFloat *)max
           min:(CGFloat *)min
     selGetter:(SEL)getter
          base:(CGFloat)base;

/**
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getMax:(CGFloat *)max
           min:(CGFloat *)min
     selGetter:(SEL)getter
         range:(NSRange)range
          base:(CGFloat)base;

/**
 * 获取二维数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getTwoDimensionaMax:(CGFloat *)max
                        min:(CGFloat *)min
                  selGetter:(SEL)getter
                       base:(CGFloat)base;

/**
 * 获取字典数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 */
+ (void)getDictionaryArray:(NSArray <NSDictionary <NSString *, NSNumber *> *> *)array
                       max:(CGFloat *)max
                       min:(CGFloat *)min;

#pragma mark - KLineAbstract

/**
 * NSArray <id <KLineAbstract>>
 * 或区域k线中的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param range 区间
 */
- (void)getKLineMax:(CGFloat *)max
                min:(CGFloat *)min
              range:(NSRange)range;

/**
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值
 * @param min 最小值
 * @param splitCount 分割数
 * @param format 格式化字符串
 * @param attachedString 附加串
 */
+ (NSArray <NSString *> *)splitWithMax:(CGFloat)max
                                   min:(CGFloat)min
                                 split:(NSInteger)splitCount
                                format:(NSString *)format
                              attached:(NSString *)attachedString;

/**
 * 二维数组累加, 正数和正数累加, 负数和负数累加
 * 正数:
 * @[@1, @1, @1]    @[@1, @1, @1]
 * @[@1, @1, @1] -> @[@2, @2, @2]
 * @[@1, @1, @1]    @[@3, @3, @3]
 * 负数:
 * @[@-1, @-1, @-1]      @[@-1, @-1, @-1]
 * @[@1,  @1,  @1]    -> @[@1, @1, @1]
 * @[@1,  @1,  @1]       @[@2, @2, @2]
 */
- (NSMutableArray <NSArray <NSNumber *> *> *)aryPNAddUp;

/**
 * 二维数组累加, 正数和正数累加, 负数和负数累加
 * 正数:
 * @[@1, @1, @1]    @[@1, @1, @1]
 * @[@1, @1, @1] -> @[@2, @2, @2]
 * @[@1, @1, @1]    @[@3, @3, @3]
 * 负数:
 * @[@-1, @-1, @-1]      @[@-1, @-1, @-1]
 * @[@1,  @1,  @1]    -> @[@0, @0, @0]
 * @[@1,  @1,  @1]       @[@1, @1, @1]
 */
- (NSMutableArray <NSArray <NSNumber *> *> *)aryAddUp;

/**
 * K 线数组转译成Json
 */
+ (NSArray *)JsonFromObj:(NSArray <id <KLineAbstract> > *)aryKLine;

/**
 * 成交量数组转译成Json
 */
+ (NSArray *)JsonFrmVolums:(NSArray <id <VolumeAbstract> > *)aryVolum;

/**
 * 获取颜色数组
 *
 * UIColor -> CGColor
 */
- (NSArray *)getCGColorsArray;

@end
