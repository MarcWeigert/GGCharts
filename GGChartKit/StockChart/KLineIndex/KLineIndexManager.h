//
//  KLineIndexManager.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineAbstract.h"
#import "VolumeAbstract.h"

#define OPEN    @"open"
#define CLOSE   @"close"
#define HIGH    @"high"
#define LOW     @"low"

#define VOLUM   @"volum"

@interface KLineIndexManager : NSObject

/** 单利指标类 */
+ (KLineIndexManager *)shareInstans;

/**
 * 根据数组数据结构计算MA指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @{@"MA5" : @[...], @"MA10" : @[...], @"MA20" : @[...], @"MA40" : @[...]};
 */
- (NSDictionary *)getMaIndexWith:(NSArray <id <KLineAbstract>> *)aryKLineData
                           param:(NSArray <NSNumber *> *)param
                     priceString:(NSString *)price;

/**
 * 根据数组数据结构计算MA指标数据
 *
 * @param aryKLineData 成交量数据数组, 需要实现接口VolumeAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @{@"MAVOL5" : @[...], @"MAVOL10" : @[...], @"MAVOL20" : @[...], @"MAVOL40" : @[...]};
 */
- (NSDictionary *)getVolumIndexWith:(NSArray <id <VolumeAbstract>> *)aryKLineData
                              param:(NSArray <NSNumber *> *)param
                        priceString:(NSString *)price;

@end
