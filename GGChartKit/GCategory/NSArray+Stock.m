//
//  NSArray+Stock.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NSArray+Stock.h"
#import "KLineAbstract.h"

@implementation NSArray (Stock)

/**
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getMax:(CGFloat *)max min:(CGFloat *)min selGetter:(SEL)getter base:(CGFloat)base
{
    if (!self.count) { NSLog(@"array is empty"); return; }
    
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {

        IMP imp = [obj methodForSelector:getter];
        double (*objGetter)(id obj, SEL getter) = (void *)imp;
        double objNumber = objGetter(obj, getter);

        chartMax = objNumber > chartMax ? objNumber : chartMax;
        chartMin = objNumber < chartMin ? objNumber : chartMin;
    }];
    
    CGFloat baseScaler = fabs(chartMax - chartMin) * base;
        
    *max = chartMax += baseScaler;
    *min = chartMin -= baseScaler;
}

/**
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getMax:(CGFloat *)max min:(CGFloat *)min selGetter:(SEL)getter range:(NSRange)range base:(CGFloat)base
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]
                            options:NSEnumerationConcurrent
                         usingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                             
                             IMP imp = [obj methodForSelector:getter];
                             double (*objGetter)(id obj, SEL getter) = (void *)imp;
                             double objNumber = objGetter(obj, getter);
                             
                             chartMax = objNumber > chartMax ? objNumber : chartMax;
                             chartMin = objNumber < chartMin ? objNumber : chartMin;
                         }];
    
    CGFloat baseScaler = fabs(chartMax - chartMin) * base;
    
    *max = chartMax += baseScaler;
    *min = chartMin -= baseScaler;
}

/**
 * 获取二维数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getTwoDimensionaMax:(CGFloat *)max min:(CGFloat *)min selGetter:(SEL)getter base:(CGFloat)base
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self enumerateObjectsUsingBlock:^(NSArray <NSNumber *> * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat subMax = 0;
        CGFloat subMin = 0;
        
        [obj getMax:&subMax min:&subMin selGetter:getter base:base];
        
        chartMax = subMax > chartMax ? subMax : chartMax;
        chartMin = subMin < chartMin ? subMin : chartMin;
    }];
    
    *max = chartMax;
    *min = chartMin;
}

#pragma mark - KLineAbstract

/**
 * NSArray <id <KLineAbstract>>
 * 或区域k线中的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param range 区间
 */
- (void)getKLineMax:(CGFloat *)max min:(CGFloat *)min range:(NSRange)range
{
    __block CGFloat chartMax = FLT_MIN;
    __block CGFloat chartMin = FLT_MAX;
    
    [self enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]
                            options:NSEnumerationConcurrent
                         usingBlock:^(id <KLineAbstract> obj, NSUInteger idx, BOOL * stop) {
        
                             chartMax = obj.ggHigh > chartMax ? obj.ggHigh : chartMax;
                             chartMin = obj.ggLow < chartMin ? obj.ggLow : chartMin;
    }];
    
    *max = chartMax;
    *min = chartMin;
}

/**
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值
 * @param min 最小值
 * @param splitCount 分割数
 * @param format 格式化字符串
 * @param attachedString 附加串
 */
+ (NSArray <NSString *> *)splitWithMax:(CGFloat)max min:(CGFloat)min split:(NSInteger)splitCount format:(NSString *)format attached:(NSString *)attachedString
{
    NSMutableArray * array = [NSMutableArray array];
    CGFloat split = fabs(max - min) / splitCount;
    
    for (int i = 0; i < splitCount; i++) {
        
        NSString * str_t = [NSString stringWithFormat:format, max - split * i];
        
        if (attachedString.length) {
            
            str_t = [NSString stringWithFormat:@"%@%@", str_t, attachedString];
        }
        
        [array addObject:str_t];
    }
    
    NSString * str_t = [NSString stringWithFormat:format, min];
    
    if (attachedString.length) {
        
        str_t = [NSString stringWithFormat:@"%@%@", str_t, attachedString];
    }
    
    [array addObject:str_t];
    
    return array;
}

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
- (NSMutableArray <NSArray <NSNumber *> *> *)aryAddUp
{
    NSMutableArray *aryAddData = [NSMutableArray array];
    
    [aryAddData addObject:self.firstObject];
    
    // 循环简历累加数组
    for (NSInteger i = 1; i < self.count; i++) {
        
        NSArray *ary_c = self[i];
        NSArray *ary_b = aryAddData.lastObject;
        NSMutableArray *aryAddBefor = [NSMutableArray array];
        
        // 累加数组累加数字已当前数组长度为准
        for (NSInteger j = 0; j < ary_c.count; j++) {
            
            //NSInteger f = aryAddData.count - 1;     // find 位置
            CGFloat c = [ary_c[j] floatValue];      // current 当前的数字
            CGFloat b = j >= ary_b.count ? 0 : [ary_b[j] floatValue];     // 临时
            
//            // 前一个数组如果越界, 则前一个数字为当前数字的相反数(保证循环继续)
//            CGFloat b = j >= ary_b.count ? -c : [ary_b[j] floatValue];
//            
//            // 数值同方向才可以相加
//            while ((b * c) < 0) {   // before 和 current 数字正负为同方向跳出循环
//                
//                if (f < 0) {    // find 小于0为找到头
//                    
//                    b = 0;
//                }
//                else {
//                    
//                    NSArray *ary_f_b = aryAddData[f];
//                    
//                    b = j < ary_f_b.count ? [[aryAddData[f] objectAtIndex:j] floatValue] : -c;
//                }
//                
//                f--;    // 非同方向向前寻找
//            }
            
            // 将2数值之和叠加放入本次循环数组
            [aryAddBefor addObject:@(c + b)];
        }
        
        [aryAddData addObject:[NSArray arrayWithArray:aryAddBefor]];
    }
    
    return aryAddData;
}

+ (NSArray *)JsonFromObj:(NSArray <id <KLineAbstract> > *)aryKLine
{
    NSMutableArray * ary = [NSMutableArray array];
    
    [aryKLine enumerateObjectsUsingBlock:^(id<KLineAbstract> obj, NSUInteger idx, BOOL * stop) {
        
        [ary addObject:@{@"open" : @(obj.ggOpen),
                         @"close" : @(obj.ggClose),
                         @"high" : @(obj.ggHigh),
                         @"low" : @(obj.ggLow)}];
    }];
    
    return ary;
}

/**
 * 成交量数组转译成Json
 */
+ (NSArray *)JsonFrmVolums:(NSArray <id <VolumeAbstract> > *)aryVolum
{
    NSMutableArray * ary = [NSMutableArray array];
    
    [aryVolum enumerateObjectsUsingBlock:^(id<VolumeAbstract> obj, NSUInteger idx, BOOL * stop) {
        
        [ary addObject:@{@"volum" : @(obj.ggVolume)}];
    }];
    
    return ary;
}

@end
